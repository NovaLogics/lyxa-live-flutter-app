import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/constants/app_strings.dart';
import 'package:lyxa_live/features/profile/domain/repositories/profile_repository.dart';
import 'package:lyxa_live/features/profile/presentation/cubits/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository profileRepository;
  ProfileCubit({required this.profileRepository}) : super(ProfileInitial());

  // Fetch user profile using repository
 

  // Update bio / profile picture
}
