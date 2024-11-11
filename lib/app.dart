import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/features/auth/data/firebase_auth_repository.dart';
import 'package:lyxa_live/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:lyxa_live/features/auth/presentation/cubits/auth_state.dart';
import 'package:lyxa_live/features/auth/presentation/screens/auth_screen.dart';
import 'package:lyxa_live/features/home/presentation/screens/home_screen.dart';
import 'package:lyxa_live/features/post/data/firebase_post_repository.dart';
import 'package:lyxa_live/features/post/presentation/cubits/post_cubit.dart';
import 'package:lyxa_live/features/profile/data/firebase_profile_repository.dart';
import 'package:lyxa_live/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:lyxa_live/features/storage/data/firebase_storage_repository.dart';
import 'package:lyxa_live/themes/light_mode.dart';

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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightMode,
        home: BlocConsumer<AuthCubit, AuthState>(builder: (context, authState) {
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
    );
  }
}
