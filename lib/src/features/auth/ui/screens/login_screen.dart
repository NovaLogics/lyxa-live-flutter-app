import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/values/app_dimensions.dart';
import 'package:lyxa_live/src/core/values/app_strings.dart';
import 'package:lyxa_live/src/features/auth/ui/components/gradient_button.dart';
import 'package:lyxa_live/src/features/auth/ui/components/scrollable_scaffold%20.dart';
import 'package:lyxa_live/src/shared/widgets/spacer_unit.dart';
import 'package:lyxa_live/src/shared/widgets/text_field_unit.dart';
import 'package:lyxa_live/src/features/auth/cubits/auth_cubit.dart';

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
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Transparent status bar
      statusBarBrightness: Brightness.dark, // Dark text for status bar
    ));

    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: Center(
          child: Stack(
            children: [
              _buildGradientBackground(),
              //  _buildBackdropFilter(),
              ScrollableScaffold(
                body: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.paddingLarge),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SpacerUnit(height: AppDimens.size24),
                      _buildLoginIcon(),
                      const SpacerUnit(height: AppDimens.size8),
                      _buildTitleText(),
                      const SpacerUnit(height: AppDimens.size24),
                      _buildEmailTextField(),
                      const SpacerUnit(height: AppDimens.size12),
                      _buildPasswordTextField(),
                      const SpacerUnit(height: AppDimens.size24),
                      _buildLoginButton(),
                      const Spacer(),
                      _buildRegisterLink(),
                    ],
                  ),
                ),
              ),
            ],
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

  Widget _buildGradientBackground() {
    return Stack(
      children: [
        _buildCircle(const AlignmentDirectional(3, -0.3),
            Colors.deepPurple[700] ?? Colors.deepPurple),
        _buildCircle(const AlignmentDirectional(-3, -0.3),
            Colors.deepPurple[700] ?? Colors.deepPurple),
        _buildCircle(
          const AlignmentDirectional(0, -1.2),
          Colors.blueGrey[900] ?? Colors.blueGrey,
          height: 300,
          width: 250,
        ),
        _buildCircle(
          const AlignmentDirectional(-0.3, 1.5),
          Colors.blueGrey[900] ?? Colors.blueGrey,
          height: 250,
          width: 300,
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
          child: Container(
            decoration: const BoxDecoration(color: Colors.transparent),
          ),
        ),
      ],
    );
  }

  Widget _buildCircle(
    AlignmentDirectional alignment,
    Color color, {
    double height = 300,
    double width = 300,
  }) {
    return Align(
      alignment: alignment,
      child: Container(
        height: height,
        width: width,
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
        height: 220.0,
        width: 220.0,
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
            fontFamily: 'Raleway',
          ),
        ),
        Text(
          AppStrings.itsTimeToShareYourStory,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: AppDimens.textSizeMedium,
            fontFamily: 'Raleway',
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
      prefixIcon: Icon(
        Icons.email_outlined,
        size: 22,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  /// Builds the password text field for user input
  Widget _buildPasswordTextField() {
    return TextFieldUnit(
      controller: _passwordController,
      hintText: AppStrings.password,
      obscureText: true,
      prefixIcon: Icon(
        Icons.lock_outlined,
        size: 22,
        color: Theme.of(context).colorScheme.primary,
      ),
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
    return Padding(
      padding: const EdgeInsets.only(
          bottom: AppDimens.size48, top: AppDimens.size32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppStrings.notAMember,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: AppDimens.textSizeMedium,
              fontFamily: 'Raleway',
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
                fontFamily: 'Raleway',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
