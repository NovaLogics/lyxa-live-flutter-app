import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/di/service_locator.dart';
import 'package:lyxa_live/src/core/utils/logger.dart';
import 'package:lyxa_live/src/features/auth/cubits/auth_cubit.dart';
import 'package:lyxa_live/src/features/auth/cubits/auth_state.dart';
import 'package:lyxa_live/src/features/auth/ui/screens/auth_screen.dart';
import 'package:lyxa_live/src/features/home/ui/screens/home_screen.dart';
import 'package:lyxa_live/src/features/post/cubits/post_cubit.dart';
import 'package:lyxa_live/src/features/profile/cubits/profile_cubit.dart';
import 'package:lyxa_live/src/features/search/cubits/search_cubit.dart';
import 'package:lyxa_live/src/features/photo_slider/cubits/slider_cubit.dart';
import 'package:lyxa_live/src/features/photo_slider/cubits/slider_state.dart';
import 'package:lyxa_live/src/features/photo_slider/ui/photo_slider.dart';
import 'package:lyxa_live/src/core/themes/cubits/theme_cubit.dart';
import 'package:lyxa_live/src/shared/handlers/errors/cubits/error_cubit.dart';
import 'package:lyxa_live/src/shared/handlers/errors/cubits/error_state.dart';
import 'package:lyxa_live/src/shared/handlers/errors/widgets/error_alert_unit.dart';
import 'package:lyxa_live/src/shared/handlers/loading/cubits/loading_cubit.dart';
import 'package:lyxa_live/src/shared/handlers/loading/cubits/loading_state.dart';
import 'package:lyxa_live/src/shared/handlers/loading/widgets/center_loading_unit.dart';
import 'package:lyxa_live/src/shared/widgets/toast_messenger_unit.dart';

/// Main Application Entry Point for LyxaApp
/// Root Level ->
class LyxaApp extends StatelessWidget {
  const LyxaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: _buildProviders(),
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (context, currentTheme) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: currentTheme,
          home: _buildMainScreen(),
        ),
      ),
    );
  }

  /// Define BLoC Providers for Dependency Injection
  /// & State management [Auth, Profile, Post, Search, Theme]
  /// ->
  List<BlocProvider> _buildProviders() {
    return [
      // Authentication Cubit
      BlocProvider<AuthCubit>(
        create: (context) => getIt<AuthCubit>()..checkAuthentication(),
      ),

      // Profile Cubit
      BlocProvider<ProfileCubit>(
        create: (context) => getIt<ProfileCubit>(),
      ),

      // Post Cubit
      BlocProvider<PostCubit>(
        create: (context) => getIt<PostCubit>(),
      ),

      // Search Cubit
      BlocProvider<SearchCubit>(
        create: (context) => getIt<SearchCubit>(),
      ),

      // Theme Cubit
      BlocProvider<ThemeCubit>(
        create: (context) => getIt<ThemeCubit>(),
      ),

      // Image Slider Cubit
      BlocProvider<SliderCubit>(
        create: (context) => getIt<SliderCubit>(),
      ),

      // Error Cubit
      BlocProvider<ErrorAlertCubit>(
        create: (context) => getIt<ErrorAlertCubit>(),
      ),

      // Loading Cubit
      BlocProvider<LoadingCubit>(
        create: (context) => getIt<LoadingCubit>(),
      ),
    ];
  }

  /// Displays the appropriate screen based on the user's authentication status.
  Widget _buildMainScreen() {
    return BlocConsumer<AuthCubit, AuthState>(
      builder: (context, state) {
        Logger.logDebug(state.toString());

        if (state is Unauthenticated) {
          //Show Authentication Screen
          return Stack(
            children: [
              const AuthScreen(),
              _buildLoadingScreen(),
              _buildErrorDisplayScreen(),
            ],
          );
        } else if (state is Authenticated) {
          // Show Main Home Screen
          return Stack(
            children: [
              const HomeScreen(),
              _buildPhotoSliderScreen(),
              _buildLoadingScreen(),
              _buildErrorDisplayScreen(),
            ],
          );
        } else {
          // Show Loading Indicator
          return _buildLoadingScreen();
        }
      },
      listener: (context, state) {
        // Show error messages if authentication fails
        if (state is AuthError) {
          Logger.logError(state.message.toString());
          ToastMessengerUnit.showErrorToast(
            context: context,
            message: state.message,
          );
        }
      },
    );
  }

  Widget _buildErrorDisplayScreen() {
    return BlocConsumer<ErrorAlertCubit, ErrorAlertState>(
      builder: (context, state) {
        return Visibility(
          visible: state.isVisible,
          child: const ErrorAlertUnit(),
        );
      },
      listener: (BuildContext context, ErrorAlertState state) {
        Logger.logDebug(state.errorMessage.toString());
      },
    );
  }

  Widget _buildLoadingScreen() {
    return BlocConsumer<LoadingCubit, LoadingState>(
      builder: (context, state) {
        return Visibility(
          visible: state.isVisible,
          child: CenterLoadingUnit(
            message: state.message,
          ),
        );
      },
      listener: (BuildContext context, LoadingState state) {
        Logger.logDebug(state.isVisible.toString());
      },
    );
  }

  Widget _buildPhotoSliderScreen() {
    return BlocConsumer<SliderCubit, SliderState>(
      builder: (context, state) {
        Logger.logDebug(state.toString());

        return (state is SliderLoaded)
            ? PhotoSlider(
                listImagesModel: state.images,
                current: state.currentIndex,
              )
            : const SizedBox.shrink();
      },
      listener: (context, state) {
        if (state is SliderError) {
          ToastMessengerUnit.showErrorToast(
            context: context,
            message: state.message,
          );
        }
      },
    );
  }
}
