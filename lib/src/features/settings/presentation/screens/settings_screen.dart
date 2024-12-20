import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/constants/assets/app_fonts.dart';
import 'package:lyxa_live/src/core/dependency_injection/service_locator.dart';
import 'package:lyxa_live/src/core/constants/styles/app_styles.dart';
import 'package:lyxa_live/src/core/constants/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/constants/resources/app_strings.dart';
import 'package:lyxa_live/src/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:lyxa_live/src/shared/widgets/responsive/constrained_scaffold.dart';
import 'package:lyxa_live/src/core/themes/theme_cubit.dart';
import 'package:lyxa_live/src/shared/widgets/spacers_unit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
      appBar: _buildAppBar(context),
      body: _buildSettingsBody(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.3),
      title: Center(
        child: Text(
          AppStrings.titleSettings,
          style: AppStyles.textAppBarStatic.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
            letterSpacing: AppDimens.letterSpacingPT10,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.elMessiri,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsBody(BuildContext context) {
    final ThemeCubit themeCubit = getIt<ThemeCubit>();
    final bool isDarkModeEnabled = themeCubit.isDarkMode;

    return Column(
      children: [
        addSpacing(height: AppDimens.size12),
        _buildDarkModeSwitch(context, themeCubit, isDarkModeEnabled),
        addSpacing(height: AppDimens.size12),
        _buildLogout(context),
      ],
    );
  }

  Widget _buildDarkModeSwitch(
      BuildContext context, ThemeCubit themeCubit, bool isDarkModeEnabled) {
    return ListTile(
      title: Text(
        AppStrings.darkMode,
        style: AppStyles.textSubtitlePost.copyWith(
          color: Theme.of(context).colorScheme.inversePrimary,
          fontSize: AppDimens.fontSizeLG18,
          letterSpacing: AppDimens.letterSpacingPT05,
        ),
      ),
      leading: Icon(
        Icons.brightness_6_outlined,
        color: Theme.of(context).colorScheme.onPrimary,
        size: AppDimens.size28,
      ),
      trailing: CupertinoSwitch(
        value: isDarkModeEnabled,
        onChanged: (value) {
          themeCubit.toggleTheme();
        },
      ),
    );
  }

  Widget _buildLogout(BuildContext context) {
    return ListTile(
      title: Text(
        AppStrings.logout,
        style: AppStyles.textSubtitlePost.copyWith(
          color: Theme.of(context).colorScheme.inversePrimary,
          fontSize: AppDimens.fontSizeLG18,
          letterSpacing: AppDimens.letterSpacingPT05,
        ),
      ),
      leading: Icon(
        Icons.power_settings_new_rounded,
        color: Theme.of(context).colorScheme.onPrimary,
        size: AppDimens.size28,
      ),
      onTap: () => _openLogoutDialog(context),
    );
  }

  void _logout() {
    getIt<AuthCubit>().logout();
  }

  void _openLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.inverseSurface,
        title: Text(
          AppStrings.logoutDialogMsg,
          style:
              TextStyle(color: Theme.of(context).colorScheme.onInverseSurface),
        ),
        actions: [
          // CANCEL BUTTON
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop(AppStrings.dialog);
              // Navigator.of(context, rootNavigator: true).pop();
            },
            child: Text(
              AppStrings.cancel,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onInverseSurface),
            ),
          ),
          // SAVE/SUBMIT BUTTON
          TextButton(
            onPressed: () {
              _logout();
              Navigator.of(context).pop();
            },
            child: Text(
              AppStrings.yesLogout,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
