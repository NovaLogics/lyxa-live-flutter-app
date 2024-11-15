import 'package:lyxa_live/src/features/auth/domain/entities/app_user.dart';

/// AUTH STATE
/// -> Represents the different states for authentication.

abstract class AuthState {}

// INITIAL STATE -> before any authentication action is taken
class AuthInitial extends AuthState {}

// LOADING STATE -> indicating that an authentication action is in progress
class AuthLoading extends AuthState {}

// AUTHENTICATED STATE -> containing the authenticated user
class Authenticated extends AuthState {
  final AppUser user;

  Authenticated(this.user);
}

// UNAUTHENTICATED STATE -> indicating that the user is not authenticated
class Unauthenticated extends AuthState {
    final AppUser? user;

  Unauthenticated(this.user);
}

// ERROR STATE -> containing an error message when authentication fails
class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}
