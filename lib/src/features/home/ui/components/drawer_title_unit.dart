import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lyxa_live/src/core/styles/app_styles.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';

class DrawerTitleUnit extends StatelessWidget {
  final String title;
  final String iconSrc;
  final VoidCallback? onTap;

  const DrawerTitleUnit({
    super.key,
    required this.title,
    required this.iconSrc,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: _buildTitle(context, title),
      leading: _buildLeadingIcon(context, iconSrc),
      onTap: onTap,
    );
  }
}

Widget _buildTitle(BuildContext context, String title) {
  return Text(
    title,
    style: AppStyles.titleSecondary.copyWith(
      color: Theme.of(context).colorScheme.onSecondary,
    ),
  );
}

Widget _buildLeadingIcon(BuildContext context, String iconPath) {
  return SvgPicture.asset(
    iconPath,
    colorFilter: ColorFilter.mode(
      Theme.of(context).colorScheme.onSecondary,
      BlendMode.srcIn,
    ),
    width: AppDimens.size24,
    height: AppDimens.size24,
  );
}
