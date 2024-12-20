class ErrorMsgs {
  static const String loginFailedError = 'Login Failed: ';
  static const String loginErrorMessage =
      'Please enter both email and password';
  static const String registrationFailedError = 'Registration Failed: ';
  static const String generalError = 'An error occurred: ';
  static const String errorMessage = 'Something went wrong';

  static const failedToRetrieveUserId =
      'Failed to retrieve user ID after authentication.';
  static const userDataNotFound = 'User data not found in Database.';

  static const cannotFetchProfileError =
      'Cannot fetch profile! Please login again';

  static const cannotFetchPostError =
      'Cannot fetch post data! Please login again';

  static const String unexpectedError =
      'An unexpected error occurred. Please try again.';

  static const String postCreationError =
      'Failed to create post. Please try again!';

  static const String failToLoadPostError =
      'Failed to fetch posts. Please try again!';

  static const String imageFileEmpty = 'Image file is missing or invalid!';

  static const String unknownFunction = 'UnknownFunction';
  static const String functionExtractFailError =
      'Error extracting function name from stack trace:';

  static const String unknownError = 'Something went wrong. Please try again.';
  static const String networkError =
      'No internet connection. Please check your network.';
  static const String timeoutError =
      'Request timed out. Please try again later.';
  static const String authenticationError =
      'Authentication failed. Please try again!';
  static const String permissionDeniedError =
      'You do not have permission to perform this action.';
  static const String retryButtonLabel = 'Retry';
  static const String closeButtonLabel = 'Close';
}
