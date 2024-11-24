import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/di/service_locator.dart';
import 'package:lyxa_live/src/shared/handlers/errors/utils/error_messages.dart';

import 'package:lyxa_live/src/shared/handlers/errors/utils/error_type.dart';
import 'error_state.dart';

class ErrorAlertCubit extends Cubit<ErrorAlertState> {
  ErrorAlertCubit()
      : super(ErrorAlertState(errorType: ErrorType.unknown, onRetry: () {}));

  void showError({
    required ErrorType errorType,
    String? customMessage,
    required VoidCallback onRetry,
  }) {
    emit(state.copyWith(
      isVisible: true,
      errorMessage: customMessage ?? _getErrorMessage(errorType),
      errorType: errorType,
      onRetry: onRetry,
    ));
  }

  void hideError() {
    emit(state.copyWith(isVisible: false));
  }

  static void showErrorMessage({
    required ErrorType errorType,
    String? customMessage,
    required VoidCallback onRetry,
  }) {
    getIt<ErrorAlertCubit>().showError(
        customMessage: customMessage, errorType: errorType, onRetry: onRetry);
  }

  static void hideErrorMessage() {
    getIt<ErrorAlertCubit>().hideError();
  }

  String _getErrorMessage(ErrorType errorType) {
    switch (errorType) {
      case ErrorType.networkError:
        return ErrorMsgs.networkError;
      case ErrorType.timeoutError:
        return ErrorMsgs.timeoutError;
      case ErrorType.authenticationError:
        return ErrorMsgs.authenticationError;
      case ErrorType.permissionDenied:
        return ErrorMsgs.permissionDeniedError;
      case ErrorType.unknown:
      default:
        return ErrorMsgs.unknownError;
    }
  }
}
