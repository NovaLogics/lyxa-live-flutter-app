import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/resources/app_colors.dart';

enum BackgroundStyle { main, auth }

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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: SizedBox(
          width: width,
          child: Stack(
            children: [
              ..._buildGradientCircles(context),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
                child: const SizedBox.expand(), 
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildGradientCircles(BuildContext context) {
    final colors = _getStyleColors(context); 

    return [
      _buildCircle(
        const AlignmentDirectional(3, -0.3),
        colors[0], 
      ),
      _buildCircle(
        const AlignmentDirectional(-3, -0.3),
        colors[1], 
      ),
      _buildCircle(
        const AlignmentDirectional(0, -0.9),
        colors[2], 
        height: 400,
        width: 260,
      ),
      _buildCircle(
        const AlignmentDirectional(-0.3, 1.5),
        colors[3], 
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
      case BackgroundStyle.main:
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
