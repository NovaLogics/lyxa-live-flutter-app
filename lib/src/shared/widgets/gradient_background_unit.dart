import 'dart:ui';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/constants/resources/app_colors.dart';
import 'package:lyxa_live/src/core/constants/resources/app_dimensions.dart';

enum BackgroundStyle { main, auth }

class GradientBackgroundUnit extends StatelessWidget {
  final double width;
  final BackgroundStyle style;

  const GradientBackgroundUnit({
    super.key,
    this.width = AppDimens.containerSize430,
    required this.style,
  });

  bool get _isWebPlatform => kIsWeb;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: _isWebPlatform && style == BackgroundStyle.main
          ? _buildWebBackground(context)
          : _buildCenteredBackground(context),
    );
  }

  Widget _buildWebBackground(BuildContext context) {
    return Opacity(
      opacity: 0.8,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _buildGradientColors(context),
          ),
        ),
      ),
    );
  }

  Widget _buildCenteredBackground(BuildContext context) {
    return Center(
      child: SizedBox(
        width: width,
        child: Stack(
          children: [
            ..._buildGradientCircles(context),
            _buildBlurEffect(),
          ],
        ),
      ),
    );
  }

  List<Color> _buildGradientColors(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return [
      colorScheme.surface,
      colorScheme.surfaceContainerHighest,
      colorScheme.surfaceTint,
      colorScheme.surfaceTint,
      colorScheme.surfaceContainerHighest,
      colorScheme.surface,
    ];
  }

  List<Widget> _buildGradientCircles(BuildContext context) {
    final colors = _getStyleColors(context);

    return [
      _buildCircle(const AlignmentDirectional(3, -0.3), colors[0]),
      _buildCircle(const AlignmentDirectional(-3, -0.3), colors[1]),
      _buildCircle(const AlignmentDirectional(0, -0.9), colors[2],
          height: 400, width: 260),
      _buildCircle(const AlignmentDirectional(-0.3, 1.5), colors[3],
          height: 250, width: 300),
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

  Widget _buildBlurEffect() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
      child: const SizedBox(),
    );
  }

  List<Color> _getStyleColors(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    switch (style) {
      case BackgroundStyle.main:
        return [
          theme.surfaceContainerLow,
          theme.surfaceContainerLowest,
          theme.surfaceContainerHighest,
          theme.surfaceContainerHigh,
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
