import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/di/service_locator.dart';
import 'package:lyxa_live/src/core/styles/app_styles.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/resources/app_strings.dart';
import 'package:lyxa_live/src/shared/widgets/responsive/constrained_scaffold.dart';
import 'package:lyxa_live/src/core/themes/cubits/theme_cubit.dart';
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
            AppStrings.settings,
            style: AppStyles.textAppBarStatic.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
        actions: [
          addSpacing(width: AppDimens.iconSizeLG48),
        ]);
  }

  Widget _buildSettingsBody(BuildContext context) {
    final ThemeCubit themeCubit = getIt<ThemeCubit>();
    final bool isDarkModeEnabled = themeCubit.isDarkMode;

    return Column(
      children: [
        addSpacing(height: AppDimens.size12),
        _buildDarkModeSwitch(context, themeCubit, isDarkModeEnabled),
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
        ),
      ),
      trailing: CupertinoSwitch(
        value: isDarkModeEnabled,
        onChanged: (value) {
          themeCubit.toggleTheme();
        },
      ),
    );
  }
}
