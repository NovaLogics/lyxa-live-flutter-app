import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/constants/resources/app_colors.dart';
import 'package:lyxa_live/src/core/constants/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/constants/resources/app_strings.dart';
import 'package:lyxa_live/src/core/constants/styles/app_styles.dart';
import 'package:lyxa_live/src/shared/handlers/loading/cubits/loading_cubit.dart';
import 'package:lyxa_live/src/shared/handlers/loading/cubits/loading_state.dart';
import 'package:lyxa_live/src/shared/handlers/loading/widgets/gradient_progress_indicator.dart';

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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusLG16),
      ),
      elevation: AppDimens.elevationMD8,
      shadowColor: Theme.of(context).colorScheme.primary,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              AppColors.bluePurple500,
              AppColors.deepPurple500,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppDimens.radiusLG16),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(AppDimens.radiusLG16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.size40,
              vertical: AppDimens.size48,
            ),
            child: _buildLoadingContent(context, message),
          ),
        ),
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
    return const GradientProgressIndicator(
      strokeWidth: 5.0,
      gradientColors: [
        AppColors.deepPurple400,
        AppColors.deepPurple700,
        AppColors.deepPurple500,
        AppColors.deepPurple400,
      ],
    );
  }

  Widget _buildLoadingMessage(BuildContext context, String message) {
    return SizedBox(
      width: AppDimens.size200,
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
    return AppStyles.titlePrimary.copyWith(
      color: Theme.of(context).colorScheme.onTertiary,
      letterSpacing: AppDimens.letterSpacingPT07,
    );
  }
}
