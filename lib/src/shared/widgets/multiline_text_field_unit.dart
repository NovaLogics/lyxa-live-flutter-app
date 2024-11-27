import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/resources/text_field_limits.dart';
import 'package:lyxa_live/src/core/styles/app_styles.dart';

class MultilineTextFieldUnit extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  // final String labelText;
  final int maxLength;

  const MultilineTextFieldUnit({
    super.key,
    required this.controller,
    required this.hintText,
    // required this.labelText,
    this.maxLength = TextFieldLimits.defaultLimit,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 5,
      textCapitalization: TextCapitalization.sentences,
      maxLength: maxLength,
      style: AppStyles.textFieldStyleMain.copyWith(
        color: Theme.of(context).colorScheme.inversePrimary,
      ),
      decoration: InputDecoration(
        // labelText: labelText,
        hintText: hintText,
        hintStyle: AppStyles.textFieldStyleHint.copyWith(
          color: Theme.of(context).colorScheme.onSecondary,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusLG16),
        ),
      ),
    );
  }
}
