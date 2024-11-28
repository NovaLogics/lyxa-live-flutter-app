import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/di/service_locator.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/assets/app_icons.dart';
import 'package:lyxa_live/src/core/resources/app_images.dart';
import 'package:lyxa_live/src/core/resources/app_strings.dart';
import 'package:lyxa_live/src/core/styles/app_styles.dart';
import 'package:lyxa_live/src/features/auth/cubits/auth_cubit.dart';
import 'package:lyxa_live/src/features/home/ui/components/drawer_title_unit.dart';
import 'package:lyxa_live/src/features/profile/domain/entities/profile_user.dart';
import 'package:lyxa_live/src/features/profile/ui/screens/profile_screen.dart';
import 'package:lyxa_live/src/features/search/ui/screens/search_screen.dart';
import 'package:lyxa_live/src/features/settings/ui/screens/settings_screen.dart';
import 'package:lyxa_live/src/shared/widgets/spacers_unit.dart';

class DrawerUnit extends StatelessWidget {
  final ProfileUser user;

  const DrawerUnit({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.size24),
            child: Column(
              children: [
                addSpacing(height: AppDimens.size12),
                _buildDrawerIcon(context),
                addSpacing(height: AppDimens.size8),
                _addDivider(context, isShortDivider: false),
                addSpacing(height: AppDimens.size8),
                _buildHeadingText(context),
                addSpacing(height: AppDimens.size8),
                _addDivider(context, isShortDivider: true),
                addSpacing(height: AppDimens.size8),
                DrawerTitleUnit(
                  title: AppStrings.titleHome,
                  iconMobile: AppIcons.homeOutlined,
                  iconWeb: Icons.home_outlined,
                  onTap: () => Navigator.of(context).pop(),
                ),
                DrawerTitleUnit(
                  title: AppStrings.titleProfile,
                  iconMobile: AppIcons.profileOutlined,
                  iconWeb: Icons.person_outline,
                  onTap: () => _navigateToProfileScreen(context, user.uid),
                ),
                DrawerTitleUnit(
                  title: AppStrings.titleSearch,
                  iconMobile: AppIcons.searchOutlined,
                  iconWeb: Icons.search_outlined,
                  onTap: () => _navigateToSearchScreen(context),
                ),
                DrawerTitleUnit(
                  title: AppStrings.titleSettings,
                  iconMobile: AppIcons.settingsOutlinedStl2,
                  iconWeb: Icons.settings_outlined,
                  onTap: () => _navigateToSettingsScreen(context),
                ),
                addSpacing(height: AppDimens.size20),
                _addDivider(context, isShortDivider: true),
                DrawerTitleUnit(
                  title: AppStrings.titleLogout,
                  iconMobile: AppIcons.logoutOutlined,
                  iconWeb: Icons.login,
                  onTap: () => _openLogoutDialog(context),
                ),
                _addDivider(context, isShortDivider: false),
                addSpacing(height: AppDimens.size12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _addDivider(BuildContext context, {required bool isShortDivider}) {
    final padding = (isShortDivider ? AppDimens.size80 : 0.0);
    return Padding(
      padding: EdgeInsets.only(right: padding),
      child:
          Divider(thickness: 0.5, color: Theme.of(context).colorScheme.primary),
    );
  }

  Widget _buildDrawerIcon(BuildContext context) {
    return Image.asset(
      AppImages.logoMainLyxa,
      height: AppDimens.iconSizeXXL128,
      width: AppDimens.iconSizeXXL128,
      fit: BoxFit.cover,
    );
  }

  Widget _buildHeadingText(BuildContext context) {
    return Text(
      user.name,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: AppStyles.titlePrimary.copyWith(
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }

  void _navigateToSearchScreen(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchScreen()),
    );
  }

  void _navigateToSettingsScreen(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  void _navigateToProfileScreen(BuildContext context, String uid) {
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(displayUserId: uid),
      ),
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
              Navigator.of(context, rootNavigator: true).pop();
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
