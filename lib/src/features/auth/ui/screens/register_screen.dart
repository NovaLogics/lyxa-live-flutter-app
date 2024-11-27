import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/di/service_locator.dart';
import 'package:lyxa_live/src/core/resources/app_images.dart';
import 'package:lyxa_live/src/core/styles/app_styles.dart';
import 'package:lyxa_live/src/core/resources/text_field_limits.dart';
import 'package:lyxa_live/src/core/utils/hive_helper.dart';
import 'package:lyxa_live/src/core/utils/validator.dart';
import 'package:lyxa_live/src/core/resources/app_colors.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/resources/app_strings.dart';
import 'package:lyxa_live/src/features/auth/domain/entities/app_user.dart';
import 'package:lyxa_live/src/features/auth/ui/components/email_field_unit.dart';
import 'package:lyxa_live/src/features/auth/ui/components/gradient_button.dart';
import 'package:lyxa_live/src/features/auth/ui/components/password_field_unit.dart';
import 'package:lyxa_live/src/shared/widgets/text_field_unit.dart';
import 'package:lyxa_live/src/features/auth/cubits/auth_cubit.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback? onToggle;

  const RegisterScreen({
    super.key,
    required this.onToggle,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _registrationFormKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  late final AuthCubit _authCubit;

  @override
  void initState() {
    super.initState();
    _authCubit = getIt<AuthCubit>();
    _initFields();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingLG24,
        ),
        child: Form(
          key: _registrationFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: AppDimens.size12),
              _buildTopBanner(),
              const SizedBox(height: AppDimens.size12),
              _buildHeadingText(),
              const SizedBox(height: AppDimens.size24),
              _buildNameTextField(),
              const SizedBox(height: AppDimens.size12),
              _buildEmailTextField(),
              const SizedBox(height: AppDimens.size12),
              _buildPasswordTextField(),
              const SizedBox(height: AppDimens.size12),
              _buildConfirmPasswordTextField(),
              const SizedBox(height: AppDimens.size24),
              _buildSignUpButton(),
              const SizedBox(height: AppDimens.size52),
              _buildLoginLink(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _initFields() async {
    final savedUser = await _authCubit.getSavedUserOrDefault(
      storageKey: HiveKeys.signUpDataKey,
    );
    _nameController.text = savedUser.name;
    _emailController.text = savedUser.email;
  }

  void _register() {
    if (_registrationFormKey.currentState?.validate() != true) return;

    final String name = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    _authCubit.saveUserToLocalStorage(
      storageKey: HiveKeys.signUpDataKey,
      user: AppUser.createWith(name: name, email: email),
    );
    _authCubit.register(name, email, password);
  }

  String? _validateMainPassword(String? password) {
    return Validator.validatePasswordFileds(
      password: password,
      confirmPassword: _confirmPasswordController.text.trim(),
    );
  }

  String? _validateConfirmPassword(String? password) {
    return Validator.validatePasswordFileds(
      password: password,
      confirmPassword: _passwordController.text.trim(),
    );
  }

  Widget _buildTopBanner() {
    return Image.asset(
      AppImages.logoMainLyxa,
      height: AppDimens.size128,
      width: AppDimens.size128,
      fit: BoxFit.cover,
    );
  }

  Widget _buildHeadingText() {
    return Text(
      AppStrings.createAccountMessage,
      style: AppTextStyles.headingSecondary.copyWith(
        color: AppColors.white100,
        fontSize: AppDimens.fontSizeXXL24,
      ),
    );
  }

  Widget _buildNameTextField() {
    return TextFieldUnit(
      controller: _nameController,
      hintText: AppStrings.hintUsername,
      obscureText: false,
      prefixIcon: Icon(
        Icons.person_outline,
        size: AppDimens.iconSizeSM22,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      validator: (value) => Validator.validateUsername(value),
      maxLength: TextFieldLimits.usernameField,
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
      passwordValidator: _validateMainPassword,
    );
  }

  Widget _buildConfirmPasswordTextField() {
    return PasswordFieldUnit(
      passwordTextController: _confirmPasswordController,
      hintText: AppStrings.hintConfirmPassword,
      passwordValidator: _validateConfirmPassword,
    );
  }

  Widget _buildSignUpButton() {
    return GradientButton(
      text: AppStrings.signUp.toUpperCase(),
      onPressed: _register,
      textStyle: AppTextStyles.buttonTextPrimary.copyWith(
        color: Theme.of(context).colorScheme.inversePrimary,
      ),
      icon: Icon(
        Icons.arrow_forward_ios_sharp,
        color: Theme.of(context).colorScheme.inversePrimary,
      ),
    );
  }

  Widget _buildLoginLink() {
    return Padding(
      padding: const EdgeInsets.only(
          bottom: AppDimens.size48, top: AppDimens.size32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            AppStrings.alreadyAMember,
            style: AppTextStyles.subtitleSecondary,
          ),
          const SizedBox(
            width: AppDimens.size8,
          ),
          GestureDetector(
            onTap: () {
              widget.onToggle?.call();

              _authCubit.saveUserToLocalStorage(
                storageKey: HiveKeys.signUpDataKey,
                user: AppUser.createWith(
                  name: _nameController.text.trim(),
                  email: _emailController.text.trim(),
                ),
              );
            },
            child: const Text(
              AppStrings.loginNow,
              style: AppTextStyles.subtitlePrimary,
            ),
          ),
        ],
      ),
    );
  }
}
