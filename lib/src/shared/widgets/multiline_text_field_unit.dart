import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/constants/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/validations/text_field_limits.dart';
import 'package:lyxa_live/src/core/constants/styles/app_styles.dart';

class MultilineTextFieldUnit extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  // final String labelText;
  final int maxLength;
  final FocusNode? focusNode;
  final bool? autofocus;

  const MultilineTextFieldUnit({
    super.key,
    required this.controller,
    required this.hintText,
    // required this.labelText,
    this.maxLength = TextFieldLimits.defaultLimit,
    this.focusNode,
    this.autofocus,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 5,
      focusNode: focusNode ?? FocusNode(),
      textCapitalization: TextCapitalization.sentences,
      maxLength: maxLength,
      style: AppStyles.textFieldStyleMain.copyWith(
        color: Theme.of(context).colorScheme.inversePrimary,
      ),
      autofocus: autofocus ?? false,
      decoration: InputDecoration(
        // labelText: labelText,
        hintText: hintText,
        hintStyle: AppStyles.textFieldStyleHint.copyWith(
          color: Theme.of(context).colorScheme.onSecondary,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusLG16),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.inversePrimary,
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusLG16),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.onSecondary,
            width: 1.0,
          ),
        ),
      ),
    );
  }
}
