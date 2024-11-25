import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/di/service_locator.dart';
import 'package:lyxa_live/src/core/styles/app_text_styles.dart';
import 'package:lyxa_live/src/core/constants/constants.dart';
import 'package:lyxa_live/src/core/utils/hive_helper.dart';
import 'package:lyxa_live/src/core/utils/logger.dart';
import 'package:lyxa_live/src/core/utils/validator.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/resources/app_strings.dart';
import 'package:lyxa_live/src/features/auth/domain/entities/app_user.dart';
import 'package:lyxa_live/src/features/auth/ui/components/email_field_unit.dart';
import 'package:lyxa_live/src/features/auth/ui/components/gradient_button.dart';
import 'package:lyxa_live/src/features/auth/ui/components/password_field_unit.dart';
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

  late final AuthCubit _authCubit;

  @override
  void initState() {
    super.initState();
    _authCubit = getIt<AuthCubit>();
    _initializeEmailField();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingLG24,
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
            const SizedBox(height: AppDimens.size48),
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

  void _initializeEmailField() async {
    final savedUser = await _authCubit.getSavedUser(
      storageKey: HiveKeys.loginDataKey,
    );
    if (savedUser == null) return;

    Logger.logDebug(savedUser.toString());
    _emailController.text = savedUser.email;
  }

  void _login() {
    if (_formKey.currentState?.validate() != true) return;
    // All form fields are valid
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    _authCubit.saveUserToLocalStorage(
      storageKey: HiveKeys.loginDataKey,
      user: AppUser.createWith(email: email),
    );
    _authCubit.login(email, password);
  }

  Widget _buildTopBanner() {
    return Image.asset(
      IMAGE_LYXA_BANNER,
      height: AppDimens.bannerSize200,
      width: AppDimens.bannerSize200,
      fit: BoxFit.cover,
    );
  }

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

  Widget _buildEmailTextField() {
    return EmailFieldUnit(
      emailTextController: _emailController,
    );
  }

  Widget _buildPasswordTextField() {
    return PasswordFieldUnit(
      passwordTextController: _passwordController,
      hintText: AppStrings.hintPassword,
      passwordValidator: Validator.validatePassword,
    );
  }

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

              _authCubit.saveUserToLocalStorage(
                storageKey: HiveKeys.loginDataKey,
                user: AppUser.createWith(email: _emailController.text.trim()),
              );
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
