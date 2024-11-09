import 'package:flutter/material.dart';
import 'package:lyxa_live/constants/app_dimensions.dart';
import 'package:lyxa_live/constants/app_strings.dart';
import 'package:lyxa_live/features/auth/presentation/components/button_unit.dart';
import 'package:lyxa_live/features/auth/presentation/components/spacer_unit.dart';
import 'package:lyxa_live/features/auth/presentation/components/text_field_unit.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
    final nameController = TextEditingController();
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
              mainAxisAlignment: MainAxisAlignment.center,
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
                ButtonUnit(
                  onTap: () {},
                  text: AppStrings.login,
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

  Widget _registerLink() {
    return Text(
      AppStrings.registerNowMessage,
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontSize: AppDimens.textSizeMedium,
      ),
    );
  }
}