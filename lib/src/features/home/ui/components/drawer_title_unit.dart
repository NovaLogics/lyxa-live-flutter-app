import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/styles/app_text_styles.dart';
import 'package:lyxa_live/src/core/constants/constants.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';

class DrawerTitleUnit extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  const DrawerTitleUnit({
    super.key,
    this.onTap,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      title: Text(
        title,
        style: AppTextStyles.subtitlePrimary.copyWith(
          color: Theme.of(context).colorScheme.onSecondary,
          fontSize: AppDimens.fontSizeMD16,
          letterSpacing: AppDimens.letterSpacingPT18,
          fontFamily: FONT_MONTSERRAT,
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
