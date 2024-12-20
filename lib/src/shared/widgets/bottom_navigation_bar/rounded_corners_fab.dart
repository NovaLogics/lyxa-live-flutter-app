import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/constants/resources/app_colors.dart';

class RoundedCornerFAB extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;

  const RoundedCornerFAB({
    super.key,
    required this.onPressed,
    required this.child,
  });

  @override
  State<RoundedCornerFAB> createState() => _RoundedCornerFABState();
}

class _RoundedCornerFABState extends State<RoundedCornerFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
      lowerBound: 0.95,
      upperBound: 1.0,
    );
    _scaleAnimation = _controller;
  }

  void _onTapDown(TapDownDetails details) {
    _controller.reverse();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.forward();
    widget.onPressed();
  }

  void _onTapCancel() {
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: SizedBox(
            width: 54,
            height: 54,
            child: CustomPaint(
              painter: _RoundedCornerPainter(context),
              child: GestureDetector(
                onTapDown: _onTapDown,
                onTapUp: _onTapUp,
                onTapCancel: _onTapCancel,
                child: Center(child: widget.child),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RoundedCornerPainter extends CustomPainter {
  final BuildContext context;

  _RoundedCornerPainter(this.context);
  @override
  void paint(Canvas canvas, Size size) {
    // Border paint
    Paint borderPaint = Paint()
      ..color = AppColors.bluePurple900L2
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0; // Border thickness

    // Fill paint with gradient
    Paint fillPaint = Paint()
      ..shader = const LinearGradient(
        colors: [AppColors.bluePurple900, AppColors.deepPurple400],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    // Create a rounded rectangle (RRect)
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height), // FAB size
      const Radius.circular(20), // Corner radius
    );

    // Draw the border
    canvas.drawRRect(rrect, borderPaint);

    // Draw the filled rounded rectangle
    canvas.drawRRect(rrect, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
