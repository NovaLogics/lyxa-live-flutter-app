import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/resources/app_strings.dart';
import 'package:lyxa_live/src/features/profile/domain/entities/profile_user.dart';
import 'package:lyxa_live/src/features/profile/domain/repositories/profile_repository.dart';
import 'package:lyxa_live/src/features/profile/cubits/profile_state.dart';
import 'package:lyxa_live/src/features/storage/domain/storage_repository.dart';
import 'package:lyxa_live/src/shared/entities/result/result.dart';
import 'package:lyxa_live/src/shared/handlers/errors/utils/error_handler.dart';

// PROFILE STATE MANAGEMENT
class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _profileRepository;
  final StorageRepository _storageRepository;

  ProfileCubit({
    required ProfileRepository profileRepository,
    required StorageRepository storageRepository,
  })  : _storageRepository = storageRepository,
        _profileRepository = profileRepository,
        super(ProfileInitial());

  // Fetch user profile using repository -> useful for loading profile pages
  Future<void> fetchUserProfile(String uid) async {
    try {
      emit(ProfileLoading());
      final user = await _profileRepository.getUserProfileById(uid);

      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(ProfileError(AppStrings.userNotFoundError));
      }
    } catch (error) {
      emit(ProfileError(error.toString()));
    }
  }

  // Return user profile given uid -> useful for loading many profiles for posts
  Future<ProfileUser?> getUserProfile(String uid) async {
    final user = await _profileRepository.getUserProfileById(uid);
    return user;
  }

  // Update bio / profile picture
  Future<void> updateProfile({
    required String uid,
    String? newBio,
    String? imageMobilePath,
    Uint8List? imageWebBytes,
  }) async {
    try {
      emit(ProfileLoading());
      // Fetch current user profile
      final currentUser = await _profileRepository.getUserProfileById(uid);

      if (currentUser == null) {
        emit(ProfileError(AppStrings.failedToFetchUserError));
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
              imageMobilePath, uid);
        }
        // Web
        else if (imageWebBytes != null) {
          // Upload
          imageDownloadUrl = await _storageRepository.uploadProfileImageWeb(
              imageWebBytes, uid);
        }

        if (imageDownloadUrl == null) {
          emit(ProfileError('Failed to upload image'));
          return;
        }
      }

      // Update new profile
      final updatedProfile = currentUser.copyWith(
        newBio: newBio ?? currentUser.bio,
        newProfileImageUrl: imageDownloadUrl ?? currentUser.profileImageUrl,
      );

      // Update in Repository
      await _profileRepository.updateProfile(updatedProfile);

      // Re-fetch updated profile
      await fetchUserProfile(uid);
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
