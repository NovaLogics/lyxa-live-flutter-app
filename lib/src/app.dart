import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/features/auth/data/firebase_auth_repository.dart';
import 'package:lyxa_live/src/features/auth/cubits/auth_cubit.dart';
import 'package:lyxa_live/src/features/auth/cubits/auth_state.dart';
import 'package:lyxa_live/src/features/auth/ui/screens/auth_screen.dart';
import 'package:lyxa_live/src/features/home/presentation/screens/home_screen.dart';
import 'package:lyxa_live/src/features/post/data/firebase_post_repository.dart';
import 'package:lyxa_live/src/features/post/presentation/cubits/post_cubit.dart';
import 'package:lyxa_live/src/features/profile/data/firebase_profile_repository.dart';
import 'package:lyxa_live/src/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:lyxa_live/src/features/search/data/firebase_search_repository.dart';
import 'package:lyxa_live/src/features/search/presentation/cubits/search_cubit.dart';
import 'package:lyxa_live/src/features/storage/data/firebase_storage_repository.dart';
import 'package:lyxa_live/src/core/themes/theme_cubit.dart';

/*
APP - Root Level
:Tasks > Init | Impl:

-> Repositories > For database
  [Firebase]

-> BLoC Providers > For state management
  [Auth, Profile, Post, Search, Theme]

-> Check Auth State
  [Unauthenticated  > Auth screen (Login/Register) ]
  [Authenticated    > Home Screen ]
*/

class LyxaApp extends StatelessWidget {
  final firebaseAuthRepository = FirebaseAuthRepository();
  final firebaseProfileRepository = FirebaseProfileRepository();
  final firebaseStorageRepository = FirebaseStorageRepository();
  final firebasePostRepository = FirebasePostRepository();
  final firebaseSearchRepository = FirebaseSearchRepository();

  LyxaApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide Cubit to the App
    return MultiBlocProvider(
      providers: [
        // Auth cubit
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(
            authRepository: firebaseAuthRepository,
          )..checkAuth(),
        ),

        // Profile cubit
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(
            profileRepository: firebaseProfileRepository,
            storageRepository: firebaseStorageRepository,
          ),
        ),

        // Post cubit
        BlocProvider<PostCubit>(
          create: (context) => PostCubit(
            postRepository: firebasePostRepository,
            storageRepository: firebaseStorageRepository,
          ),
        ),

        // Search cubit
        BlocProvider<SearchCubit>(
          create: (context) => SearchCubit(
            searchRepository: firebaseSearchRepository,
          ),
        ),

        // Theme cubit
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (context, currentTheme) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: currentTheme,
          home:
              BlocConsumer<AuthCubit, AuthState>(builder: (context, authState) {
            if (kDebugMode) {
              print(authState);
            }
            // Unauthenticated -> Auth Screen (Login/Register)
            if (authState is Unauthenticated) {
              return const AuthScreen();
            }
            // Authenticated -> Home Screen
            else if (authState is Authenticated) {
              return const HomeScreen();
            }
            // Loading
            else {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
                  // Listen for errors
                  listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
          }),
        ),
      ),
    );
  }
}
