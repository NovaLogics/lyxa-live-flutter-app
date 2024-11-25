import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/utils/logger.dart';
import 'package:lyxa_live/src/shared/handlers/errors/cubits/error_cubit.dart';
import 'package:lyxa_live/src/shared/handlers/errors/utils/custom_exceptions.dart';
import 'package:lyxa_live/src/shared/handlers/errors/utils/error_type.dart';

class ErrorHandler {
  static void handleError(
    Object? error, {
    StackTrace? stackTrace,
    String? customMessage,
    String? prefixMessage,
    String? tag,
    required VoidCallback onRetry,
  }) {
    String errorMessage = "An unexpected error occurred.";
    ErrorType errorType = ErrorType.unknown;

    if (customMessage == null || customMessage.isEmpty) {
      if (error == null) {
        errorMessage = "An unexpected error occurred.";
        errorType = ErrorType.unknown;
      } else if (error is NetworkException) {
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
    } else {
      errorMessage = customMessage;
    }

    if (prefixMessage != null && prefixMessage.isNotEmpty) {
      errorMessage = '$prefixMessage : \n $errorMessage';
    }

    Logger.logError(
      'Unexpected Error: \n|> ${error.toString()}', tag: tag?? 'Logger'
    );
    Logger.logError(
      'StackTrace:> ${stackTrace.toString()}', tag: tag?? 'Logger'
    );

    ErrorAlertCubit.showErrorMessage(
      errorType: errorType,
      customMessage: errorMessage,
      onRetry: () {
        onRetry.call();
        ErrorAlertCubit.hideErrorMessage();
      },
    );
  }
}
