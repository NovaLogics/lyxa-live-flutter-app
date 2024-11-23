import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/shared/event_handlers/errors/utils/error_messages.dart';

import 'package:lyxa_live/src/shared/event_handlers/errors/utils/error_type.dart';
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

  String _getErrorMessage(ErrorType errorType) {
    switch (errorType) {
      case ErrorType.networkError:
        return ErrorMessages.networkError;
      case ErrorType.timeoutError:
        return ErrorMessages.timeoutError;
      case ErrorType.authenticationError:
        return ErrorMessages.authenticationError;
      case ErrorType.permissionDenied:
        return ErrorMessages.permissionDeniedError;
      case ErrorType.unknown:
      default:
        return ErrorMessages.unknownError;
    }
  }
}
