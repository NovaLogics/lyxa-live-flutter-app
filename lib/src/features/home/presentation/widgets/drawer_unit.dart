import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/constants/assets/app_fonts.dart';
import 'package:lyxa_live/src/core/dependency_injection/service_locator.dart';
import 'package:lyxa_live/src/core/constants/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/constants/assets/app_icons.dart';
import 'package:lyxa_live/src/core/constants/assets/app_images.dart';
import 'package:lyxa_live/src/core/constants/resources/app_strings.dart';
import 'package:lyxa_live/src/core/constants/styles/app_styles.dart';
import 'package:lyxa_live/src/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:lyxa_live/src/features/home/presentation/widgets/drawer_title_unit.dart';
import 'package:lyxa_live/src/features/profile/domain/entities/profile_user_entity.dart';
import 'package:lyxa_live/src/features/profile/presentation/screens/profile_screen.dart';
import 'package:lyxa_live/src/features/search/ui/screens/search_screen.dart';
import 'package:lyxa_live/src/features/settings/ui/screens/settings_screen.dart';
import 'package:lyxa_live/src/shared/widgets/spacers_unit.dart';

class DrawerUnit extends StatelessWidget {
  final ProfileUserEntity user;

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
                addSpacing(height: AppDimens.size4),
                _buildHeadingText(context),
                addSpacing(height: AppDimens.size4),
                _addDivider(context, isShortDivider: true),
                addSpacing(height: AppDimens.size8),
                DrawerTitleUnit(
                  title: AppStrings.titleHome,
                  iconMobile: AppIcons.homeOutlined,
                  iconWeb: Icons.home_rounded,
                  onTap: () => Navigator.of(context).pop(),
                ),
                DrawerTitleUnit(
                  title: AppStrings.titleProfile,
                  iconMobile: AppIcons.profileOutlined,
                  iconWeb: Icons.person_rounded,
                  onTap: () => _navigateToProfileScreen(context, user.uid),
                ),
                DrawerTitleUnit(
                  title: AppStrings.titleSearch,
                  iconMobile: AppIcons.searchOutlined,
                  iconWeb: Icons.search_rounded,
                  onTap: () => _navigateToSearchScreen(context),
                ),
                DrawerTitleUnit(
                  title: AppStrings.titleSettings,
                  iconMobile: AppIcons.settingsOutlinedStyle2,
                  iconWeb: Icons.settings_rounded,
                  onTap: () => _navigateToSettingsScreen(context),
                ),
                addSpacing(height: AppDimens.size20),
                _addDivider(context, isShortDivider: true),
                DrawerTitleUnit(
                  title: AppStrings.titleLogout,
                  iconMobile: AppIcons.logoutOutlined,
                  iconWeb: Icons.power_settings_new_rounded,
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
        letterSpacing: AppDimens.letterSpacingPT03,
        fontSize: AppDimens.fontSizeXXL26,
        fontFamily: AppFonts.elMessiri,
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
