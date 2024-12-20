class FirebaseErrorUtil {
  static String getMessageFromErrorCode(String errorCode) {
    switch (errorCode) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        return "Email already used. Go to login page.";
      case "ERROR_WRONG_PASSWORD":
      case "wrong-password":
        return "Wrong email/password combination.";
      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
        return "No user found with this email.";
      case "ERROR_USER_DISABLED":
      case "user-disabled":
        return "User disabled.";
      case "ERROR_TOO_MANY_REQUESTS":
      case "too-many-requests":
        return "Too many requests to log into this account.";
      case "ERROR_OPERATION_NOT_ALLOWED":
      case "operation-not-allowed":
        return "Server error, please try again later.";
      case "ERROR_INVALID_EMAIL":
      case "invalid-email":
        return "Email address is invalid.";
      default:
        return "Login Failed. Please try again.";
    }
  }

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
