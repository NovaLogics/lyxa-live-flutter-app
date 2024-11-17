import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/styles/app_text_styles.dart';
import 'package:lyxa_live/src/core/utils/constants/constants.dart';
import 'package:lyxa_live/src/core/utils/helper/validator.dart';
import 'package:lyxa_live/src/core/values/app_dimensions.dart';
import 'package:lyxa_live/src/core/values/app_strings.dart';
import 'package:lyxa_live/src/features/auth/domain/entities/app_user.dart';
import 'package:lyxa_live/src/features/auth/ui/components/gradient_button.dart';
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

  const LoginScreen({
    super.key,
    required this.onToggle,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late final authCubit = context.read<AuthCubit>();

  @override
  Widget build(BuildContext context) {
    _initFields();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingLarge,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: AppDimens.size64),
            _buildTopBanner(),
            _buildHeadingText(),
            _buildSubheadingText(),
            const SizedBox(height: AppDimens.size24),
            _buildEmailTextField(),
            const SizedBox(height: AppDimens.size12),
            _buildPasswordTextField(),
            const SizedBox(height: AppDimens.size24),
            _buildLoginButton(),
            const Spacer(),
            _buildRegisterLink(),
          ],
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

  void _initFields() async {
    final AppUser? savedUser = await authCubit.getSavedUser();
    _emailController.text = savedUser?.email ?? '';
  }

  /// Handles login action and displays a message if fields are empty
  void _login() {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (_formKey.currentState?.validate() ?? false) {
      _saveUser();

      authCubit.login(email, password);
    }
  }

  Future<void> _saveUser() async {
    AppUser user = AppUser.createWith(email: _emailController.text.trim());
    await authCubit.saveUser(user);
  }

  /// Builds the icon displayed on the login screen
  Widget _buildTopBanner() {
    return Image.asset(
      IMAGE_PATH_LYXA_BANNER,
      height: AppDimens.bannerSizeMedium,
      width: AppDimens.bannerSizeMedium,
    );
  }

  /// Displays the title text welcoming the user back
  Widget _buildHeadingText() {
    return const Text(
      AppStrings.welcomeBack,
      style: AppTextStyles.headingPrimary,
    );
  }

  Widget _buildSubheadingText() {
    return const Text(
      AppStrings.itsTimeToShareYourStory,
      style: AppTextStyles.headingSecondary,
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
      textStyle: AppTextStyles.buttonTextPrimary.copyWith(
        color: Theme.of(context).colorScheme.inversePrimary,
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
            style: AppTextStyles.subtitleSecondary,
          ),
          const SizedBox(width: AppDimens.size8),
          GestureDetector(
            onTap: () {
              widget.onToggle?.call();
              _saveUser();
            },
            child: const Text(
              AppStrings.registerNow,
              style: AppTextStyles.subtitlePrimary,
            ),
          ),
        ],
      ),
    );
  }
}
