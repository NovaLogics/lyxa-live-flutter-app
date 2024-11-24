import 'package:firebase_auth/firebase_auth.dart';
import 'package:lyxa_live/src/core/utils/logger.dart';

class FirebaseErrorHandler {
  /// Handles a FirebaseAuthException by logging and re-throwing a formatted exception.
  static void handleAuthError(FirebaseAuthException authError) {
    final String errorMessage = getMessage(authError.code);


    Logger.logError('AuthError: ${authError.code}');
    Logger.logError('Message: $errorMessage');


    throw Exception(errorMessage);
  }

  /// Maps Firebase error codes to user-friendly error messages.
  static String getMessage(String errorCode) {
    switch (errorCode) {
      case 'invalid-credential':
        return 'The credential provided is invalid or has expired. Please try again.';
      case 'email-already-in-use':
        return 'The email address is already in use by another account.';
      case 'wrong-password':
        return 'The password is invalid. Please try again.';
      case 'user-not-found':
        return 'No user found for this email. Please register first.';
      case 'user-disabled':
        return 'This user account has been disabled. Contact support.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'weak-password':
        return 'The password is too weak. Please choose a stronger password.';
      default:
        return 'An unknown error occurred. Please try again.';
    }
  }
}
