import 'package:flutter/material.dart';

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
      maxLength: maxLength, // Sets max length
      decoration: InputDecoration(
        labelText: hintText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16), // Rounded corners
        ),
        counterText: '', 
      ),
    );
  }
}
