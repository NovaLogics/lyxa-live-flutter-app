import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/di/service_locator.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';
import 'package:lyxa_live/src/shared/widgets/gradient_background_unit.dart';

class ScrollableScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final Widget body;
  final Color? backgroundColor;
  final BackgroundStyle? backgroundStyle;

  const ScrollableScaffold({
    super.key,
    this.appBar,
    this.drawer,
    this.backgroundColor,
    this.backgroundStyle = BackgroundStyle.main,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Static Background
          _Background(
            backgroundColor: backgroundColor,
            backgroundStyle: backgroundStyle,
          ),
          // Foreground with appBar, drawer, and scrollable body
          _Foreground(
            appBar: appBar,
            drawer: drawer,
            body: body,
          ),
        ],
      ),
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

class _Foreground extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final Widget body;

  const _Foreground({
    this.appBar,
    this.drawer,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: appBar,
      drawer: drawer,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: AppDimens.containerSize430,
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: body,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
