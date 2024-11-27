
// ignore_for_file: constant_identifier_names

class AppAssets {
  const AppAssets._();

 
  
  static const Icons = _AppIcons();

  // BASE RESOURCE PATHS
  static const String imagePath = 'assets/images';
  static const String iconPath = 'assets/icons';

  // IMAGE PATHS
  static const String imageLyxaBanner = '$imagePath/lyxa_banner.png';

  // ICON PATHS
  static const String iconHeartSolid = '$iconPath/ic_heart_filled.svg';
  static const String iconHeartOutlined = '$iconPath/ic_heart_border.svg';

  static const String iconCommentOutlined = '$iconPath/ic_comment_border.svg';
  static const String iconCommentSolid = '$iconPath/ic_comment_filled.svg';

  static const String iconSettingsOutlinedStl1 =
      '$iconPath/ic_settings_style_1.svg';
  static const String iconSettingsOutlinedStl2 =
      '$iconPath/ic_settings_border.svg';

  static const String iconHomeBorder = '$iconPath/ic_home_border.svg';
  static const String iconProfileBorder = '$iconPath/ic_profile_border.svg';
  static const String iconSearchBorder = '$iconPath/ic_search_border.svg';
  static const String iconLogoutBorder = '$iconPath/ic_logout_border.svg';

  // APP FONTS
  static const String fontRaleway = 'Raleway';
  static const String fontDynalight = 'Dynalight';
  static const String fontMontserrat = 'Montserrat';
}

class _AppIcons {
  const _AppIcons();
  static const String _iconPath = 'assets/icons';

  final String likeHeartSolid = '$_iconPath/ic_heart_filled.svg';
  final String likeHeartOutlined = '$_iconPath/ic_heart_border.svg';

  final String commentSolid = '$_iconPath/ic_comment_filled.svg';
  final String commentOutlined = '$_iconPath/ic_comment_border.svg';

  
}
