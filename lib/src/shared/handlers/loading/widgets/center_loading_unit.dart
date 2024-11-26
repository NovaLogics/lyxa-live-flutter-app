import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/constants/constants.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/resources/app_strings.dart';
import 'package:lyxa_live/src/shared/handlers/loading/cubits/loading_cubit.dart';
import 'package:lyxa_live/src/shared/handlers/loading/cubits/loading_state.dart';

class CenterLoadingUnit extends StatefulWidget {
  final String message;

  const CenterLoadingUnit({
    super.key,
    this.message = AppStrings.pleaseWait,
  });

  @override
  State<CenterLoadingUnit> createState() => _CenterLoadingUnitState();
}

class _CenterLoadingUnitState extends State<CenterLoadingUnit> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoadingCubit, LoadingState>(
      builder: (context, state) {
        return state.isVisible
            ? Scaffold(
                backgroundColor:
                    Theme.of(context).colorScheme.surface.withOpacity(0.7),
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
                          SizedBox(
                            width: AppDimens.size220,
                            child: Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: AppDimens.fontSizeXL20,
                                letterSpacing: AppDimens.letterSpacingPT11,
                                fontWeight: FontWeight.bold,
                                fontFamily: FONT_RALEWAY,
                                color: Theme.of(context).colorScheme.onTertiary,
                              ),
                              maxLines: null, // Allows unlimited lines
                              overflow: TextOverflow
                                  .visible, // Ensures the text remains visible
                              softWrap: true, // Wraps the text within the width
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox
                .shrink(); // Return an empty widget when not visible
      },
    );
  }
}
