import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/values/app_dimensions.dart';
import 'package:lyxa_live/src/core/values/app_strings.dart';
import 'package:lyxa_live/src/features/auth/cubits/auth_cubit.dart';
import 'package:lyxa_live/src/features/home/ui/components/drawer_title_unit.dart';
import 'package:lyxa_live/src/features/profile/ui/screens/profile_screen.dart';
import 'package:lyxa_live/src/features/search/ui/screens/search_screen.dart';
import 'package:lyxa_live/src/features/settings/presentation/screens/settings_screen.dart';

class DrawerUnit extends StatelessWidget {
  const DrawerUnit({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          children: [
            _drawerIcon(context),
            Divider(
              color: Theme.of(context).colorScheme.secondary,
            ),
            DrawerTitleUnit(
              title: AppStrings.titleHome,
              icon: Icons.home,
              onTap: () => Navigator.of(context).pop(),
            ),
            _profileSection(context),
            DrawerTitleUnit(
              title: AppStrings.titleSearch,
              icon: Icons.search,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ),
              ),
            ),
            DrawerTitleUnit(
              title: AppStrings.titleSettings,
              icon: Icons.settings,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              ),
            ),
            const Spacer(),
            DrawerTitleUnit(
              title: AppStrings.titleLogout,
              icon: Icons.login,
              onTap: () => context.read<AuthCubit>().logout(),
            ),
          ],
        ),
      )),
    );
  }

  Widget _drawerIcon(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: Icon(
        Icons.person,
        size: AppDimens.size72,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _profileSection(BuildContext context) {
    final user = context.read<AuthCubit>().currentUser;
    String? uid = user!.uid;

    return DrawerTitleUnit(
      title: AppStrings.titleProfile,
      icon: Icons.person,
      onTap: () {
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(
              uid: uid,
            ),
          ),
        );
      },
    );
  }
}
