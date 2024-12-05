import 'package:flutter/material.dart';

class NavCustomPainter extends CustomPainter {
  final BuildContext context;

  NavCustomPainter(this.context);
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Theme.of(context).colorScheme.onError.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 2); // Start
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20),
        radius: const Radius.circular(30.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 2);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);
    path.close();
    canvas.drawShadow(path, Theme.of(context).colorScheme.onPrimary, 16, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
