import 'package:lyxa_live/src/features/auth/domain/entities/app_user.dart';

/// AUTH STATE
/// -> Represents the different states for authentication.

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final AppUser user;

  Authenticated(this.user);
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}
