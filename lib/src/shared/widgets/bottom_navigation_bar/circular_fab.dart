import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/constants/resources/app_colors.dart';

class CircularFAB extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;

  const CircularFAB({
    super.key,
    required this.onPressed,
    required this.child,
  });

  @override
  State<CircularFAB> createState() => _CircularFABState();
}

class _CircularFABState extends State<CircularFAB>
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
            width: 64,
            height: 64,
            child: CustomPaint(
              painter: _CirclePainter(),
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

class _CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..shader = const LinearGradient(
        colors: [AppColors.bluePurple900, AppColors.deepPurple400],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    // Draw a circle
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2), // Center of the circle
      size.width / 2, // Radius of the circle
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
