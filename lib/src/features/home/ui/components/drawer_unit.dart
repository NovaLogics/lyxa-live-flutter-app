import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/constants/constants.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/resources/app_strings.dart';
import 'package:lyxa_live/src/core/styles/app_text_styles.dart';
import 'package:lyxa_live/src/features/auth/cubits/auth_cubit.dart';
import 'package:lyxa_live/src/features/home/ui/components/drawer_title_unit.dart';
import 'package:lyxa_live/src/features/profile/domain/entities/profile_user.dart';
import 'package:lyxa_live/src/features/profile/ui/screens/profile_screen.dart';
import 'package:lyxa_live/src/features/search/ui/screens/search_screen.dart';
import 'package:lyxa_live/src/features/settings/ui/screens/settings_screen.dart';

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
                const SizedBox(height: AppDimens.size12),
                _buildDrawerIcon(context),
                const SizedBox(height: AppDimens.size12),
                _buildHeadingText(context),
                const SizedBox(height: AppDimens.size12),
                Divider(
                    thickness: 0.5,
                    color: Theme.of(context).colorScheme.outline),
                _buildDrawerItem(
                  context,
                  title: AppStrings.titleHome,
                  iconSrc: ICON_HOME_BORDER,
                  onTap: () => Navigator.of(context).pop(),
                ),
                _buildProfileSection(context),
                _buildDrawerItem(
                  context,
                  title: AppStrings.titleSearch,
                  iconSrc: ICON_SEARCH_BORDER,
                  onTap: () => _navigateToSearchScreen(context),
                ),
                _buildDrawerItem(
                  context,
                  title: AppStrings.titleSettings,
                  iconSrc: ICON_SETTINGS_BORDER,
                  onTap: () => _navigateToSettingsScreen(context),
                ),
                const SizedBox(height: AppDimens.size48),
                Divider(
                    thickness: 0.5,
                    color: Theme.of(context).colorScheme.outline),
                _buildDrawerItem(
                  context,
                  title: AppStrings.titleLogout,
                  iconSrc: ICON_LOGOUT_BORDER,
                  onTap: () => _logout(context),
                ),
                const SizedBox(height: AppDimens.size12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerIcon(BuildContext context) {
    return Image.asset(
      IMAGE_LYXA_BANNER,
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
      style: AppTextStyles.headingSecondary.copyWith(
        color: Theme.of(context).colorScheme.onSecondary,
        fontSize: AppDimens.fontSizeXL20,
        fontWeight: FontWeight.bold,
        letterSpacing: AppDimens.letterSpacingPT10,
        shadows: [],
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return _buildDrawerItem(
      context,
      title: AppStrings.titleProfile,
      iconSrc: ICON_PROFILE_BORDER,
      onTap: () => _navigateToProfileScreen(context, user.uid),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required String title,
    required String iconSrc,
    required VoidCallback onTap,
  }) {
    return DrawerTitleUnit(
      title: title,
      iconSrc: iconSrc,
      onTap: onTap,
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

  void _logout(BuildContext context) {
    context.read<AuthCubit>().logout();
  }
}
