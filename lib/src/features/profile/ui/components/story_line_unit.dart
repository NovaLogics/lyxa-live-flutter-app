import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/styles/app_text_styles.dart';
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
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      width: double.infinity,
      child: Text(
        text.isNotEmpty
            ? text
            : AppStrings.emptyStoryLineMessage, // Placeholder text
        style: AppTextStyles.textStylePost.copyWith(
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        maxLines: 5, // Limit to 5 lines
        overflow: TextOverflow.ellipsis, // Show ellipsis if text overflows
      ),
    );
  }
}
