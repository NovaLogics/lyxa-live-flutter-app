import 'package:flutter/material.dart';
import 'package:lyxa_live/constants/app_dimensions.dart';
import 'package:lyxa_live/constants/app_strings.dart';
import 'package:lyxa_live/features/auth/presentation/components/button_unit.dart';
import 'package:lyxa_live/features/auth/presentation/components/spacer_unit.dart';
import 'package:lyxa_live/features/auth/presentation/components/text_field_unit.dart';

class RegisterScreen extends StatefulWidget {
  final void Function()? toggleScreens;

  const RegisterScreen({
    super.key,
    required this.toggleScreens,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppDimens.paddingLarge),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _loginIcon(),
                const SpacerUnit(height: AppDimens.size52),
                _titleText(),
                const SpacerUnit(height: AppDimens.size24),
                _nameTextField(
                  nameController,
                ),
                const SpacerUnit(height: AppDimens.size12),
                _emailTextField(
                  emailController,
                ),
                const SpacerUnit(height: AppDimens.size12),
                _passwordTextField(
                  passwordController,
                ),
                const SpacerUnit(height: AppDimens.size12),
                _confirmPasswordTextField(
                  confirmPasswordController,
                ),
                const SpacerUnit(height: AppDimens.size24),
                _signUpButton(
                  () {},
                ),
                const SpacerUnit(height: AppDimens.size52),
                _loginLink(),
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
      AppStrings.createAccountMessage,
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontSize: AppDimens.textSizeMedium,
      ),
    );
  }

  Widget _nameTextField(TextEditingController controller) {
    return TextFieldUnit(
      controller: controller,
      hintText: AppStrings.name,
      obscureText: false,
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

  Widget _confirmPasswordTextField(TextEditingController controller) {
    return TextFieldUnit(
      controller: controller,
      hintText: AppStrings.confirmPassword,
      obscureText: true,
    );
  }

  Widget _signUpButton(Function()? onTap) {
    return ButtonUnit(
      onTap: onTap,
      text: AppStrings.signUp,
    );
  }

  Widget _loginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.alreadyAMember,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: AppDimens.textSizeMedium,
          ),
        ),
        GestureDetector(
          onTap: widget.toggleScreens,
          child: Text(
            AppStrings.loginNow,
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontSize: AppDimens.textSizeMedium,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ],
    );
  }
}
