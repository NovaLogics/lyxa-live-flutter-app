import 'package:flutter/material.dart';

import 'package:lyxa_live/src/shared/event_handlers/errors/utils/error_type.dart';

class ErrorAlertState {
  final bool isVisible;
  final String errorMessage;
  final ErrorType errorType;
  final VoidCallback onRetry;

  ErrorAlertState({
    this.isVisible = false,
    this.errorMessage = '',
    required this.errorType,
    required this.onRetry,
  });

  ErrorAlertState copyWith({
    bool? isVisible,
    String? errorMessage,
    ErrorType? errorType,
    VoidCallback? onRetry,
  }) {
    return ErrorAlertState(
      isVisible: isVisible ?? this.isVisible,
      errorMessage: errorMessage ?? this.errorMessage,
      errorType: errorType ?? this.errorType,
      onRetry: onRetry ?? this.onRetry,
    );
  }
}
