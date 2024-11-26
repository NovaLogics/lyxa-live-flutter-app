import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
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

    _currentAppProfileUser = await getUserProfileById(userId: currentUser.uid);

    if (_currentAppProfileUser == null) {
      throw Exception(ErrorMsgs.cannotFetchProfileError);
    }

    return _currentAppProfileUser as ProfileUser;
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

  Future<ProfileUser?> getUserProfileById({required String userId}) async {
    final getUserResult =
        await _profileRepository.getUserProfileById(userId: userId);

    if (getUserResult.isDataNotNull()) {
      return getUserResult.data as ProfileUser;
    }
    return null;
  }

  Future<void> updateProfile({
    required String userId,
    String? updatedBio,
    Uint8List? imageBytes,
  }) async {
    try {
      emit(ProfileLoading());
      final currentUser = await _profileRepository.getUserProfileById(userId);

      if (currentUser == null) {
        emit(ProfileError(AppStrings.failedToFetchUserError));
        return;
      }

      final imageUploadResult = await _storageRepository.uploadProfileImage(
        imageFileBytes: imageBytes,
        fileName: userId,
      );

      if (imageUploadResult.status == Status.error) {
        _handleErrors(
          result: imageUploadResult,
          tag: '$debugTag: addPost()::imageUploadResult',
        );
        return;
      }

      // Profile picture update
      String? imageDownloadUrl;

      // Ensure there is an image
      if (imageMobilePath != null || imageWebBytes != null) {
        // Mobile
        if (imageMobilePath != null) {
          // Upload
          imageDownloadUrl = await _storageRepository.uploadProfileImageMobile(
              imageMobilePath, userId);
        }
        // Web
        else if (imageWebBytes != null) {
          // Upload
          imageDownloadUrl = await _storageRepository.uploadProfileImageWeb(
              imageWebBytes, userId);
        }

        if (imageDownloadUrl == null) {
          emit(ProfileError('Failed to upload image'));
          return;
        }
      }

      // Update new profile
      final updatedProfile = currentUser.copyWith(
        newBio: updatedBio ?? currentUser.bio,
        newProfileImageUrl: imageDownloadUrl ?? currentUser.profileImageUrl,
      );

      // Update in Repository
      await _profileRepository.updateProfile(updatedProfile);

      // Re-fetch updated profile
      await loadUserProfileById(userId);
    } catch (error) {
      emit(ProfileError('Error updating profile: ${error.toString()}'));
    }
  }

  // Toggle follow/unfollow
  Future<void> toggleFollow(String currentUid, String targetUid) async {
    try {
      await _profileRepository.toggleFollow(currentUid, targetUid);
    } catch (error) {
      emit(ProfileError('Error toggling follow: ${error.toString()}'));
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
}
