import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/constants/constants.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/resources/app_strings.dart';
import 'package:lyxa_live/src/features/auth/cubits/auth_cubit.dart';
import 'package:lyxa_live/src/features/home/ui/components/drawer_title_unit.dart';
import 'package:lyxa_live/src/features/profile/domain/entities/profile_user.dart';
import 'package:lyxa_live/src/features/profile/ui/screens/profile_screen.dart';
import 'package:lyxa_live/src/features/search/ui/screens/search_screen.dart';
import 'package:lyxa_live/src/features/settings/ui/screens/settings_screen.dart';

class DrawerUnit extends StatelessWidget {
  final ProfileUser? user;

  const DrawerUnit({
    super.key,
    this.user,
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
                Divider(color: Theme.of(context).colorScheme.outline),
                _buildDrawerItem(
                  context,
                  title: AppStrings.titleHome,
                  icon: Icons.home_outlined,
                  onTap: () => Navigator.of(context).pop(),
                ),
                _buildProfileSection(context),
                _buildDrawerItem(
                  context,
                  title: AppStrings.titleSearch,
                  icon: Icons.search_outlined,
                  onTap: () => _navigateToSearchScreen(context),
                ),
                _buildDrawerItem(
                  context,
                  title: AppStrings.titleSettings,
                  icon: Icons.settings_outlined,
                  onTap: () => _navigateToSettingsScreen(context),
                ),
                const SizedBox(height: AppDimens.size48),
                Divider(color: Theme.of(context).colorScheme.outline),
                _buildDrawerItem(
                  context,
                  title: AppStrings.titleLogout,
                  icon: Icons.login,
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

  Widget _buildProfileSection(BuildContext context) {
    String? userId;
    if (user?.uid != null) {
      userId = user!.uid;
    } else {
      final userData = context.read<AuthCubit>().currentUser;
      userId = userData!.uid;
    }

    return _buildDrawerItem(
      context,
      title: AppStrings.titleProfile,
      icon: Icons.person_outline,
      onTap: () {
        if (userId != null) {
          _navigateToProfileScreen(context, userId);
        }
      },
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return DrawerTitleUnit(
      title: title,
      icon: icon,
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
