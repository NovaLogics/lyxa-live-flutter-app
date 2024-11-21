import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lyxa_live/src/core/di/service_locator.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/utils/logger.dart';
import 'package:lyxa_live/src/features/auth/data/firebase_auth_repository.dart';
import 'package:lyxa_live/src/features/auth/cubits/auth_cubit.dart';
import 'package:lyxa_live/src/features/auth/cubits/auth_state.dart';
import 'package:lyxa_live/src/features/auth/ui/screens/auth_screen.dart';
import 'package:lyxa_live/src/features/home/ui/screens/home_screen.dart';
import 'package:lyxa_live/src/features/post/data/firebase_post_repository.dart';
import 'package:lyxa_live/src/features/post/cubits/post_cubit.dart';
import 'package:lyxa_live/src/features/profile/data/firebase_profile_repository.dart';
import 'package:lyxa_live/src/features/profile/cubits/profile_cubit.dart';
import 'package:lyxa_live/src/features/search/data/firebase_search_repository.dart';
import 'package:lyxa_live/src/features/search/cubits/search_cubit.dart';
import 'package:lyxa_live/src/features/photo_slider/cubits/slider_cubit.dart';
import 'package:lyxa_live/src/features/photo_slider/cubits/slider_state.dart';
import 'package:lyxa_live/src/features/photo_slider/ui/photo_slider.dart';
import 'package:lyxa_live/src/features/storage/data/firebase_storage_repository.dart';
import 'package:lyxa_live/src/core/themes/cubits/theme_cubit.dart';
import 'package:lyxa_live/src/shared/widgets/gradient_background_unit.dart';
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
          home: Stack(
            children: [
              getIt<GradientBackgroundUnit>(
                param1: AppDimens.containerSize400,
                param2: BackgroundStyle.auth,
              ),
              _buildHomeScreen(),
              _buildPhotoSliderScreen(),
            ],
          ),
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
        create: (context) => AuthCubit(
          authRepository: GetIt.instance<FirebaseAuthRepository>(),
        )..checkAuthentication(),
      ),

      // Profile Cubit
      BlocProvider<ProfileCubit>(
        create: (context) => ProfileCubit(
          profileRepository: GetIt.instance<FirebaseProfileRepository>(),
          storageRepository: GetIt.instance<FirebaseStorageRepository>(),
        ),
      ),

      // Post Cubit
      BlocProvider<PostCubit>(
        create: (context) => PostCubit(
          postRepository: GetIt.instance<FirebasePostRepository>(),
          storageRepository: GetIt.instance<FirebaseStorageRepository>(),
        ),
      ),

      // Search Cubit
      BlocProvider<SearchCubit>(
        create: (context) => SearchCubit(
          searchRepository: GetIt.instance<FirebaseSearchRepository>(),
        ),
      ),

      // Theme Cubit
      BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),

      // Image Slider Cubit
      BlocProvider<SliderCubit>(create: (context) => SliderCubit()),
    ];
  }

  /// Displays the appropriate screen based on the user's authentication status.
  Widget _buildHomeScreen() {
    return BlocConsumer<AuthCubit, AuthState>(
      builder: (context, state) {
        Logger.logDebug(state.toString());

        if (state is Unauthenticated) {
          // Show Authentication Screen
          return const AuthScreen();
        } else if (state is AuthLoading) {
          // Show Authentication Screen with loading
          return const AuthScreen(
            isLoading: true,
          );
        } else if (state is Authenticated) {
          // Show Main Home Screen
          return const HomeScreen();
        } else {
          // Show Loading Indicator
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
      listener: (context, state) {
        // Show error messages if authentication fails
        if (state is AuthError) {
          ToastMessengerUnit.showErrorToast(
            context: context,
            message: state.message,
          );
        }
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
