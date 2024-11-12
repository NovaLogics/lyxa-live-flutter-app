import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/values/app_dimensions.dart';
import 'package:lyxa_live/src/core/values/app_strings.dart';
import 'package:lyxa_live/src/features/auth/presentation/components/button_unit.dart';
import 'package:lyxa_live/src/features/auth/presentation/components/spacer_unit.dart';
import 'package:lyxa_live/src/features/auth/presentation/components/text_field_unit.dart';
import 'package:lyxa_live/src/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:lyxa_live/src/shared/widgets/responsive/constrained_scaffold.dart';

/*
LOGIN SCREEN
: On this screen > An existing user can login with their > email & password

-> Once the user successfully logs in, 
    thery will be redirected to the Home Screen

-> If user doesn't have an account yet, 
    they can go to Register Screen from here to create one.
*/

class LoginScreen extends StatefulWidget {
  final void Function()? toggleScreens;

  const LoginScreen({
    super.key,
    required this.toggleScreens,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppDimens.paddingLarge),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _loginScreenIcon(),
                const SpacerUnit(height: AppDimens.size52),
                _titleText(),
                const SpacerUnit(height: AppDimens.size24),
                _emailTextField(
                  emailController,
                ),
                const SpacerUnit(height: AppDimens.size12),
                _passwordTextField(
                  passwordController,
                ),
                const SpacerUnit(height: AppDimens.size24),
                _logInButton(
                  _login,
                ),
                const SpacerUnit(height: AppDimens.size52),
                _registerLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() {
    final String email = emailController.text;
    final String password = passwordController.text;

    final authCubit = context.read<AuthCubit>();

    if (email.isNotEmpty && password.isNotEmpty) {
      authCubit.login(email, password);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.loginErrorMessage)));
    }
  }

  Widget _loginScreenIcon() {
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

  Widget _emailTextField(TextEditingController controller) {
    return TextFieldUnit(
      controller: controller,
      hintText: AppStrings.email,
      obscureText: false,
    );
  }

  Widget _passwordTextField(TextEditingController controller) {
    return TextFieldUnit(
      controller: controller,
      hintText: AppStrings.password,
      obscureText: true,
    );
  }

  Widget _logInButton(Function()? onTap) {
    return ButtonUnit(
      onTap: onTap,
      text: AppStrings.login,
    );
  }

  Widget _registerLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.notAMember,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: AppDimens.textSizeMedium,
          ),
        ),
        GestureDetector(
          onTap: widget.toggleScreens,
          child: Text(
            AppStrings.registerNow,
            style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontSize: AppDimens.textSizeMedium,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
