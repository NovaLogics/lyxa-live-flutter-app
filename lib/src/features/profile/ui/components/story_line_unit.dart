import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/styles/app_styles.dart';
import 'package:lyxa_live/src/core/resources/app_strings.dart';

class StoryLineUnit extends StatelessWidget {
  final String text;

  const StoryLineUnit({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimens.paddingRG12,
        horizontal: AppDimens.paddingMD16,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusMD12),
      ),
      width: double.infinity,
      child: Text(
        text.isNotEmpty ? text : AppStrings.emptyStoryLineMessage,
        style: AppStyles.textTitlePost.copyWith(
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        maxLines: 5,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
