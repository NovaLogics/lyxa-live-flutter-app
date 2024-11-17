import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/styles/app_text_styles.dart';
import 'package:lyxa_live/src/core/utils/constants/constants.dart';
import 'package:lyxa_live/src/core/utils/helper/hive_helper.dart';
import 'package:lyxa_live/src/core/utils/helper/logger.dart';
import 'package:lyxa_live/src/core/utils/helper/validator.dart';
import 'package:lyxa_live/src/core/values/app_colors.dart';
import 'package:lyxa_live/src/core/values/app_dimensions.dart';
import 'package:lyxa_live/src/core/values/app_strings.dart';
import 'package:lyxa_live/src/features/auth/domain/entities/app_user.dart';
import 'package:lyxa_live/src/features/auth/ui/components/email_field_unit.dart';
import 'package:lyxa_live/src/features/auth/ui/components/gradient_button.dart';
import 'package:lyxa_live/src/features/auth/ui/components/password_field_unit.dart';
import 'package:lyxa_live/src/shared/widgets/custom_toast.dart';
import 'package:lyxa_live/src/shared/widgets/text_field_unit.dart';
import 'package:lyxa_live/src/features/auth/cubits/auth_cubit.dart';

class RegisterScreen extends StatefulWidget {
  final void Function()? onToggle;

  const RegisterScreen({
    super.key,
    required this.onToggle,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  late final AuthCubit _authCubit;

  @override
  void initState() {
    super.initState();
    _authCubit = context.read<AuthCubit>();
    _initializeFields();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingLarge,
        ),
        child: Form(
          key: _formKey,
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

  void _initializeFields() async {
    final savedUser =
        await _authCubit.getSavedUser(key: HiveKeys.signUpDataKey);
    if (savedUser != null) {
      Logger.logDebug(savedUser.toString());
      _nameController.text = savedUser.name;
      _emailController.text = savedUser.email;
    }
  }

  void _register() {
    if (_formKey.currentState?.validate() ?? false) {
      final String name = _nameController.text.trim();
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();

      try {
        AppUser cachedUser = AppUser.createWith(name: name, email: email);

        _authCubit.saveUser(cachedUser, key: HiveKeys.signUpDataKey);
        _authCubit.register(name, email, password);
      } catch (error) {
        CustomToast.showToast(
          context: context,
          message: AppStrings.registerErrorMessage,
          icon: Icons.error,
          backgroundColor: AppColors.deepPurpleShade900,
          textColor: Colors.white,
          shadowColor: Colors.black,
          duration: const Duration(seconds: 5),
        );
      }
    }
  }

  String? _validateMainPassword(String? value) {
    return Validator.validatePasswordFileds(
      value,
      _confirmPasswordController.text.trim(),
    );
  }

  String? _validateConfirmPassword(String? value) {
    return Validator.validatePasswordFileds(
      value,
      _passwordController.text.trim(),
    );
  }

  Widget _buildTopBanner() {
    return Image.asset(
      IMAGE_PATH_LYXA_BANNER,
      height: AppDimens.size3XLarge,
      width: AppDimens.size3XLarge,
    );
  }

  Widget _buildHeadingText() {
    return Text(
      AppStrings.createAccountMessage,
      style: AppTextStyles.headingSecondary.copyWith(
        color: AppColors.whiteShade100,
        fontSize: AppDimens.textSizeXLarge,
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
        size: AppDimens.prefixIconSizeMedium,
        color: Theme.of(context).colorScheme.primary,
      ),
      validator: (value) => Validator.validateUsername(value),
      maxLength: MAX_LENGTH_USERNAME_FIELD,
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
        bottom: AppDimens.size48,
        top: AppDimens.size32,
      ),
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

              _authCubit.saveUser(
                AppUser.createWith(
                  name: _nameController.text.trim(),
                  email: _emailController.text.trim(),
                ),
                key: HiveKeys.signUpDataKey,
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
