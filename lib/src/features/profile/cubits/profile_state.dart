import 'package:lyxa_live/src/features/profile/domain/entities/profile_user_entity.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileUserEntity profileUser;
  ProfileLoaded(this.profileUser);
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

class ProfileErrorToast extends ProfileState {
  final String message;
  ProfileErrorToast(this.message);
}

class ProfileErrorException extends ProfileState {
  final Object? error;
  ProfileErrorException(this.error);
}
