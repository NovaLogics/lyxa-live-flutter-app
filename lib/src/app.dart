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

  List<BlocProvider> _buildProviders() {
    return [
      // AUTH CUBIT
      BlocProvider<AuthCubit>(
        create: (context) => getIt<AuthCubit>()..checkAuth(),
      ),
      // PROFILE CUBIT
      BlocProvider<ProfileCubit>(
        create: (context) => getIt<ProfileCubit>(),
      ),
      // POST CUBIT
      BlocProvider<PostCubit>(
        create: (context) => getIt<PostCubit>(),
      ),
      // SEARCH CUBIT
      BlocProvider<SearchCubit>(
        create: (context) => getIt<SearchCubit>(),
      ),
      // THEME CUBIT
      BlocProvider<ThemeCubit>(
        create: (context) => getIt<ThemeCubit>(),
      ),
      // IMAGE SLIDER CUBIT
      BlocProvider<SliderCubit>(
        create: (context) => getIt<SliderCubit>(),
      ),
      // ERROR CUBIT
      BlocProvider<ErrorAlertCubit>(
        create: (context) => getIt<ErrorAlertCubit>(),
      ),
      // LOADING CUBIT
      BlocProvider<LoadingCubit>(
        create: (context) => getIt<LoadingCubit>(),
      ),
    ];
  }

  Widget _buildMainScreen() {
    return BlocConsumer<AuthCubit, AuthState>(
      builder: (context, state) {
        Logger.logDebug(state.toString());

        // SHOW AUTH SCREEN
        if (state is Unauthenticated) {
          return Stack(
            children: [
              const AuthScreen(),
              _buildLoadingScreen(),
              _buildErrorDisplayScreen(),
            ],
          );
        }
        // SHOW MAIN/HOME SCREEN
        else if (state is Authenticated) {
          return Stack(
            children: [
              const HomeScreen(),
              _buildPhotoSliderScreen(),
              _buildLoadingScreen(),
              _buildErrorDisplayScreen(),
            ],
          );
        }
        // SHOW LOADING INDICATOR
        else {
          return _buildLoadingScreen();
        }
      },
      listener: (context, state) {
        // SHOW ERROR IF AUTHENTICATION FAILS
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
          child: CenterLoadingUnit(
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
