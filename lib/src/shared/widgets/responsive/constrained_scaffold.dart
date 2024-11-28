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
        GradientBackgroundUnit(
          width: AppDimens.containerSize430,
          style: backgroundStyle ?? BackgroundStyle.main,
        ),
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
