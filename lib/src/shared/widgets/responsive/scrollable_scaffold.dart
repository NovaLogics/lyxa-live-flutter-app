import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/di/service_locator.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';
import 'package:lyxa_live/src/shared/widgets/gradient_background_unit.dart';

class ScrollableScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final Widget body;
  final Color? backgroundColor;
  final BackgroundStyle backgroundStyle;

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
    return Stack(
      children: [
        _buildGradientBackground(),
        _buildContent(),
      ],
    );
  }

  Widget _buildGradientBackground() {
    return getIt<GradientBackgroundUnit>(
      param1: AppDimens.containerSize430,
      param2: backgroundStyle,
    );
  }

  Widget _buildContent() {
    return _Content(
      appBar: appBar,
      drawer: drawer,
      body: body,
    );
  }
}

class _Content extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final Widget body;

  const _Content({
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
      body: _buildScrollableBody(context),
    );
  }

  Widget _buildScrollableBody(BuildContext context) {
    return LayoutBuilder(
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
    );
  }
}
