import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/resources/app_strings.dart';
import 'package:lyxa_live/src/shared/event_handlers/loading/cubits/loading_cubit.dart';

class CenterLoadingUnit extends StatelessWidget {
  final String message;

  const CenterLoadingUnit({
    super.key,
    this.message = AppStrings.pleaseWait,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoadingCubit, bool>(
      builder: (context, isVisible) {
        return isVisible
            ? Scaffold(
                backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.6),
                body: Center(
                  child: Card(
                    color: Theme.of(context).colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.radiusMD12), 
                    ),
                    elevation: AppDimens.elevationMD8, 
                    shadowColor: Theme.of(context).colorScheme.primary,
                    child: Padding(
                      padding: const EdgeInsets.all(AppDimens.size56), 
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                          const SizedBox(height: AppDimens.size24),
                          Text(
                            message,
                            style: TextStyle(
                              fontSize: AppDimens.fontSizeXL20, 
                              letterSpacing: AppDimens.letterSpacingPT11, 
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(); // Return an empty widget when not visible
      },
    );
  }
}
