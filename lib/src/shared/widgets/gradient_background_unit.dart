import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/values/app_colors.dart';

enum BackgroundStyle { home, auth }

class GradientBackgroundUnit extends StatelessWidget {
  final double width;
  final BackgroundStyle style;

  const GradientBackgroundUnit({
    super.key,
    this.width = 400,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: width,
        child: Stack(
          children: [
            ..._buildGradientCircles(context),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
              child: const SizedBox.expand(), // Simplified decoration
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildGradientCircles(BuildContext context) {
    final colors = _getStyleColors(context); // Get colors based on style

    return [
      _buildCircle(
        const AlignmentDirectional(3, -0.3),
        colors[0], // First color
      ),
      _buildCircle(
        const AlignmentDirectional(-3, -0.3),
        colors[1], // Second color
      ),
      _buildCircle(
        const AlignmentDirectional(0, -0.9),
        colors[2], // Third color
        height: 400,
        width: 260,
      ),
      _buildCircle(
        const AlignmentDirectional(-0.3, 1.5),
        colors[3], // Fourth color
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

  /// Returns the list of colors based on the selected style
  List<Color> _getStyleColors(BuildContext context) {
    switch (style) {
      case BackgroundStyle.home:
        return [
          Theme.of(context).colorScheme.surfaceContainerLow,
          Theme.of(context).colorScheme.surfaceContainerLowest,
          Theme.of(context).colorScheme.surfaceContainerHighest,
          Theme.of(context).colorScheme.surfaceContainerHigh,
        ];
      case BackgroundStyle.auth:
        return [
          AppColors.deepPurple700,
          AppColors.deepPurple500,
          AppColors.blueGrey900L1,
          AppColors.blueGrey900L2,
        ];
    }
  }
}
