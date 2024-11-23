class NetworkException implements Exception {
  final String message;

  NetworkException([this.message = 'Network error occurred.']);
}

class TimeoutException implements Exception {
  final String message;

  TimeoutException([this.message = 'Request timed out.']);
}

class AuthenticationException implements Exception {
  final String message;

  AuthenticationException([this.message = 'Authentication failed.']);
}

class UnknownException implements Exception {
  final String message;

  UnknownException([this.message = 'An unexpected error occurred.']);
}
