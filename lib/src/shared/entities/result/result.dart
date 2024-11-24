class Result<T> {
  final T? data;
  final Status status;
  final Object? error;
  final String? errorMessage;

  const Result._(
      {this.data, required this.status, this.error, this.errorMessage});

  /// Factory constructor for success state
  factory Result.success(T data) {
    return Result._(data: data, status: Status.success);
  }

  /// Factory constructor for error state
  factory Result.error(Object error) {
    return Result._(status: Status.error, error: error);
  }

  /// Factory constructor for error Message state
  factory Result.errorMessage(String errorMessage) {
    return Result._(status: Status.errorMessage, errorMessage: errorMessage);
  }

  /// Factory constructor for loading state
  factory Result.loading() {
    return const Result._(status: Status.loading);
  }

  bool isDataNotEmpty() {
    return (data != null && data is T);
  }
}

/// Enum to represent the state of the result
enum Status { loading, success, error, errorMessage }
