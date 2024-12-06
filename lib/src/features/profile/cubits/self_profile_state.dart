import 'package:lyxa_live/src/features/profile/domain/entities/profile_user_entity.dart';

abstract class SelfProfileState {}

class SelfProfileInitial extends SelfProfileState {}

class SelfProfileLoading extends SelfProfileState {}


class SelfProfileLoaded extends SelfProfileState {
  final ProfileUserEntity profileUser;
  SelfProfileLoaded(this.profileUser);
}

class SelfProfileError extends SelfProfileState {
  final String message;
  SelfProfileError(this.message);
}


class SelfProfileErrorToast extends SelfProfileState {
  final String message;
  SelfProfileErrorToast(this.message);
}

class SelfProfileErrorException extends SelfProfileState {
  final Object? error;
  SelfProfileErrorException(this.error);
}
