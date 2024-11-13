import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/values/app_dimensions.dart';
import 'package:lyxa_live/src/core/values/app_strings.dart';
import 'package:lyxa_live/src/features/auth/ui/components/button_unit.dart';
import 'package:lyxa_live/src/features/auth/ui/components/gradient_button.dart';
import 'package:lyxa_live/src/shared/widgets/spacer_unit.dart';
import 'package:lyxa_live/src/shared/widgets/text_field_unit.dart';
import 'package:lyxa_live/src/features/auth/cubits/auth_cubit.dart';
import 'package:lyxa_live/src/shared/widgets/responsive/constrained_scaffold.dart';

/*
LOGIN SCREEN:
Allows existing users to log in with email and password. 

-> After successful login, users are redirected to the Home Screen.

-> New users can navigate to the Register Screen.
*/

class LoginScreen extends StatefulWidget {
  final VoidCallback? toggleScreens;

  const LoginScreen({
    super.key,
    required this.toggleScreens,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppDimens.paddingLarge),
            child: Stack(
              children: [
                _buildBackgroundCircles(),
                _buildBackdropFilter(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLoginIcon(),
                    const SpacerUnit(height: AppDimens.size8),
                    _buildTitleText(),
                    const SpacerUnit(height: AppDimens.size24),
                    _buildEmailTextField(),
                    const SpacerUnit(height: AppDimens.size12),
                    _buildPasswordTextField(),
                    const SpacerUnit(height: AppDimens.size24),
                    _buildLoginButton(),
                    const SpacerUnit(height: AppDimens.size28),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: AppDimens.size24, right: AppDimens.size24),
                      child: Divider(
                        height: 1,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                    const SpacerUnit(height: AppDimens.size24),
                    _buildRegisterLink(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildBackdropFilter() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
      child: Container(
        decoration: const BoxDecoration(color: Colors.transparent),
      ),
    );
  }

  Widget _buildBackgroundCircles() {
    return Stack(
      children: [
        _buildCircle(const AlignmentDirectional(3, -0.3), Colors.deepPurple),
        _buildCircle(const AlignmentDirectional(-3, -0.3), Colors.deepPurple),
        _buildRectangle(
          const AlignmentDirectional(0, -1.2),
          Colors.amber[200] ?? Colors.orangeAccent,
          300,
          200,
        ),
        _buildRectangle(
          const AlignmentDirectional(-0.3, 1.5),
          Colors.blueGrey[900] ?? Colors.orangeAccent,
          250,
          300,
        ),
      ],
    );
  }

  Widget _buildCircle(AlignmentDirectional alignment, Color color) {
    return Align(
      alignment: alignment,
      child: Container(
        height: 300,
        width: 300,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }

  Widget _buildRectangle(AlignmentDirectional alignment, Color color,
      double height, double width) {
    return Align(
      alignment: alignment,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(color: color),
      ),
    );
  }

  /// Handles login action and displays a message if fields are empty
  void _login() {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    final authCubit = context.read<AuthCubit>();

    if (email.isNotEmpty && password.isNotEmpty) {
      authCubit.login(email, password);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.loginErrorMessage)),
      );
    }
  }

  /// Builds the icon displayed on the login screen
  Widget _buildLoginIcon() {
    return
        // Icon(
        //   Icons.lock_open_rounded,
        //   size: AppDimens.iconSize2XLarge,
        //   color: Theme.of(context).colorScheme.primary,
        // );

        //     Center(
        //   child: ClipRRect(
        //     borderRadius: BorderRadius.circular(8.0),
        //     child: Image.asset(
        //       "assets/images/lyxa_banner.png",
        //       height: 256.0,
        //       width: 256.0,
        //     ),
        //   ),
        // );

        Center(
      child:
          // Card(
          //   elevation: 12.0,
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(15.0),
          //   ),
          //   clipBehavior: Clip.hardEdge,
          //   child: Image.asset(
          //     "assets/images/lyxa_banner.png",
          //     height: 256.0,
          //     width: 256.0,
          //   ),
          // ),
          Image.asset(
        "assets/images/lyxa_banner.png",
        height: 260.0,
        width: 260.0,
      ),
    );
  }

  /// Displays the title text welcoming the user back
  Widget _buildTitleText() {
    return Column(
      children: [
        Text(
          AppStrings.welcomeBack.toUpperCase(),
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
            fontSize: AppDimens.textSizeXLarge,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          AppStrings.itsTimeToShareYourStory,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: AppDimens.textSizeMedium,
          ),
        ),
      ],
    );
  }

  /// Builds the email text field for user input
  Widget _buildEmailTextField() {
    return TextFieldUnit(
      controller: _emailController,
      hintText: AppStrings.email,
      obscureText: false,
    );
  }

  /// Builds the password text field for user input
  Widget _buildPasswordTextField() {
    return TextFieldUnit(
      controller: _passwordController,
      hintText: AppStrings.password,
      obscureText: true,
    );
  }

  /// Builds the login button, initiating the login process when tapped
  Widget _buildLoginButton() {
    return
        // ButtonUnit(
        //   onTap: _login,
        //   text: AppStrings.login,
        // );
        GradientButton(
      text: AppStrings.login,
      onPressed: _login,
    );
  }

  /// Displays a registration link for new users
  Widget _buildRegisterLink() {
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
        const SizedBox(
          width: 8,
        ),
        GestureDetector(
          onTap: widget.toggleScreens,
          child: Text(
            AppStrings.registerNow,
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontSize: AppDimens.textSizeMedium,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
