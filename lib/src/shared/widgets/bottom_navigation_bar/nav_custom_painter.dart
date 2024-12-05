import 'package:flutter/material.dart';

class NavCustomPainter extends CustomPainter {
  final BuildContext context;
  final double elevation;

  NavCustomPainter(this.context, this.elevation);
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Theme.of(context).colorScheme.onError
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 0); // Start
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 6),
        radius: const Radius.circular(10.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);
    path.close();
    canvas.drawShadow(
        path, Theme.of(context).colorScheme.onTertiary, elevation, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
