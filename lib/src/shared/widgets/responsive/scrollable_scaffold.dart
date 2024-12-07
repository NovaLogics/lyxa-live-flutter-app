import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/dependency_injection/service_locator.dart';
import 'package:lyxa_live/src/core/constants/resources/app_dimensions.dart';
import 'package:lyxa_live/src/features/photo_slider/cubits/slider_cubit.dart';
import 'package:lyxa_live/src/features/photo_slider/cubits/slider_state.dart';
import 'package:lyxa_live/src/features/photo_slider/screens/photo_slider.dart';
import 'package:lyxa_live/src/shared/handlers/errors/cubits/error_cubit.dart';
import 'package:lyxa_live/src/shared/handlers/errors/cubits/error_state.dart';
import 'package:lyxa_live/src/shared/handlers/errors/widgets/error_alert_unit.dart';
import 'package:lyxa_live/src/shared/handlers/loading/cubits/loading_cubit.dart';
import 'package:lyxa_live/src/shared/handlers/loading/cubits/loading_state.dart';
import 'package:lyxa_live/src/shared/handlers/loading/widgets/loading_unit.dart';
import 'package:lyxa_live/src/shared/widgets/gradient_background_unit.dart';

class ScrollableScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final Widget body;
  final Color? backgroundColor;
  final BackgroundStyle backgroundStyle;

  final bool showPhotoSlider;
  final bool showLoading;
  final bool showError;

  const ScrollableScaffold({
    super.key,
    this.appBar,
    this.drawer,
    this.backgroundColor,
    this.backgroundStyle = BackgroundStyle.main,
    required this.body,
    this.showPhotoSlider = false,
    this.showLoading = true,
    this.showError = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildGradientBackground(),
        _buildContent(),
        if (showPhotoSlider) _buildPhotoSliderScreen(),
        if (showLoading) _buildLoadingScreen(),
        if (showError) _buildErrorDisplayScreen(),
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

    Widget _buildErrorDisplayScreen() {
    return BlocConsumer<ErrorAlertCubit, ErrorAlertState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Visibility(
          visible: state.isVisible,
          child: const ErrorAlertUnit(),
        );
      },
    );
  }

  Widget _buildLoadingScreen() {
    return BlocConsumer<LoadingCubit, LoadingState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Visibility(
          visible: state.isVisible,
          child: LoadingUnit(
            message: state.message,
          ),
        );
      },
    );
  }

  Widget _buildPhotoSliderScreen() {
    return BlocConsumer<SliderCubit, SliderState>(
      listener: (context, state) {},
      builder: (context, state) {
        return (state is SliderLoaded)
            ? PhotoSlider(
                images: state.images,
                initialIndex: state.currentIndex,
              )
            : const SizedBox.shrink();
      },
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
