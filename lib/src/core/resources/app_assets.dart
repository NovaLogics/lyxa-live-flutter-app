// ignore_for_file: constant_identifier_names

class AppAssets {
  const AppAssets._();

  static const Icons = _AppIcons();
  static const Images = _AppImages();
  static const Fonts = _AppFonts();
}

class _AppIcons {
  const _AppIcons();
  static const String _iconPath = 'assets/icons';

  final String likeHeartSolid = '$_iconPath/ic_heart_filled.svg';
  final String likeHeartOutlined = '$_iconPath/ic_heart_border.svg';

  final String commentSolid = '$_iconPath/ic_comment_filled.svg';
  final String commentOutlined = '$_iconPath/ic_comment_border.svg';

  final String settingsOutlinedStl1 = '$_iconPath/ic_settings_style_1.svg';
  final String settingsOutlinedStl2 = '$_iconPath/ic_settings_border.svg';

  final String homeOutlined = '$_iconPath/ic_home_border.svg';
  final String profileOutlined = '$_iconPath/ic_profile_border.svg';
  final String searchOutlined = '$_iconPath/ic_search_border.svg';
  final String logoutOutlined = '$_iconPath/ic_logout_border.svg';
}

class _AppImages {
  const _AppImages();
  static const String _imagePath = 'assets/images';

  final String logoMainLyxa = '$_imagePath/lyxa_banner.png';
}

class _AppFonts {
  const _AppFonts();
  final String raleway = 'Raleway';
  final String dynalight = 'Dynalight';
  final String montserrat = 'Montserrat';
}
