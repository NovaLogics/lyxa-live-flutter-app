import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/utils/logger.dart';
import 'package:lyxa_live/src/shared/handlers/errors/cubits/error_cubit.dart';
import 'package:lyxa_live/src/shared/handlers/errors/utils/custom_exceptions.dart';
import 'package:lyxa_live/src/shared/handlers/errors/utils/error_type.dart';

class ErrorHandler {
  static void handleError(
    Object error, {
    StackTrace? stackTrace,
    String? customMessage,
    required VoidCallback onRetry,
  }) {
    String errorMessage = "An unexpected error occurred.";
    ErrorType errorType = ErrorType.unknown;

    if (error is NetworkException) {
      errorMessage = error.message;
      errorType = ErrorType.networkError;
    } else if (error is TimeoutException) {
      errorMessage = error.message;
      errorType = ErrorType.timeoutError;
    } else if (error is AuthenticationException) {
      errorMessage = error.message;
      errorType = ErrorType.authenticationError;
    } else if (error is Exception) {
      errorMessage = error.toString().replaceFirst('Exception: ', 'Error: ');
    }

    customMessage ??= errorMessage;

    Logger.logError(
      'Unexpected Error: ${error.toString()} | stackTrace: ${stackTrace.toString()}',
    );

    ErrorAlertCubit.showErrorMessage(
      errorType: errorType,
      customMessage: customMessage,
      onRetry: onRetry,
    );
  }
}
