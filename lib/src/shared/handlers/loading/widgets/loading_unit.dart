import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/constants/constants.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/resources/app_strings.dart';
import 'package:lyxa_live/src/shared/handlers/loading/cubits/loading_cubit.dart';
import 'package:lyxa_live/src/shared/handlers/loading/cubits/loading_state.dart';

class LoadingUnit extends StatelessWidget {
  final String message;

  const LoadingUnit({
    super.key,
    this.message = AppStrings.pleaseWait,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoadingCubit, LoadingState>(
      builder: (context, state) {
        return state.isVisible
            ? _buildLoadingScaffold(context, state.message)
            : const SizedBox.shrink();
      },
    );
  }

  Widget _buildLoadingScaffold(BuildContext context, String message) {
    return Scaffold(
      backgroundColor: _getBackgroundColor(context),
      body: Center(
        child: _buildLoadingCard(context, message),
      ),
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    return Theme.of(context).colorScheme.surface.withOpacity(0.7);
  }

  Widget _buildLoadingCard(BuildContext context, String message) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusMD12),
      ),
      elevation: AppDimens.elevationMD8,
      shadowColor: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.size44,
          vertical: AppDimens.size56,
        ),
        child: _buildLoadingContent(context, message),
      ),
    );
  }

  // Builds the content of the loading card
  Widget _buildLoadingContent(BuildContext context, String message) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildLoadingIndicator(context),
        const SizedBox(height: AppDimens.size36),
        _buildLoadingMessage(context, message),
      ],
    );
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    return CircularProgressIndicator(
      color: Theme.of(context).colorScheme.onSecondary,
    );
  }

  Widget _buildLoadingMessage(BuildContext context, String message) {
    return SizedBox(
      width: AppDimens.size220,
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: _getMessageTextStyle(context),
        maxLines: 6,
        overflow: TextOverflow.visible,
        softWrap: true,
      ),
    );
  }

  TextStyle _getMessageTextStyle(BuildContext context) {
    return TextStyle(
      fontSize: AppDimens.fontSizeXL20,
      letterSpacing: AppDimens.letterSpacingPT07,
      fontWeight: FontWeight.w600,
      fontFamily: FONT_RALEWAY,
      color: Theme.of(context).colorScheme.onTertiary,
    );
  }
}
