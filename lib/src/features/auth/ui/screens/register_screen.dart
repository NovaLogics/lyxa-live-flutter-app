import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/utils/constants/constants.dart';
import 'package:lyxa_live/src/core/values/app_dimensions.dart';
import 'package:lyxa_live/src/core/values/app_strings.dart';
import 'package:lyxa_live/src/features/auth/ui/components/gradient_button.dart';
import 'package:lyxa_live/src/features/auth/ui/components/scrollable_scaffold.dart';
import 'package:lyxa_live/src/shared/widgets/spacer_unit.dart';
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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ScrollableScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.paddingLarge,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SpacerUnit(height: AppDimens.size12),
              _buildTopBanner(),
              const SpacerUnit(height: AppDimens.size24),
              _buildTitleText(),
              const SpacerUnit(height: AppDimens.size24),
              _buildNameTextField(
                _nameController,
              ),
              const SpacerUnit(height: AppDimens.size12),
              _buildEmailTextField(
                _emailController,
              ),
              const SpacerUnit(height: AppDimens.size12),
              _buildPasswordTextField(
                _passwordController,
              ),
              const SpacerUnit(height: AppDimens.size12),
              _buildConfirmPasswordTextField(
                _confirmPasswordController,
              ),
              const SpacerUnit(height: AppDimens.size24),
              _buildSignUpButton(
                _register,
              ),
              const SpacerUnit(height: AppDimens.size52),
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

  void _register() {
    final String name = _nameController.text;
    final String email = _emailController.text;
    final String password = _passwordController.text;
    final String confirmPassword = _confirmPasswordController.text;

    final authCubit = context.read<AuthCubit>();

    if (name.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty) {
      if (password == confirmPassword) {
        authCubit.register(name, email, password);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(AppStrings.passwordNotMatchError)));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.registerErrorMessage)));
    }
  }

  /// Builds the logo displayed on the register screen
  Widget _buildTopBanner() {
    return Center(
      child: Image.asset(
        IMAGE_PATH_LYXA_BANNER,
        height: AppDimens.size3XLarge,
        width: AppDimens.size3XLarge,
      ),
    );
  }

  Widget _buildTitleText() {
    return Text(
      AppStrings.createAccountMessage,
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontSize: AppDimens.textSizeLarge,
        fontFamily: FONT_RALEWAY,
      ),
    );
  }

  Widget _buildNameTextField(TextEditingController controller) {
    return TextFieldUnit(
      controller: controller,
      hintText: AppStrings.name,
      obscureText: false,
      prefixIcon: Icon(
        Icons.person_outline,
        size: AppDimens.prefixIconSizeMedium,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildEmailTextField(TextEditingController controller) {
    return TextFieldUnit(
      controller: controller,
      hintText: AppStrings.email,
      obscureText: false,
      prefixIcon: Icon(
        Icons.email_outlined,
        size: AppDimens.prefixIconSizeMedium,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildPasswordTextField(TextEditingController controller) {
    return TextFieldUnit(
      controller: controller,
      hintText: AppStrings.password,
      obscureText: true,
      prefixIcon: Icon(
        Icons.lock_outlined,
        size: AppDimens.prefixIconSizeMedium,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildConfirmPasswordTextField(TextEditingController controller) {
    return TextFieldUnit(
      controller: controller,
      hintText: AppStrings.confirmPassword,
      obscureText: true,
      prefixIcon: Icon(
        Icons.lock_outlined,
        size: AppDimens.prefixIconSizeMedium,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildSignUpButton(Function() onTap) {
    return GradientButton(
      text: AppStrings.signUp.toUpperCase(),
      onPressed: onTap,
      textStyle: TextStyle(
        color: Theme.of(context).colorScheme.inversePrimary,
        fontWeight: FontWeight.bold,
        fontSize: AppDimens.textSizeMedium,
        letterSpacing: AppDimens.letterSpaceMedium,
        fontFamily: FONT_RALEWAY,
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
          Text(
            AppStrings.alreadyAMember,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: AppDimens.textSizeMedium,
              fontFamily: FONT_RALEWAY,
            ),
          ),
          const SizedBox(
            width: AppDimens.size8,
          ),
          GestureDetector(
            onTap: widget.onToggle,
            child: Text(
              AppStrings.loginNow,
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontSize: AppDimens.textSizeMedium,
                fontWeight: FontWeight.bold,
                fontFamily: FONT_RALEWAY,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
