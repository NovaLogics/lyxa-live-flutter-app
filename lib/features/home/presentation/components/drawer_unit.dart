import 'package:flutter/material.dart';
import 'package:lyxa_live/constants/app_dimensions.dart';
import 'package:lyxa_live/constants/app_strings.dart';
import 'package:lyxa_live/features/home/presentation/components/drawer_title_unit.dart';

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
            DrawerTitleUnit(
              title: AppStrings.titleProfile,
              icon: Icons.person,
              onTap: () {
                Navigator.of(context).pop();
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => ProfileScreen(),
                //   ),
                // );
              },
            ),
            DrawerTitleUnit(
              title: AppStrings.titleSearch,
              icon: Icons.search,
              onTap: () {},
            ),
            DrawerTitleUnit(
              title: AppStrings.titleSettings,
              icon: Icons.settings,
              onTap: () {},
            ),
            const Spacer(),
            DrawerTitleUnit(
              title: AppStrings.titleLogout,
              icon: Icons.login,
              onTap: () {},
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
}
