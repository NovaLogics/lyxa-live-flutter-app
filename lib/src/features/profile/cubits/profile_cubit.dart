import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:lyxa_live/src/core/di/service_locator.dart';
import 'package:lyxa_live/src/core/constants/resources/app_strings.dart';
import 'package:lyxa_live/src/core/utils/logger.dart';
import 'package:lyxa_live/src/features/auth/cubits/auth_cubit.dart';
import 'package:lyxa_live/src/features/profile/data/models/profile_user_model.dart';
import 'package:lyxa_live/src/features/profile/domain/entities/profile_user_entity.dart';
import 'package:lyxa_live/src/features/profile/domain/repositories/profile_repository.dart';
import 'package:lyxa_live/src/features/profile/cubits/profile_state.dart';
import 'package:lyxa_live/src/features/storage/domain/repositories/storage_repository.dart';
import 'package:lyxa_live/src/shared/entities/result/result.dart';
import 'package:lyxa_live/src/shared/handlers/errors/utils/error_messages.dart';
import 'package:lyxa_live/src/shared/handlers/loading/cubits/loading_cubit.dart';

// PROFILE STATE MANAGEMENT
class ProfileCubit extends Cubit<ProfileState> {
  static const String debugTag = 'ProfileCubit';
  final ProfileRepository _profileRepository;
  final StorageRepository _storageRepository;
  ProfileUserEntity? _currentAppProfileUser;

  ProfileCubit({
    required ProfileRepository profileRepository,
    required StorageRepository storageRepository,
  })  : _storageRepository = storageRepository,
        _profileRepository = profileRepository,
        super(ProfileInitial());

  void resetUser() {
    _currentAppProfileUser = null;
  }

  Future<ProfileUserEntity> getCurrentUser() async {
    if (_currentAppProfileUser != null) {
      return _currentAppProfileUser as ProfileUserEntity;
    } else {
      return await _getCurrentUser();
    }
  }

  Future<ProfileUserEntity> _getCurrentUser() async {
    _showLoading(AppStrings.loadingMessage);
    final currentUser = getIt<AuthCubit>().currentUser;
    if (currentUser == null) {
      _hideLoading();
      throw Exception(ErrorMsgs.cannotFetchProfileError);
    }
    _currentAppProfileUser = await getUserProfileById(
      userId: currentUser.uid,
    );

    if (_currentAppProfileUser == null) {
      _hideLoading();
      throw Exception(ErrorMsgs.cannotFetchProfileError);
    }

    _hideLoading();

    return _currentAppProfileUser as ProfileUserEntity;
  }

  Future<ProfileUserEntity?> getUserProfileById({
    required String userId,
  }) async {
    final getUserResult =
        await _profileRepository.getUserProfileById(userId: userId);

    if (getUserResult.isDataNotNull()) {
      return getUserResult.data as ProfileUserEntity;
    }
    return null;
  }

  Future<void> loadUserProfileById({
    required String userId,
  }) async {
    _showLoading(AppStrings.loadingMessage);

    final getUserResult =
        await _profileRepository.getUserProfileById(userId: userId);

    _hideLoading();

    switch (getUserResult.status) {
      case Status.success:
        if (getUserResult.data != null) {
          emit(ProfileLoaded(getUserResult.data as ProfileUserEntity));
        } else {
          emit(ProfileError(AppStrings.userNotFoundError));
        }
        break;

      case Status.error:
        _handleErrors(
          result: getUserResult,
          tag: '$debugTag: getUserProfileById()',
        );
        break;
    }
  }

  Future<void> updateProfile({
    required String userId,
    String? updatedBio,
    Uint8List? imageBytes,
  }) async {
    _showLoading(AppStrings.updating);

    final currentUser = await getCurrentUser();
    final profileUser = ProfileUserModel.fromEntity(currentUser);

    String? imageDownloadUrl;

    if (imageBytes != null) {
      final imageUploadResult = await _storageRepository.uploadProfileImage(
        imageFileBytes: imageBytes,
        fileName: userId,
      );

      if (imageUploadResult.status == Status.error) {
        _handleErrors(
          result: imageUploadResult,
          tag: '$debugTag: updateProfile()::imageUploadResult',
        );
        _hideLoading();
        return;
      }

      imageDownloadUrl = imageUploadResult.data as String;
      //await DefaultCacheManager().emptyCache();
      await CachedNetworkImage.evictFromCache(profileUser.profileImageUrl);
    }

    final updatedProfile = profileUser
        .copyWith(
          newBio: updatedBio ?? currentUser.bio,
          newProfileImageUrl: imageDownloadUrl ?? currentUser.profileImageUrl,
        )
        .toEntity();

    final updateProfileResult = await _profileRepository.updateProfile(
      updatedProfile: updatedProfile,
    );

    Logger.logDebug(updatedProfile.toString(),
        tag: '$debugTag: updateProfile() User');

    if (updateProfileResult.status == Status.error) {
      _handleErrors(
        result: updateProfileResult,
        tag: '$debugTag: updateProfile()::updateProfileResult',
      );
      _hideLoading();
      return;
    }

    await loadUserProfileById(userId: userId);
  }

  Future<void> toggleFollow({
    required String appUserId,
    required String targetUserId,
  }) async {
    final toggleFollowResult = await _profileRepository.toggleFollow(
      appUserId: appUserId,
      targetUserId: targetUserId,
    );

    if (toggleFollowResult.status == Status.error) {
      _handleErrors(
        result: toggleFollowResult,
        tag: '$debugTag: toggleFollow()',
      );
    }
  }

  Future<Uint8List?> getSelectedImage() async {
    try {
      final pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: kIsWeb,
      );
      if (pickedFile == null) return null;

      if (kIsWeb) {
        // WEB
        return pickedFile.files.single.bytes;
      } else {
        // MOBILE
        final filePath = pickedFile.files.single.path!;
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: filePath,
          compressFormat: ImageCompressFormat.jpg,
          uiSettings: _getImageCropperSettings(),
        );

        if (croppedFile == null) return null;

        final compressedImage = await _compressImage(croppedFile.path);

        if (compressedImage == null) throw Exception(ErrorMsgs.imageFileEmpty);

        return compressedImage;
      }
    } catch (error) {
      emit(ProfileErrorException(error));
    }
    return null;
  }

  // HELPER FUNCTIONS ▼

  void _showLoading(String message) {
    return LoadingCubit.showLoading(message: message);
  }

  void _hideLoading() {
    LoadingCubit.hideLoading();
  }

  void _handleErrors({required Result result, String? tag}) {
    // FIREBASE ERROR
    if (result.isFirebaseError()) {
      emit(ProfileErrorToast(result.getFirebaseAlert()));
    }
    // GENERIC ERROR
    else if (result.isGenericError()) {
      emit(ProfileErrorException(result.getGenericErrorData()));
    }
    // KNOWN ERRORS
    else if (result.isMessageError()) {
      emit(ProfileError(result.getMessageErrorAlert()));
    }
  }

  /// Returns platform specific image cropper settings
  List<PlatformUiSettings> _getImageCropperSettings() {
    return [
      AndroidUiSettings(
        toolbarTitle: AppStrings.cropperTitle,
        toolbarColor: Colors.deepPurple,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.square,
        cropStyle: CropStyle.circle,
        lockAspectRatio: true,
        aspectRatioPresets: [CropAspectRatioPreset.square],
      ),
      IOSUiSettings(
        title: AppStrings.cropperTitle,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio16x9,
          CropAspectRatioPreset.ratio4x3,
        ],
      ),
    ];
  }

  /// Compresses image to reduce size
  Future<Uint8List?> _compressImage(String filePath) async {
    return await FlutterImageCompress.compressWithFile(
      filePath,
      minWidth: 800,
      minHeight: 800,
      quality: 90,
    );
  }
}
