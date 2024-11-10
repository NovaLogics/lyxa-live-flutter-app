import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/constants/app_strings.dart';
import 'package:lyxa_live/features/profile/domain/repositories/profile_repository.dart';
import 'package:lyxa_live/features/profile/presentation/cubits/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository profileRepository;
  ProfileCubit({required this.profileRepository}) : super(ProfileInitial());

  // Fetch user profile using repository
  Future<void> fetchUserProfile(String uid) async {
    try {
      emit(ProfileLoading());
      final user = await profileRepository.fetchUserProfile(uid);

      if (user != null) {
        emit(ProfileLoaded(user));
      }
      else{
        emit(ProfileError(AppStrings.userNotFoundError));
      }
    } catch (error) {
      emit(ProfileError(error.toString()));
    }
  }

  // Update bio / profile picture
}
