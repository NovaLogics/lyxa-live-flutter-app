import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:lyxa_live/src/core/dependency_injection/service_locator.dart';
import 'package:lyxa_live/src/core/constants/assets/app_images.dart';
import 'package:lyxa_live/src/core/constants/styles/app_styles.dart';
import 'package:lyxa_live/src/core/validations/text_field_limits.dart';
import 'package:lyxa_live/src/core/services/storage/hive_storage.dart';
import 'package:lyxa_live/src/core/validations/validator.dart';
import 'package:lyxa_live/src/core/constants/resources/app_colors.dart';
import 'package:lyxa_live/src/core/constants/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/constants/resources/app_strings.dart';
import 'package:lyxa_live/src/features/auth/data/models/app_user_model.dart';
import 'package:lyxa_live/src/features/auth/presentation/widgets/email_field_unit.dart';
import 'package:lyxa_live/src/features/auth/presentation/widgets/gradient_button.dart';
import 'package:lyxa_live/src/features/auth/presentation/widgets/password_field_unit.dart';
import 'package:lyxa_live/src/shared/widgets/spacers_unit.dart';
import 'package:lyxa_live/src/shared/widgets/text_field_unit.dart';
import 'package:lyxa_live/src/features/auth/presentation/cubits/auth_cubit.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback? onToggleScreen;

  const RegisterScreen({
    super.key,
    required this.onToggleScreen,
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

  String get _name => _nameController.text.trim();
  String get _email => _emailController.text.trim();
  String get _password => _passwordController.text.trim();
  bool get _isWebPlatform => kIsWeb;

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
              addSpacing(height: AppDimens.size12),
              _buildTopBanner(),
              addSpacing(height: AppDimens.size12),
              _buildHeadingText(),
              addSpacing(height: AppDimens.size24),
              _buildNameTextField(),
              addSpacing(height: AppDimens.size12),
              _buildEmailTextField(),
              addSpacing(height: AppDimens.size12),
              _buildPasswordTextField(),
              addSpacing(height: AppDimens.size12),
              _buildConfirmPasswordTextField(),
              addSpacing(height: AppDimens.size24),
              _buildSignUpButton(),
              addSpacing(
                height: _isWebPlatform ? AppDimens.size40 : AppDimens.size52,
              ),
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

  void _handleSignUp() {
    if (_registrationFormKey.currentState?.validate() != true) return;

    _saveUserToLocalStorage();

    _authCubit.register(
      name: _name,
      email: _email,
      password: _password,
    );
  }

  void _handleLoginLinkClick() {
    widget.onToggleScreen?.call();
    _saveUserToLocalStorage();
  }

  void _saveUserToLocalStorage() {
    _authCubit.saveUserToLocalStorage(
      storageKey: HiveKeys.signUpDataKey,
      user: AppUserModel.createWith(name: _name, email: _email),
    );
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
      style: AppStyles.textHeadingSecondary.copyWith(
        color: AppColors.white100,
        fontSize: AppDimens.fontSizeXXL24,
      ),
    );
  }

  Widget _buildNameTextField() {
    return TextFieldUnit(
      controller: _nameController,
      hintText: AppStrings.hintUsername,
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.next,
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
      textInputAction: TextInputAction.next,
      passwordValidator: _validateMainPassword,
    );
  }

  Widget _buildConfirmPasswordTextField() {
    return PasswordFieldUnit(
      passwordTextController: _confirmPasswordController,
      hintText: AppStrings.hintConfirmPassword,
      textInputAction: TextInputAction.done,
      passwordValidator: _validateConfirmPassword,
    );
  }

  Widget _buildSignUpButton() {
    return GradientButton(
      text: AppStrings.signUp.toUpperCase(),
      onPressed: _handleSignUp,
      icon: const Icon(
        Icons.arrow_forward_ios_sharp,
        color: AppColors.whiteLight,
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
          Text(
            AppStrings.alreadyAMember,
            style: AppStyles.subtitleSecondary.copyWith(
              color: Theme.of(context).colorScheme.onTertiary,
              fontWeight: FontWeight.w600,
              letterSpacing: AppDimens.letterSpacingPT07,
              shadows: AppStyles.shadowStyle2,
            ),
          ),
          addSpacing(width: AppDimens.size8),
          GestureDetector(
            onTap: _handleLoginLinkClick,
            child: Text(
              AppStrings.loginNow,
              style: AppStyles.subtitlePrimary.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                shadows: AppStyles.shadowStyleEmpty,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
