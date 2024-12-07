import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:lyxa_live/src/core/constants/assets/app_fonts.dart';
import 'package:lyxa_live/src/core/styles/app_styles.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';

class DrawerTitleUnit extends StatelessWidget {
  final String title;
  final String iconMobile;
  final IconData iconWeb;
  final VoidCallback? onTap;

  const DrawerTitleUnit({
    super.key,
    required this.title,
    required this.iconMobile,
    required this.iconWeb,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSecondary;
    return ListTile(
      title: _buildTitle(color, title),
      leading: _buildLeadingIcon(color, iconMobile, iconWeb),
      onTap: onTap,
    );
  }
}

Widget _buildTitle(Color color, String title) {
  return Text(
    title,
    style: AppStyles.titleSecondary.copyWith(
      fontFamily: AppFonts.anta,
      fontWeight: FontWeight.normal,
      letterSpacing: AppDimens.letterSpacingPT15,
      color: color,
    ),
  );
}

Widget _buildLeadingIcon(
  Color color,
  String iconMobile,
  IconData iconWeb,
) {
  return kIsWeb
      ? Icon(
          iconWeb,
          color: color,
        )
      : SvgPicture.asset(
          iconMobile,
          colorFilter: ColorFilter.mode(
            color,
            BlendMode.srcIn,
          ),
          width: AppDimens.size24,
          height: AppDimens.size24,
        );
}
