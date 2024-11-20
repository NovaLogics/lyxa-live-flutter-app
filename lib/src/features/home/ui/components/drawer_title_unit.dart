import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/styles/app_text_styles.dart';

class DrawerTitleUnit extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  const DrawerTitleUnit({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      title: Text(
        title,
        style: AppTextStyles.subtitlePrimary.copyWith(
          color: Theme.of(context).colorScheme.inversePrimary,
          letterSpacing: 1.4,
          shadows: [],
        ),
      ),
      leading: Icon(
        icon,
        color: theme.colorScheme.onPrimary,
      ),
      onTap: onTap,
    );
  }
}
