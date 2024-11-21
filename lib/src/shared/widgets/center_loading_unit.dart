import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/constants/constants.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/resources/app_strings.dart';

class CenterLoadingUnit extends StatelessWidget {
  final String message;

  const CenterLoadingUnit({super.key, this.message = AppStrings.pleaseWait});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.5),
      body: Center(
        child: Card(
          color: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimens.radiusMD12)),
          elevation: AppDimens.elevationMD8,
          shadowColor: Theme.of(context).colorScheme.primary,
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.size56),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.onSecondary,
                ), // Loading indicator
                const SizedBox(height: AppDimens.size24),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 20,
                    letterSpacing: 1.1,
                    fontFamily: FONT_RALEWAY,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
