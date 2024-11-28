import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/resources/text_field_limits.dart';
import 'package:lyxa_live/src/shared/widgets/text_field_unit.dart';

class PasswordFieldUnit extends StatelessWidget {
  final TextEditingController passwordTextController;
  final String hintText;
  final TextInputAction? textInputAction;
  final String? Function(String?)? passwordValidator;

  const PasswordFieldUnit({
    super.key,
    required this.passwordTextController,
    required this.hintText,
    this.passwordValidator,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return TextFieldUnit(
      controller: passwordTextController,
      hintText: hintText,
      textInputAction: textInputAction,
      obscureText: true,
      prefixIcon: Icon(
        Icons.lock_outlined,
        size: AppDimens.iconSizeSM22,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      validator: passwordValidator,
      maxLength: TextFieldLimits.passwordField,
    );
  }
}
