import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/features/auth/data/firebase_auth_repository.dart';
import 'package:lyxa_live/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:lyxa_live/features/auth/presentation/cubits/auth_state.dart';
import 'package:lyxa_live/features/auth/presentation/screens/auth_screen.dart';
import 'package:lyxa_live/features/home/presentation/screens/home_screen.dart';
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
  final authRepository = FirebaseAuthRepository();

  LyxaApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide Cubit to the App
    return BlocProvider(
      create: (context) =>
          AuthCubit(authRepository: authRepository)..checkAuth(),
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
