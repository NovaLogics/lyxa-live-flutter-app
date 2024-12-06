import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/resources/app_colors.dart';
import 'package:lyxa_live/src/core/styles/app_styles.dart';

class GradientButtonV1 extends StatefulWidget {
  final VoidCallback onTap;
  final String text;
  final Widget icon;
  final double borderRadius;
  final List<Color> gradientColors;
  final EdgeInsets padding;

  const GradientButtonV1({
    super.key,
    required this.onTap,
    required this.text,
    required this.icon,
    this.borderRadius = 24.0,
    this.gradientColors = const [Colors.blue, Colors.purple],
    this.padding = const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
  });

  @override
  State<GradientButtonV1> createState() => _GradientButtonV1State();
}

class _GradientButtonV1State extends State<GradientButtonV1>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.95,
      upperBound: 1.0,
    );
    _scaleAnimation = _animationController.drive(
      Tween<double>(begin: 1.0, end: 0.95),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown() {
    _animationController.reverse();
  }

  void _onTapUp() {
    _animationController.forward();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _onTapDown(),
      onTapUp: (_) => _onTapUp(),
      onTapCancel: () => _animationController.forward(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          padding: widget.padding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.text,
                style: AppStyles.buttonTextPrimary.copyWith(
                  color: AppColors.whiteLight,
                ),
              ),
              const SizedBox(width: 8),
              widget.icon,
            ],
          ),
        ),
      ),
    );
  }
}
