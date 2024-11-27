import 'package:lyxa_live/src/features/profile/domain/entities/profile_user.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileUser profileUser;
  ProfileLoaded(this.profileUser);
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}
