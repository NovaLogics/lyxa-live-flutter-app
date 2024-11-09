import 'package:flutter/material.dart';
import 'package:lyxa_live/features/auth/presentation/components/spacer_unit.dart';
import 'package:lyxa_live/features/auth/presentation/components/text_field_unit.dart';

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
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              _loginIcon(),
              const SpacerUnit(height: 50),
              _titleText(),
              const SpacerUnit(height: 25),
              TextFieldUnit(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
              )
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
