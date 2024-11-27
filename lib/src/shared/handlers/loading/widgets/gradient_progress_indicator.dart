import 'package:flutter/material.dart';

class GradientProgressIndicator extends StatelessWidget {
  final double strokeWidth;
  final List<Color> gradientColors;

  const GradientProgressIndicator({
    super.key,
    this.strokeWidth = 4.0,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return SweepGradient(
          startAngle: 0.0,
          endAngle: 3.14 * 2,
          colors: gradientColors,
          tileMode: TileMode.repeated,
        ).createShader(bounds);
      },
      child: SizedBox(
        width: 72.0, // Adjust size as needed
        height: 72.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircularProgressIndicator(
            strokeWidth: strokeWidth,
            valueColor: const AlwaysStoppedAnimation<Color>(
                Colors.white), // Required for ShaderMask
          ),
        ),
      ),
    );
  }
}
