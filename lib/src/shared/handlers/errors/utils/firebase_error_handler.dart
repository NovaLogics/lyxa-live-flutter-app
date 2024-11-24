import 'package:firebase_auth/firebase_auth.dart';
import 'package:lyxa_live/src/core/utils/logger.dart';

class FirebaseErrorHandler {
  /// Handles a FirebaseAuthException by logging and re-throwing a formatted exception.
  static void handleError(FirebaseException error) {
    final String errorMessage = getMessage(error.code);

    Logger.logError('Firebase Error: ${error.code}');
    Logger.logError('Firebase Error Message: $errorMessage');

    throw Exception(errorMessage);
  }

  /// Maps Firebase error codes to user-friendly error messages.
  static String getMessage(String errorCode) {
    switch (errorCode) {
      // Authentication Errors
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
        return 'Too many attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'This operation is not allowed. Please contact support.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'weak-password':
        return 'The password is too weak. Please choose a stronger password.';

      // Firestore Errors
      case 'permission-denied':
        return 'You do not have permission to perform this action.';
      case 'unavailable':
        return 'The service is currently unavailable. Please try again later.';
      case 'not-found':
        return 'The requested data could not be found.';
      case 'already-exists':
        return 'The data you are trying to create already exists.';
      case 'deadline-exceeded':
        return 'The request took too long to complete. Please try again.';
      case 'cancelled':
        return 'The request was cancelled. Please try again.';

      // General or Unknown Errors
      default:
        return 'An unknown error occurred. Please try again.';
    }
  }
}
