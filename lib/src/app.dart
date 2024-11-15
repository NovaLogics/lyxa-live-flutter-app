import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:lyxa_live/src/features/storage/data/firebase_storage_repository.dart';
import 'package:lyxa_live/src/core/themes/theme_cubit.dart';

/// Main Application Entry Point for LyxaApp
/// Root Level ->
class LyxaApp extends StatelessWidget {
  /// Define Repositories (Database > Firebase)
  /// ->
  final FirebaseAuthRepository _authRepository = FirebaseAuthRepository();
  final FirebaseProfileRepository _profileRepository =
      FirebaseProfileRepository();
  final FirebaseStorageRepository _storageRepository =
      FirebaseStorageRepository();
  final FirebasePostRepository _postRepository = FirebasePostRepository();
  final FirebaseSearchRepository _searchRepository = FirebaseSearchRepository();

  LyxaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: _buildProviders(),
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (context, currentTheme) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: currentTheme,
          home: _buildHomeScreen(context),
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
        create: (context) =>
            AuthCubit(authRepository: _authRepository)..checkAuthentication(),
      ),

      // Profile Cubit
      BlocProvider<ProfileCubit>(
        create: (context) => ProfileCubit(
          profileRepository: _profileRepository,
          storageRepository: _storageRepository,
        ),
      ),

      // Post Cubit
      BlocProvider<PostCubit>(
        create: (context) => PostCubit(
          postRepository: _postRepository,
          storageRepository: _storageRepository,
        ),
      ),

      // Search Cubit
      BlocProvider<SearchCubit>(
        create: (context) => SearchCubit(searchRepository: _searchRepository),
      ),

      // Theme Cubit
      BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),
    ];
  }

  /// Displays the appropriate screen based on the user's authentication status.
  Widget _buildHomeScreen(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      builder: (context, authState) {
        if (kDebugMode) print(authState);

        if (authState is Unauthenticated) {
          // Show Authentication Screen
          return AuthScreen(authUser: authState.user,);
        } else if (authState is AuthLoading) {
          // Show Authentication Screen with loading
          return const AuthScreen(isLoading: true,);
        }else if (authState is Authenticated) {
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
    );
  }
}
