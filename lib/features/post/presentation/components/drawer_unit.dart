import 'package:flutter/material.dart';
import 'package:lyxa_live/constants/app_dimensions.dart';
import 'package:lyxa_live/features/post/presentation/components/drawer_title_unit.dart';

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Icon(
                Icons.person,
                size: AppDimens.size72,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Divider(
              color: Theme.of(context).colorScheme.secondary,
            ),
            DrawerTitleUnit(
              title: "H O M E",
              icon: Icons.home,
              onTap: () {},
            ),
            DrawerTitleUnit(
              title: "P R O F I L E",
              icon: Icons.person,
              onTap: () {},
            ),
            DrawerTitleUnit(
              title: "P R O F I L E",
              icon: Icons.person,
              onTap: () {},
            ),
            DrawerTitleUnit(
              title: "S E A R C H",
              icon: Icons.search,
              onTap: () {},
            ),
            DrawerTitleUnit(
              title: "S E T T I N G S",
              icon: Icons.settings,
              onTap: () {},
            ),
            DrawerTitleUnit(
              title: "L O G O U T",
              icon: Icons.login,
              onTap: () {},
            ),
          ],
        ),
      )),
    );
  }
}
