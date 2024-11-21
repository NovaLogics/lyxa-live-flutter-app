import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/utils/constants/constants.dart';
import 'package:lyxa_live/src/core/values/app_colors.dart';
import 'package:lyxa_live/src/core/values/app_dimensions.dart';

class AppTextStyles {
  /// Headings
  /// ->
  static const TextStyle headingPrimary = TextStyle(
    color: AppColors.whiteShade50,
    fontSize: AppDimens.fontSizeTitleLg42,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    fontFamily: FONT_DYNALIGHT,
    shadows: shadowStyle1,
  );

  static const TextStyle headingSecondary = TextStyle(
    color: AppColors.blueGreyShade50,
    fontSize: AppDimens.fontSizeLg18,
    fontFamily: FONT_RALEWAY,
    shadows: shadowStyle1,
  );

  /// Subtitles
  /// ->
  static const TextStyle subtitlePrimary = TextStyle(
    color: AppColors.blueGreyShade50,
    fontSize: AppDimens.fontSizeLg18,
    fontFamily: FONT_RALEWAY,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.7,
    shadows: shadowStyle1,
  );

  static const TextStyle subtitleSecondary = TextStyle(
    color: AppColors.blueGreyShade50,
    fontSize: AppDimens.fontSizeMd16,
    fontFamily: FONT_RALEWAY,
    shadows: shadowStyle1,
  );

  static const TextStyle textStylePost = TextStyle(
    color: AppColors.blueGreyShade50,
    fontSize: AppDimens.fontSizeRg14,
    fontWeight: FontWeight.w600,
    fontFamily: FONT_RALEWAY,
  );

  static const TextStyle textStylePostWithNumbers = TextStyle(
    color: AppColors.blueGreyShade50,
    fontSize: AppDimens.fontSizeRg14,
    fontWeight: FontWeight.w600,
    fontFamily: FONT_MONTSERRAT,
    letterSpacing: 0.5,
  );

  /// Button Text
  /// ->
  static const TextStyle buttonTextPrimary = TextStyle(
    color: AppColors.blueGreyShade50,
    fontWeight: FontWeight.bold,
    fontSize: AppDimens.fontSizeMd16,
    fontFamily: FONT_RALEWAY,
  );

  /// Shadows
  /// ->
  static const List<Shadow> shadowStyle1 = [
    Shadow(
      offset: Offset(1, 1),
      blurRadius: 1.0,
      color: Colors.black,
    ),
  ];

  static const List<Shadow> shadowStyle2 = [
    Shadow(
      offset: Offset(0.5, 0.5),
      blurRadius: 1,
      color: Colors.white30,
    ),
  ];
}
