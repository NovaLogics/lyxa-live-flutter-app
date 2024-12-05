import 'package:lyxa_live/src/features/auth/domain/entities/app_user_entity.dart';

/// AUTH STATE
/// -> Represents the different states for authentication.

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Unauthenticated extends AuthState {}

class Authenticated extends AuthState {
  final AppUserEntity user;

  Authenticated(this.user);
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}
