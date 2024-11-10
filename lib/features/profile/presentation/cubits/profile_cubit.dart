import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/constants/app_strings.dart';
import 'package:lyxa_live/features/profile/domain/repositories/profile_repository.dart';
import 'package:lyxa_live/features/profile/presentation/cubits/profile_state.dart';
import 'package:lyxa_live/features/storage/domain/storage_repository.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository profileRepository;
  final StorageRepository storageRepository;

  ProfileCubit({
    required this.profileRepository,
    required this.storageRepository,
  }) : super(ProfileInitial());

  // Fetch user profile using repository
  Future<void> fetchUserProfile(String uid) async {
    try {
      emit(ProfileLoading());
      final user = await profileRepository.fetchUserProfile(uid);

      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(ProfileError(AppStrings.userNotFoundError));
      }
    } catch (error) {
      emit(ProfileError(error.toString()));
    }
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
      final currentUser = await profileRepository.fetchUserProfile(uid);

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
          imageDownloadUrl = await storageRepository.uploadProfileImageMobile(
              imageMobilePath, uid);
        }
        // Web
        else if (imageWebBytes != null) {
          // Upload
          imageDownloadUrl =
              await storageRepository.uploadProfileImageWeb(imageWebBytes, uid);
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
      await profileRepository.updateProfile(updatedProfile);

      // Re-fetch updated profile
      await fetchUserProfile(uid);
    } catch (error) {
      emit(ProfileError('Error updating profile: ${error.toString()}'));
    }
  }
}
