import 'package:flutter/material.dart';
import 'package:lyxa_live/constants/app_dimensions.dart';
import 'package:lyxa_live/constants/app_strings.dart';
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
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppDimens.paddingLarge),
            child: Column(
              children: [
                _loginIcon(),
                const SpacerUnit(height: AppDimens.size52),
                _titleText(),
                const SpacerUnit(height: AppDimens.size24),
                TextFieldUnit(
                  controller: emailController,
                  hintText: AppStrings.email,
                  obscureText: false,
                ),
                const SpacerUnit(height: AppDimens.size12),
                TextFieldUnit(
                  controller: passwordController,
                  hintText: AppStrings.password,
                  obscureText: true,
                ),
                const SpacerUnit(height: AppDimens.size24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginIcon() {
    return Icon(
      Icons.lock_open_rounded,
      size: AppDimens.iconSize2XLarge,
      color: Theme.of(context).colorScheme.primary,
    );
  }

  Widget _titleText() {
    return Text(
      AppStrings.welcomeBackMessage,
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontSize: AppDimens.textSizeMedium,
      ),
    );
  }
}
