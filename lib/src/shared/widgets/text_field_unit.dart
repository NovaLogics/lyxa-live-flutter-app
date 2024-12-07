import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/constants/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/validations/text_field_limits.dart';
import 'package:lyxa_live/src/core/styles/app_styles.dart';

class TextFieldUnit extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final int maxLength;
  final Widget? prefixIcon;
  final TextCapitalization? textCapitalization;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;

  const TextFieldUnit({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.prefixIcon,
    this.validator,
    this.maxLength = TextFieldLimits.defaultLimit,
    this.textCapitalization,
    this.textInputAction,
  });

  @override
  State<TextFieldUnit> createState() => _TextFieldUnitState();
}

class _TextFieldUnitState extends State<TextFieldUnit> {
  late bool isPasswordVisible;

  @override
  void initState() {
    super.initState();
    isPasswordVisible = !widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      maxLength: widget.maxLength,
      textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
      textInputAction: widget.textInputAction ?? TextInputAction.done,
      obscureText: widget.obscureText && !isPasswordVisible,
      style: AppStyles.textFieldStyleMain.copyWith(
        color: Theme.of(context).colorScheme.inversePrimary,
      ),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
          borderRadius: BorderRadius.circular(AppDimens.radiusMD12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).colorScheme.onPrimary),
          borderRadius: BorderRadius.circular(AppDimens.radiusMD12),
        ),
        hintText: widget.hintText,
        hintStyle: AppStyles.textFieldStyleHint.copyWith(
          color: Theme.of(context).colorScheme.onSecondary,
        ),
        fillColor: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withOpacity(0.7),
        filled: true,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                onPressed: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
              )
            : null,
      ),
      validator: widget.validator,
    );
  }
}
