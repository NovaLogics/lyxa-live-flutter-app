import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Widget icon;
  final double borderRadius;
  final double elevation;
  final Color borderColor;
  final Color backgroundColor;
  final TextStyle textStyle;
  final Color iconColor;
  final EdgeInsets padding;

  const CustomOutlinedButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.icon,
    this.borderRadius = 20.0,
    this.elevation = 4.0,
    this.borderColor = Colors.blue,
    this.backgroundColor = Colors.transparent,
    this.textStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    this.iconColor = Colors.black,
    this.padding = const EdgeInsets.symmetric(vertical: 14.0),
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: borderColor, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: elevation,
        backgroundColor: backgroundColor,
      ),
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: textStyle,
            ),
            const SizedBox(width: 8),
            icon,
          ],
        ),
      ),
    );
  }
}
