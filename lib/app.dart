import 'package:flutter/material.dart';
import 'package:lyxa_live/features/auth/presentation/screens/auth_screen.dart';
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
  const LyxaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      home: const AuthScreen(),
    );
  }
}
