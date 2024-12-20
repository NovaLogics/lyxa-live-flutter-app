import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/validations/text_field_limits.dart';
import 'package:lyxa_live/src/core/validations/validator.dart';
import 'package:lyxa_live/src/core/constants/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/constants/resources/app_strings.dart';
import 'package:lyxa_live/src/shared/widgets/text_field_unit.dart';

class EmailFieldUnit extends StatelessWidget {
  final TextEditingController emailTextController;

  const EmailFieldUnit({super.key, required this.emailTextController});

  @override
  Widget build(BuildContext context) {
    return TextFieldUnit(
      controller: emailTextController,
      hintText: AppStrings.hintEmail,
      textInputAction: TextInputAction.next,
      obscureText: false,
      prefixIcon: Icon(
        Icons.email_outlined,
        size: AppDimens.iconSizeSM22,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      validator: Validator.validateEmail,
      maxLength: TextFieldLimits.emailField,
    );
  }
}
