import 'package:flutter/material.dart';
import 'package:lyxa_live/constants/app_dimensions.dart';
import 'package:lyxa_live/features/auth/presentation/components/spacer_unit.dart';
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
            const SpacerUnit(height: AppDimens.size52),
            Icon(
              Icons.person,
              size: AppDimens.size72,
              color: Theme.of(context).colorScheme.primary,
            ),
            DrawerTitleUnit(
              title: "H O M E",
              icon: Icons.home,
              onTap: () {},
            )
                    ],
                  ),
          )),
    );
  }
}
