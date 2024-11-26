import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/constants/constants.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/resources/app_strings.dart';
import 'package:lyxa_live/src/shared/handlers/loading/cubits/loading_cubit.dart';
import 'package:lyxa_live/src/shared/handlers/loading/cubits/loading_state.dart';

class LoadingUnit extends StatefulWidget {
  final String message;

  const LoadingUnit({
    super.key,
    this.message = AppStrings.pleaseWait,
  });

  @override
  State<LoadingUnit> createState() => _LoadingUnitState();
}

class _LoadingUnitState extends State<LoadingUnit> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoadingCubit, LoadingState>(
      builder: (context, state) {
        // Schedule the visibility change after the build phase
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (state.isVisible && !_isVisible) {
            setState(() {
              _isVisible = true;
            });
          } else if (!state.isVisible && _isVisible) {
            Future.delayed(const Duration(seconds: 2), () {
              if (!state.isVisible) {
                setState(() {
                  _isVisible = false;
                });
              }
            });
          }
        });

        return _isVisible
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
                      padding: const EdgeInsets.all(AppDimens.size44),
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
                                fontWeight: FontWeight.w600,
                                fontFamily: FONT_RALEWAY,
                                color: Theme.of(context).colorScheme.onTertiary,
                              ),
                              maxLines: null,
                              overflow: TextOverflow.visible,
                              softWrap: true,
                            ),
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
}
