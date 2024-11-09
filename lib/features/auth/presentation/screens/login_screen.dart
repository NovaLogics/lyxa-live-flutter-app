import 'package:flutter/material.dart';

/*
LOGIN SCREEN
: On this screen > An existing user can login with their > email & password

-> Once the user successfully logs in, 
    thery will be redirected to the Home Screen

-> If user doesn't have an account yet, 
    they can go to Register Screen from here to create one.
*/

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              _loginIcon(),
              _spacing(height: 50),
              _titleText(),
              _spacing(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loginIcon() {
    return Icon(
      Icons.lock_open_rounded,
      size: 72,
      color: Theme.of(context).colorScheme.primary,
    );
  }

  Widget _titleText() {
    return Text(
      "Welcome back, you've been missed!",
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontSize: 16,
      ),
    );
  }
}

/// Returns a [SizedBox]
/// with a specified [height] and [width]
/// to create space between widgets.
Widget _spacing({double height = 0.0, double width = 0.0}) {
  return SizedBox(
    height: height,
    width: width,
  );
}
