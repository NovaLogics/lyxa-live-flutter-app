import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/di/service_locator.dart';
import 'package:lyxa_live/src/shared/event_handlers/errors/cubits/error_cubit.dart';
import 'package:lyxa_live/src/shared/event_handlers/errors/cubits/error_state.dart';
import 'package:lyxa_live/src/shared/event_handlers/errors/utils/error_type.dart';

class ErrorAlertUnit extends StatelessWidget {
  const ErrorAlertUnit({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ErrorAlertCubit, ErrorAlertState>(
      builder: (context, state) {
        return state.isVisible
            ? Scaffold(
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
                            _getErrorIcon(state.errorType),
                            size: 72.0,
                            color: Colors.redAccent,
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            state.errorMessage,
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
                                onPressed: state.onRetry,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink();
      },
    );
  }

  IconData _getErrorIcon(ErrorType errorType) {
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

  // Static methods to show/hide error globally
  static void showError({
    required ErrorType errorType,
    String? customMessage,
    required VoidCallback onRetry,
  }) {
    getIt<ErrorAlertCubit>().showError(
      errorType: errorType,
      customMessage: customMessage,
      onRetry: onRetry,
    );
  }

  static void hideError() {
    getIt<ErrorAlertCubit>().hideError();
  }
}
