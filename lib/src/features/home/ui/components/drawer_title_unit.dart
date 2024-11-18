import 'package:flutter/material.dart';

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
        style: TextStyle(color: theme.colorScheme.inversePrimary),
      ),
      leading: Icon(
        icon,
        color: theme.colorScheme.primary,
      ),
      onTap: onTap,
    );
  }
}

