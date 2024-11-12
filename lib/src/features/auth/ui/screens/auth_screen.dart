import 'package:flutter/material.dart';
import 'package:lyxa_live/src/features/auth/ui/screens/login_screen.dart';
import 'package:lyxa_live/src/features/auth/ui/screens/register_screen.dart';

/*
AUTH SCREEN
: This screen determines whether to show the login or register page
*/

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool showLoginPage = true;

  void toggleScreens() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginScreen(
        toggleScreens: toggleScreens,
      );
    } else {
      return RegisterScreen(
        toggleScreens: toggleScreens,
      );
    }
  }
}
