import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/resources/app_colors.dart';

class DiamondFAB extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;

  const DiamondFAB({
    super.key,
    required this.onPressed,
    required this.child,
  });

  @override
  State<DiamondFAB> createState() => _DiamondFABState();
}

class _DiamondFABState extends State<DiamondFAB>
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
              painter: _DiamondPainter(),
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

class _DiamondPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..shader = const LinearGradient(
        colors: [AppColors.bluePurple900, AppColors.deepPurple400],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    Path path = Path();

    // Top edge with rounded corner
    path.moveTo(size.width / 2, 0); // Top point
    path.lineTo(size.width - 5, size.height / 2 - 5); // Straight line
    path.quadraticBezierTo(size.width, size.height / 2, size.width - 5,
        size.height / 2 + 5); // Rounded top-right corner

    // Right edge
    path.lineTo(size.width / 2 + 5, size.height - 5); // Straight line
    path.quadraticBezierTo(size.width / 2, size.height, size.width / 2 - 5,
        size.height - 5); // Rounded bottom-right corner

    // Bottom edge
    path.lineTo(5, size.height / 2 + 5); // Straight line
    path.quadraticBezierTo(0, size.height / 2, 5,
        size.height / 2 - 5); // Rounded bottom-left corner

    // Left edge
    path.lineTo(size.width / 2 - 5, 5); // Straight line
    path.quadraticBezierTo(
        size.width / 2, 0, size.width / 2 + 5, 5); // Rounded top-left corner

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
