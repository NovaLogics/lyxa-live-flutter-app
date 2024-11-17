import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/utils/constants/constants.dart';
import 'package:lyxa_live/src/core/values/app_dimensions.dart';
import 'package:lyxa_live/src/shared/widgets/text_field_unit.dart';

class PasswordFieldUnit extends StatelessWidget {
  final TextEditingController passwordTextController;
  final String hintText;
  final String? Function(String?)? passwordValidator;
  
  const PasswordFieldUnit({
    super.key,
    required this.passwordTextController,
    required this.hintText,
    this.passwordValidator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFieldUnit(
      controller: passwordTextController,
      hintText: hintText,
      obscureText: true,
      prefixIcon: Icon(
        Icons.lock_outlined,
        size: AppDimens.prefixIconSizeMedium,
        color: Theme.of(context).colorScheme.primary,
      ),
      validator: passwordValidator,
      maxLength: MAX_LENGTH_PASSWORD_FIELD,
    );
  }
}
