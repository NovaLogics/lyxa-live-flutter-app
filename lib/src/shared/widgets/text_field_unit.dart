import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/utils/constants/constants.dart';
import 'package:lyxa_live/src/core/values/app_dimensions.dart';

class TextFieldUnit extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final int maxLength;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;

  const TextFieldUnit({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.prefixIcon,
    this.validator,
    this.maxLength = 45,
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
      obscureText: widget.obscureText && !isPasswordVisible,
      style: TextStyle(
          color: Theme.of(context).colorScheme.inversePrimary,
          fontFamily: FONT_RALEWAY,
          fontWeight: FontWeight.w500,
          fontSize: AppDimens.textSizeMedium),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.circular(12),
        ),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.normal,
          fontSize: AppDimens.textSizeRegular,
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
                  color: Theme.of(context).colorScheme.primary,
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
