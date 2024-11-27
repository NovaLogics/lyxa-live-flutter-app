import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/styles/app_styles.dart';

class ButtonUnit extends StatelessWidget {
  final void Function()? onTap;
  final String text;

  const ButtonUnit({
    super.key,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimens.paddingLG24),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary,
            borderRadius: BorderRadius.circular(AppDimens.radiusMD12)),
        child: Center(
          child: Text(
            text,
            style: AppStyles.buttonTextPrimary,
          ),
        ),
      ),
    );
  }
}
