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
    return const Scaffold(
      backgroundColor: Colors.blueAccent,
    );
  }
}