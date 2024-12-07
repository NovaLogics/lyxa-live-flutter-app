import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/dependency_injection/service_locator.dart';
import 'package:lyxa_live/src/core/constants/resources/app_strings.dart';
import 'package:lyxa_live/src/core/utils/logger.dart';
import 'package:lyxa_live/src/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:lyxa_live/src/features/auth/presentation/cubits/auth_state.dart';
import 'package:lyxa_live/src/features/auth/presentation/screens/auth_screen.dart';
import 'package:lyxa_live/src/features/home/presentation/cubits/home_cubit.dart';
import 'package:lyxa_live/src/features/profile/cubits/self_profile_cubit.dart';
import 'package:lyxa_live/src/shared/widgets/bottom_navigation_bar/lyxa_navigation_screens.dart';
import 'package:lyxa_live/src/features/post/cubits/post_cubit.dart';
import 'package:lyxa_live/src/features/profile/cubits/profile_cubit.dart';
import 'package:lyxa_live/src/features/search/cubits/search_cubit.dart';
import 'package:lyxa_live/src/features/photo_slider/cubits/slider_cubit.dart';
import 'package:lyxa_live/src/core/themes/theme_cubit.dart';
import 'package:lyxa_live/src/shared/handlers/errors/cubits/error_cubit.dart';
import 'package:lyxa_live/src/shared/handlers/loading/cubits/loading_cubit.dart';
import 'package:lyxa_live/src/shared/handlers/loading/widgets/loading_unit.dart';
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
      // HOME CUBIT
      BlocProvider<HomeCubit>(
        create: (context) => getIt<HomeCubit>(),
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

      // SELF PROFILE CUBIT
      BlocProvider<SelfProfileCubit>(
        create: (context) => getIt<SelfProfileCubit>(),
      ),
    ];
  }

  Widget _buildMainScreen() {
    return BlocConsumer<AuthCubit, AuthState>(
      builder: (context, state) {
        Logger.logDebug(state.toString());

        // SHOW AUTH SCREEN
        if (state is Unauthenticated) {
          return const AuthScreen();
        }
        // SHOW MAIN/HOME SCREEN
        else if (state is Authenticated) {
          return LyxaNavigationScreens(
            appUser: state.user,
          );
        }
        // SHOW LOADING INDICATOR
        else {
          return const LoadingUnit(
            message: AppStrings.loadingMessage,
          );
        }
      },
      listener: (context, state) {
        // SHOW ERROR IF AUTHENTICATION FAILS
        if (state is AuthError) {
          ToastMessengerUnit.showErrorToast(
            context: context,
            message: state.message,
          );
        }
      },
    );
  }
}
