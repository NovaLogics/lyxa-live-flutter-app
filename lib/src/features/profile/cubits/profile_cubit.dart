import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:lyxa_live/src/core/di/service_locator.dart';
import 'package:lyxa_live/src/core/resources/app_strings.dart';
import 'package:lyxa_live/src/features/auth/cubits/auth_cubit.dart';
import 'package:lyxa_live/src/features/profile/domain/entities/profile_user.dart';
import 'package:lyxa_live/src/features/profile/domain/repositories/profile_repository.dart';
import 'package:lyxa_live/src/features/profile/cubits/profile_state.dart';
import 'package:lyxa_live/src/features/storage/domain/storage_repository.dart';
import 'package:lyxa_live/src/shared/entities/result/result.dart';
import 'package:lyxa_live/src/shared/handlers/errors/utils/error_handler.dart';
import 'package:lyxa_live/src/shared/handlers/errors/utils/error_messages.dart';

// PROFILE STATE MANAGEMENT
class ProfileCubit extends Cubit<ProfileState> {
  static const String debugTag = 'ProfileCubit';
  final ProfileRepository _profileRepository;
  final StorageRepository _storageRepository;
  ProfileUser? _currentAppProfileUser;

  ProfileCubit({
    required ProfileRepository profileRepository,
    required StorageRepository storageRepository,
  })  : _storageRepository = storageRepository,
        _profileRepository = profileRepository,
        super(ProfileInitial());

  Future<ProfileUser> getCurrentUser() async {
    if (_currentAppProfileUser != null) {
      return _currentAppProfileUser as ProfileUser;
    } else {
      return await _getCurrentUser();
    }
  }

  Future<ProfileUser> _getCurrentUser() async {
    final currentUser = getIt<AuthCubit>().currentUser;
    if (currentUser == null) {
      throw Exception(ErrorMsgs.cannotFetchProfileError);
    }
    _currentAppProfileUser = await getUserProfileById(
      userId: currentUser.uid,
    );

    if (_currentAppProfileUser == null) {
      throw Exception(ErrorMsgs.cannotFetchProfileError);
    }

    return _currentAppProfileUser as ProfileUser;
  }

  Future<ProfileUser?> getUserProfileById({required String userId}) async {
    final getUserResult =
        await _profileRepository.getUserProfileById(userId: userId);

    if (getUserResult.isDataNotNull()) {
      return getUserResult.data as ProfileUser;
    }
    return null;
  }

  Future<void> loadUserProfileById({required String userId}) async {
    emit(ProfileLoading());

    final getUserResult =
        await _profileRepository.getUserProfileById(userId: userId);

    switch (getUserResult.status) {
      case Status.success:
        if (getUserResult.data != null) {
          emit(ProfileLoaded(getUserResult.data as ProfileUser));
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
    emit(ProfileLoading());
    final currentUser = await getCurrentUser();

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
        return;
      }

      imageDownloadUrl = imageUploadResult.data as String;
    }

    final updatedProfile = currentUser.copyWith(
      newBio: updatedBio ?? currentUser.bio,
      newProfileImageUrl: imageDownloadUrl ?? currentUser.profileImageUrl,
    );

    final updateProfileResult = await _profileRepository.updateProfile(
      updatedProfile: updatedProfile,
    );

    if (updateProfileResult.status == Status.error) {
      _handleErrors(
        result: updateProfileResult,
        tag: '$debugTag: updateProfile()::updateProfileResult',
      );
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

  // HELPER FUNCTIONS ▼

  void _handleErrors(
      {required Result result, String? prefixMessage, String? tag}) {
    // FIREBASE ERROR
    if (result.isFirebaseError()) {
      emit(ProfileError(result.getFirebaseAlert()));
    }
    // GENERIC ERROR
    else if (result.isGenericError()) {
      ErrorHandler.handleError(
        result.getGenericErrorData(),
        prefixMessage: prefixMessage,
        tag: tag,
        onRetry: () {},
      );
    }
    // KNOWN ERRORS
    else if (result.isMessageError()) {
      ErrorHandler.handleError(
        null,
        tag: tag,
        customMessage: result.getMessageErrorAlert(),
        onRetry: () {},
      );
    }
  }

   /// Returns platform specific image cropper settings
  List<PlatformUiSettings> _getImageCropperSettings() {
    return [
      AndroidUiSettings(
        toolbarTitle: AppStrings.cropperTitle,
        toolbarColor: Colors.deepPurple,
        toolbarWidgetColor: Colors.white,
        lockAspectRatio: true,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio16x9,
          CropAspectRatioPreset.ratio4x3,
        ],
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
