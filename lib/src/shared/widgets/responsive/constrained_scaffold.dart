import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/di/service_locator.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';
import 'package:lyxa_live/src/shared/widgets/gradient_background_unit.dart';

class ConstrainedScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final Color? backgroundColor;
  final BackgroundStyle? backgroundStyle;

  const ConstrainedScaffold({
    super.key,
    this.appBar,
    this.drawer,
    this.backgroundColor,
    this.backgroundStyle = BackgroundStyle.main,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background layer
        _Background(
          backgroundColor: backgroundColor,
          backgroundStyle: backgroundStyle,
        ),

        // Foreground layer with appBar, drawer, and body
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: appBar,
          drawer: drawer,
          body: _ConstrainedBody(
            body: body,
          ),
        ),
      ],
    );
  }
}

class _Background extends StatelessWidget {
  final Color? backgroundColor;
  final BackgroundStyle? backgroundStyle;

  const _Background({
    this.backgroundColor,
    this.backgroundStyle,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor ?? Colors.transparent,
      child: RepaintBoundary(
        child: getIt<GradientBackgroundUnit>(
          param1: AppDimens.containerSize400,
          param2: backgroundStyle ?? BackgroundStyle.main,
        ),
      ),
    );
  }
}

class _ConstrainedBody extends StatelessWidget {
  final Widget body;

  const _ConstrainedBody({required this.body});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: AppDimens.containerSize430,
        child: body,
      ),
    );
  }
}
