import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/utils/constants/constants.dart';
import 'package:lyxa_live/src/core/utils/helper/validator.dart';
import 'package:lyxa_live/src/core/values/app_colors.dart';
import 'package:lyxa_live/src/core/values/app_dimensions.dart';
import 'package:lyxa_live/src/core/values/app_strings.dart';
import 'package:lyxa_live/src/features/auth/domain/entities/app_user.dart';
import 'package:lyxa_live/src/features/auth/ui/components/gradient_button.dart';
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
  final VoidCallback? onToggle;
  final AppUser? authUser;

  const LoginScreen({
    super.key,
    required this.onToggle,
    this.authUser,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingLarge,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SpacerUnit(height: AppDimens.size64),
            _buildTopBanner(),
            //const SpacerUnit(height: AppDimens.size8),
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
    );
  }

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.authUser?.email ?? "";
    _passwordController.text = widget.authUser?.password ?? "";
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Handles login action and displays a message if fields are empty
  void _login() {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (_formKey.currentState?.validate() ?? false) {
      final authCubit = context.read<AuthCubit>();
      authCubit.login(email, password);
    }

    // if (email.isNotEmpty && password.isNotEmpty) {
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text(AppStrings.loginErrorMessage)),
    //   );
    // }
  }

  /// Builds the icon displayed on the login screen
  Widget _buildTopBanner() {
    return Center(
      child: Image.asset(
        IMAGE_PATH_LYXA_BANNER,
        height: AppDimens.bannerSizeMedium,
        width: AppDimens.bannerSizeMedium,
      ),
    );
  }

  /// Displays the title text welcoming the user back
  Widget _buildTitleText() {
    return const Column(
      children: [
        Text(
          AppStrings.welcomeBack,
          style: TextStyle(
            color: AppColors.whiteShade50,
            fontSize: AppDimens.textSizeTitleLarge,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
            fontFamily: FONT_DYNALIGHT,
            shadows: <Shadow>[
              Shadow(
                offset: Offset(1, 1),
                blurRadius: 1.0,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ],
          ),
        ),
        Text(
          AppStrings.itsTimeToShareYourStory,
          style: TextStyle(
            color: AppColors.blueGreyShade50,
            fontSize: AppDimens.textSizeLarge,
            fontFamily: FONT_RALEWAY,
            shadows: <Shadow>[
              Shadow(
                offset: Offset(1, 1),
                blurRadius: 1.0,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds the email text field for user input
  Widget _buildEmailTextField() {
    return TextFieldUnit(
      controller: _emailController,
      hintText: AppStrings.hintEmail,
      obscureText: false,
      prefixIcon: Icon(
        Icons.email_outlined,
        size: AppDimens.prefixIconSizeMedium,
        color: Theme.of(context).colorScheme.primary,
      ),
      validator: (value) => Validator.validateEmail(value),
      maxLength: MAX_LENGTH_EMAIL_FIELD,
    );
  }

  /// Builds the password text field for user input
  Widget _buildPasswordTextField() {
    return TextFieldUnit(
      controller: _passwordController,
      hintText: AppStrings.hintPassword,
      obscureText: true,
      prefixIcon: Icon(
        Icons.lock_outlined,
        size: AppDimens.prefixIconSizeMedium,
        color: Theme.of(context).colorScheme.primary,
      ),
      validator: (value) => Validator.validatePassword(value),
      maxLength: MAX_LENGTH_PASSWORD_FIELD,
    );
  }

  /// Builds the login button, initiating the login process when tapped
  Widget _buildLoginButton() {
    return GradientButton(
      text: AppStrings.login.toUpperCase(),
      onPressed: _login,
      textStyle: TextStyle(
        color: Theme.of(context).colorScheme.inversePrimary,
        fontWeight: FontWeight.bold,
        fontSize: AppDimens.textSizeMedium,
        letterSpacing: AppDimens.letterSpaceMedium,
        fontFamily: FONT_RALEWAY,
      ),
      icon: Icon(
        Icons.arrow_forward_outlined,
        color: Theme.of(context).colorScheme.inversePrimary,
      ),
    );
  }

  /// Displays a registration link for new users
  Widget _buildRegisterLink() {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppDimens.size48,
        top: AppDimens.size32,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            AppStrings.notAMember,
            style: TextStyle(
              color: AppColors.blueGreyShade50,
              fontSize: AppDimens.textSizeMedium,
              fontFamily: FONT_RALEWAY,
              shadows: <Shadow>[
                Shadow(
                  offset: Offset(1, 1),
                  blurRadius: 1.0,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: AppDimens.size8,
          ),
          GestureDetector(
            onTap: widget.onToggle,
            child: const Text(
              AppStrings.registerNow,
              style: TextStyle(
                color: AppColors.whiteShade50,
                fontSize: AppDimens.textSizeMedium,
                fontWeight: FontWeight.bold,
                fontFamily: FONT_RALEWAY,
                letterSpacing: 0.7,
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(1, 1),
                    blurRadius: 1.0,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
