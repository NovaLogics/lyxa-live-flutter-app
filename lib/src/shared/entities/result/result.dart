import 'package:lyxa_live/src/shared/entities/result/errors/error_wrapper.dart';
import 'package:lyxa_live/src/shared/entities/result/errors/firebase_error.dart';
import 'package:lyxa_live/src/shared/entities/result/errors/generic_error.dart';

enum Status { success, error,  }

class Result<T> {
  final T? data;
  final Status status;
  final ErrorWrapper? error;

  const Result._({
    this.data,
    required this.status,
    this.error,
  });

  /// Factory constructor for success state
  factory Result.success(T data) {
    return Result._(data: data, status: Status.success);
  }

  /// Factory constructor for error state with generic or firebase error
  factory Result.error(Object error) {
    ErrorWrapper errorWrapper;

    if (error is FirebaseError) {
      errorWrapper = ErrorWrapper(firebaseError: error);
    } else if (error is GenericError) {
      errorWrapper = ErrorWrapper(genericError: error);
    } else {
      errorWrapper = ErrorWrapper(genericError: GenericError(error: error));
    }

    return Result._(status: Status.error, error: errorWrapper);
  }

  // /// Factory constructor for loading state
  // factory Result.loading() {
  //   return const Result._(status: Status.loading);
  // }

  bool isDataNotEmpty() {
    return (data != null && data is T);
  }

    bool isGenericError() {
    return error?.isGenericError ?? false;
  }

  bool isFirebaseError() {
    return error?.isFirebaseError ?? false;
  }
}
