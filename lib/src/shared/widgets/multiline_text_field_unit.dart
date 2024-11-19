import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/utils/constants/constants.dart';
import 'package:lyxa_live/src/core/values/app_dimensions.dart';

class MultilineTextFieldUnit extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLength;

  const MultilineTextFieldUnit({
    super.key,
    required this.controller,
    required this.hintText,
    this.maxLength = 100,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 5,
      maxLength: maxLength,
      style: TextStyle(
          color: Theme.of(context).colorScheme.inversePrimary,
          fontFamily: FONT_RALEWAY,
          fontWeight: FontWeight.w500,
          fontSize: AppDimens.textSizeMedium),
      decoration: InputDecoration(
        labelText: hintText,
        hintText: hintText,
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSecondary,
          fontWeight: FontWeight.normal,
          fontSize: AppDimens.textSizeRegular,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16), // Rounded corners
        ),
        counterText: '',
      ),
    );
  }
}
