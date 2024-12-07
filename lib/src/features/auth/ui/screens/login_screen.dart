import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:lyxa_live/src/core/di/service_locator.dart';
import 'package:lyxa_live/src/core/constants/resources/app_colors.dart';
import 'package:lyxa_live/src/core/constants/assets/app_images.dart';
import 'package:lyxa_live/src/core/constants/styles/app_styles.dart';
import 'package:lyxa_live/src/core/services/storage/hive_storage.dart';
import 'package:lyxa_live/src/core/utils/validator.dart';
import 'package:lyxa_live/src/core/constants/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/constants/resources/app_strings.dart';
import 'package:lyxa_live/src/features/auth/data/models/app_user_model.dart';
import 'package:lyxa_live/src/features/auth/ui/components/email_field_unit.dart';
import 'package:lyxa_live/src/features/auth/ui/components/gradient_button.dart';
import 'package:lyxa_live/src/features/auth/ui/components/password_field_unit.dart';
import 'package:lyxa_live/src/features/auth/cubits/auth_cubit.dart';
import 'package:lyxa_live/src/shared/widgets/spacers_unit.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback? onToggleScreen;

  const LoginScreen({
    super.key,
    required this.onToggleScreen,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _loginCredentialsFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late final AuthCubit _authCubit;

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
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingLG24,
      ),
      child: Form(
        key: _loginCredentialsFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            addSpacing(height: AppDimens.size64),
            _buildTopBanner(),
            _buildHeadingText(),
            _buildSubheadingText(),
            addSpacing(height: AppDimens.size24),
            _buildEmailTextField(),
            addSpacing(height: AppDimens.size12),
            _buildPasswordTextField(),
            addSpacing(height: AppDimens.size24),
            _buildLoginButton(),
            addSpacing(
              height: _isWebPlatform ? AppDimens.size36 : AppDimens.size48,
            ),
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
    final savedUser = await _authCubit.getSavedUserOrDefault(
      storageKey: HiveKeys.loginDataKey,
    );
    _emailController.text = savedUser.email;
  }

  void _handleLogin() {
    if (_loginCredentialsFormKey.currentState?.validate() != true) return;

    _saveUserToLocalStorage();

    _authCubit.login(
      email: _email,
      password: _password,
    );
  }

  void _handleSignUpLinkClick() {
    widget.onToggleScreen?.call();
    _saveUserToLocalStorage();
  }

  void _saveUserToLocalStorage() {
    _authCubit.saveUserToLocalStorage(
      storageKey: HiveKeys.loginDataKey,
      user: AppUserModel.createWith(email: _email),
    );
  }

  Widget _buildTopBanner() {
    return Image.asset(
      AppImages.logoMainLyxa,
      height: AppDimens.bannerSize200,
      width: AppDimens.bannerSize200,
      fit: BoxFit.cover,
    );
  }

  Widget _buildHeadingText() {
    return const Text(
      AppStrings.welcomeBack,
      style: AppStyles.textHeadingPrimary,
    );
  }

  Widget _buildSubheadingText() {
    return const Text(
      AppStrings.itsTimeToShareYourStory,
      style: AppStyles.textHeadingSecondary,
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
      onPressed: _handleLogin,
      icon: const Icon(
        Icons.arrow_forward_outlined,
        color: AppColors.whiteLight,
      ),
    );
  }

  Widget _buildRegisterLink() {
    return Padding(
      padding: const EdgeInsets.only(
          bottom: AppDimens.size48, top: AppDimens.size32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppStrings.notAMember,
            style: AppStyles.subtitleSecondary.copyWith(
              color: Theme.of(context).colorScheme.onTertiary,
              fontWeight: FontWeight.w600,
              letterSpacing: AppDimens.letterSpacingPT07,
              shadows: AppStyles.shadowStyle2,
            ),
          ),
          addSpacing(width: AppDimens.size8),
          GestureDetector(
            onTap: _handleSignUpLinkClick,
            child: Text(
              AppStrings.registerNow,
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
