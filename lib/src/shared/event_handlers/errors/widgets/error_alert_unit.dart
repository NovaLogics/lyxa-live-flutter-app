import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/di/service_locator.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';
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
                backgroundColor:
                    Theme.of(context).colorScheme.surface.withOpacity(0.7),
                body: Center(
                  child: Card(
                    elevation: AppDimens.elevationMD8,
                    shadowColor: Theme.of(context).colorScheme.primary,
                    color: Theme.of(context).colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.radiusMD12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(AppDimens.size56,
                          AppDimens.size24, AppDimens.size56, AppDimens.size24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getErrorIcon(state.errorType),
                            size: 72.0,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            state.errorMessage,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: AppDimens.fontSizeLG18,
                              letterSpacing: AppDimens.letterSpacingPT11,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onTertiary,
                            ),
                          ),
                          const SizedBox(height: 24.0),
                          ElevatedButton(
                            onPressed: state.onRetry,
                            child: Text('Retry',
                                style: TextStyle(
                                  fontSize: AppDimens.fontSizeXL20,
                                  letterSpacing: AppDimens.letterSpacingPT11,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                )),
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
