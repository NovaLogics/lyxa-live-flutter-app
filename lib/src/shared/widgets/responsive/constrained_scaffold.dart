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

class ConstrainedScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final Color? backgroundColor;
  final BackgroundStyle backgroundStyle;

  final bool showPhotoSlider;
  final bool showLoading;
  final bool showError;

  const ConstrainedScaffold({
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
        _buildScaffold(),
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

  Widget _buildScaffold() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: appBar,
      drawer: drawer,
      body: _ConstrainedBody(body: body),
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
