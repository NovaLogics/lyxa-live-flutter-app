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
    this.onTap,
    required this.title,
    required this.iconSrc,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: AppStyles.titleSecondary.copyWith(
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
      leading: SvgPicture.asset(
        iconSrc,
        colorFilter: ColorFilter.mode(
          Theme.of(context).colorScheme.onSecondary,
          BlendMode.srcIn,
        ),
        width: AppDimens.size24,
        height: AppDimens.size24,
      ),
      onTap: onTap,
    );
  }
}
