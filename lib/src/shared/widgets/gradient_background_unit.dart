import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/values/app_colors.dart';

class GradientBackgroundUnit extends StatelessWidget {
  final double width;

  const GradientBackgroundUnit({super.key, this.width = 400});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: width,
        child: Stack(
          children: [
            ..._buildGradientCircles(),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
              child: const SizedBox.expand(), // Simplified decoration
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildGradientCircles() {
    return [
      _buildCircle(
        const AlignmentDirectional(3, -0.3),
        AppColors.deepPurpleShade700,
      ),
      _buildCircle(
        const AlignmentDirectional(-3, -0.3),
        AppColors.deepPurpleShade500,
      ),
      _buildCircle(
        const AlignmentDirectional(0, -0.9),
        AppColors.blueGreyShade900X,
        height: 400,
        width: 260,
      ),
      _buildCircle(
        const AlignmentDirectional(-0.3, 1.5),
        AppColors.blueGreyShade900Y,
        height: 250,
        width: 300,
      ),
    ];
  }

  Widget _buildCircle(
    AlignmentDirectional alignment,
    Color color, {
    double height = 300,
    double width = 300,
  }) {
    return Align(
      alignment: alignment,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}
