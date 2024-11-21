import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/values/app_dimensions.dart';

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
        padding: const EdgeInsets.all(AppDimens.paddingLg24),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary,
            borderRadius: BorderRadius.circular(AppDimens.radiusMedium)),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppDimens.textSizeLg18,
            ),
          ),
        ),
      ),
    );
  }
}
