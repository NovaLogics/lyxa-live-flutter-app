import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/constants/constants.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/resources/app_strings.dart';

class CenterLoadingUnit extends StatelessWidget {
  final String message;

  const CenterLoadingUnit({
    super.key,
    this.message = AppStrings.pleaseWait,
  });

  @override
  Widget build(BuildContext context) {
    // BACKGROUND
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.5),
      body: Center(
        // DISPLAY CARD
        child: Card(
          color: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusMD12),
          ),
          elevation: AppDimens.elevationMD8,
          shadowColor: Theme.of(context).colorScheme.primary,
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.size56),
            child:
                // BODY
                Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // LOADING INDICATOR
                CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
                const SizedBox(height: AppDimens.size24),
                // DISPLAY TEXT
                Text(
                  message,
                  style: TextStyle(
                    fontSize: AppDimens.fontSizeXL20,
                    letterSpacing: AppDimens.letterSpacingPT11,
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
