import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/styles/app_styles.dart'; 

const double _buttonVerticalPadding = 12.0;
const double _buttonHorizontalPadding = 90.0;
const double _buttonBorderRadius = 24.0;
const double _buttonSpreadRadius = 2.0;
const double _buttonBlurRadius = 10.0;
const Offset _buttonShadowOffset = Offset(0, 5);
const Duration _animationDuration = Duration(milliseconds: 100);

class GradientButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final TextStyle? textStyle; 
  final Widget? icon;

  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.textStyle,
    this.icon,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: _animationDuration,
      lowerBound: 0.95,
      upperBound: 1.0,
    );
    _scaleController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  // Shrinks the button on tap
  void _onButtonTapDown(TapDownDetails details) {
    _scaleController.reverse();
  }

  // Returns to normal size when the tap is released
  void _onButtonTapUp(TapUpDetails details) {
    _scaleController.forward();
    widget.onPressed();
  }

  // Returns to normal size if the tap is canceled
  void _onButtonTapCancel() {
    _scaleController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onButtonTapDown,
      onTapUp: _onButtonTapUp,
      onTapCancel: _onButtonTapCancel,
      child: ScaleTransition(
        scale: _scaleController,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: _buttonVerticalPadding,
            horizontal: _buttonHorizontalPadding,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.blueAccent, Colors.purpleAccent],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(_buttonBorderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.purpleAccent.withOpacity(0.3),
                spreadRadius: _buttonSpreadRadius,
                blurRadius: _buttonBlurRadius,
                offset: _buttonShadowOffset,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Customizable Text
              Text(
                widget.text,
                style: widget.textStyle ??
                    AppStyles.buttonTextPrimary,
              ),
              const SizedBox(width: 10.0),
              // Customizable Icon
              widget.icon ??
                  const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
