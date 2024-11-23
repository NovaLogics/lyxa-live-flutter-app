import 'package:flutter/material.dart';
import 'package:lyxa_live/src/shared/event_handlers/errors/utils/error_messages.dart';
import 'package:lyxa_live/src/shared/event_handlers/errors/utils/error_type.dart';

class ErrorAlertUnit extends StatelessWidget {
  final String? customErrorMessage;
  final ErrorType errorType;
  final VoidCallback onRetry;

  const ErrorAlertUnit({
    super.key,
    this.customErrorMessage,
    required this.errorType,
    required this.onRetry,
  });

  String _getErrorMessage() {
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

  IconData _getErrorIcon() {
    switch (errorType) {
      case ErrorType.networkError:
        return Icons.wifi_off;
      case ErrorType.timeoutError:
        return Icons.timer_off;
      case ErrorType.authenticationError:
        return Icons.lock_outline;
      case ErrorType.permissionDenied:
        return Icons.block;
      case ErrorType.unknown:
      default:
        return Icons.error_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    String errorText =
        (customErrorMessage != null) ? customErrorMessage! : _getErrorMessage();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.6),
      body: Center(
        child: Card(
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getErrorIcon(),
                  size: 72.0,
                  color: Colors.redAccent,
                ),
                const SizedBox(height: 16.0),
                Text(
                  errorText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: onRetry,
                      child: const Text(ErrorMessages.retryButtonLabel),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
