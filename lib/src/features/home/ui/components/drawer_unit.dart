import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/values/app_dimensions.dart';
import 'package:lyxa_live/src/core/values/app_strings.dart';
import 'package:lyxa_live/src/features/auth/cubits/auth_cubit.dart';
import 'package:lyxa_live/src/features/home/ui/components/drawer_title_unit.dart';
import 'package:lyxa_live/src/features/profile/ui/screens/profile_screen.dart';
import 'package:lyxa_live/src/features/search/ui/screens/search_screen.dart';
import 'package:lyxa_live/src/features/settings/ui/screens/settings_screen.dart';

class DrawerUnit extends StatelessWidget {
  const DrawerUnit({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.size24),
          child: Column(
            children: [
              _buildDrawerIcon(context),
              const Divider(),
              _buildDrawerItem(
                context,
                title: AppStrings.titleHome,
                icon: Icons.home,
                onTap: () => Navigator.of(context).pop(),
              ),
              _buildProfileSection(context),
              _buildDrawerItem(
                context,
                title: AppStrings.titleSearch,
                icon: Icons.search,
                onTap: () => _navigateToSearchScreen(context),
              ),
              _buildDrawerItem(
                context,
                title: AppStrings.titleSettings,
                icon: Icons.settings,
                onTap: () => _navigateToSettingsScreen(context),
              ),
              const Spacer(),
              _buildDrawerItem(
                context,
                title: AppStrings.titleLogout,
                icon: Icons.login,
                onTap: () => _logout(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerIcon(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.size48),
      child: Icon(
        Icons.person,
        size: AppDimens.size72,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    final user = context.read<AuthCubit>().currentUser;
    final uid = user?.uid;

    return _buildDrawerItem(
      context,
      title: AppStrings.titleProfile,
      icon: Icons.person,
      onTap: () {
        Navigator.of(context).pop();
        if (uid != null) {
          _navigateToProfileScreen(context, uid);
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(uid: uid),
      ),
    );
  }

  void _logout(BuildContext context) {
    context.read<AuthCubit>().logout();
  }
}
