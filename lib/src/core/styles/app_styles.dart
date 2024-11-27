import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/constants/constants.dart';
import 'package:lyxa_live/src/core/resources/app_colors.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/resources/app_fonts.dart';

class AppStyles {
  /// Headings
  /// ->
  static const TextStyle headingPrimary = TextStyle(
    color: AppColors.whitePure,
    fontSize: AppDimens.fontSizeXXL42,
    fontWeight: FontWeight.w500,
    letterSpacing: AppDimens.letterSpacingPT01,
    fontFamily: AppFonts.dynalight,
    shadows: shadowStyle1,
  );

  static const TextStyle headingSecondary = TextStyle(
    color: AppColors.blueGrey50,
    fontSize: AppDimens.fontSizeLG18,
    fontFamily: AppFonts.raleway,
    shadows: shadowStyle1,
  );

  /// Subtitles
  /// ->
  static const TextStyle titlePrimary = TextStyle(
    color: AppColors.blueGrey50,
    fontSize: AppDimens.fontSizeXL20,
    fontFamily: AppFonts.raleway,
    fontWeight: FontWeight.w600,
    letterSpacing: AppDimens.letterSpacingPT10,
  );

  /// Subtitles
  /// ->
  static const TextStyle subtitlePrimary = TextStyle(
    color: AppColors.blueGrey50,
    fontSize: AppDimens.fontSizeLG18,
    fontFamily: FONT_RALEWAY,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.7,
    shadows: shadowStyle1,
  );

  static const TextStyle subtitleSecondary = TextStyle(
    color: AppColors.blueGrey50,
    fontSize: AppDimens.fontSizeMD16,
    fontFamily: FONT_RALEWAY,
    shadows: shadowStyle1,
  );

  static const TextStyle textStylePost = TextStyle(
    color: AppColors.blueGrey50,
    fontSize: AppDimens.fontSizeRG14,
    fontWeight: FontWeight.w600,
    fontFamily: FONT_RALEWAY,
  );

  static const TextStyle textStylePostWithNumbers = TextStyle(
    color: AppColors.blueGrey50,
    fontSize: AppDimens.fontSizeRG14,
    fontWeight: FontWeight.w600,
    fontFamily: FONT_MONTSERRAT,
    letterSpacing: 0.5,
  );

  /// Button Text
  /// ->
  static const TextStyle buttonTextPrimary = TextStyle(
    color: AppColors.blueGrey50,
    fontWeight: FontWeight.bold,
    fontSize: AppDimens.fontSizeMD16,
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

  static const List<Shadow> shadowStyleEmpty = [];
}
