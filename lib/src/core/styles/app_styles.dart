import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/resources/app_colors.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/assets/app_fonts.dart';

class AppStyles {
  const AppStyles._();

  /// [1] TEXT ▼

  // Headings
  // ->
  static const TextStyle textHeadingPrimary = TextStyle(
    color: AppColors.whitePure,
    fontSize: AppDimens.fontSizeXXL42,
    fontWeight: FontWeight.w500,
    letterSpacing: AppDimens.letterSpacingPT01,
    fontFamily: AppFonts.dynalight,
    shadows: shadowStyle1,
  );

  static const TextStyle textHeadingSecondary = TextStyle(
    color: AppColors.blueGrey50,
    fontSize: AppDimens.fontSizeLG18,
    fontFamily: AppFonts.raleway,
    shadows: shadowStyle1,
  );

  /// Titles
  /// ->
  static const TextStyle titlePrimary = TextStyle(
    color: AppColors.blueGrey50,
    fontSize: AppDimens.fontSizeXL20,
    fontFamily: AppFonts.raleway,
    fontWeight: FontWeight.w600,
    letterSpacing: AppDimens.letterSpacingPT10,
  );

  static const TextStyle titleSecondary = TextStyle(
    color: AppColors.blueGrey50,
    fontSize: AppDimens.fontSizeLG18,
    fontFamily: AppFonts.raleway,
    fontWeight: FontWeight.w600,
    letterSpacing: AppDimens.letterSpacingPT13,
  );

  /// Subtitles
  /// ->
  static const TextStyle subtitlePrimary = TextStyle(
    color: AppColors.blueGrey50,
    fontSize: AppDimens.fontSizeLG18,
    fontFamily: AppFonts.raleway,
    fontWeight: FontWeight.bold,
    letterSpacing: AppDimens.letterSpacingPT07,
    shadows: shadowStyle1,
  );

  static const TextStyle subtitleRegular = TextStyle(
    color: AppColors.blueGrey50,
    fontSize: AppDimens.fontSizeLG18,
    fontFamily: AppFonts.montserrat,
    fontWeight: FontWeight.normal,
    letterSpacing: AppDimens.letterSpacingPT07,
    shadows: AppStyles.shadowStyle2,
  );

  static const TextStyle subtitleSecondary = TextStyle(
    color: AppColors.blueGrey50,
    fontSize: AppDimens.fontSizeMD16,
    fontFamily: AppFonts.raleway,
    shadows: shadowStyle1,
  );

  /// Label Text
  /// ->
  static const TextStyle labelPrimary = TextStyle(
    color: AppColors.blueGrey50,
    letterSpacing: AppDimens.letterSpacingPT07,
    fontWeight: FontWeight.bold,
    fontFamily: AppFonts.montserrat,
    fontSize: AppDimens.fontSizeSM12,
    shadows: AppStyles.shadowStyle2,
  );

  /// Custom Text Styles
  /// ->
  static const TextStyle textTitlePost = TextStyle(
    color: AppColors.blueGrey50,
    fontSize: AppDimens.fontSizeRG14,
    fontWeight: FontWeight.w600,
    fontFamily: AppFonts.montserrat,
  );

  static const TextStyle textSubtitlePost = TextStyle(
    color: AppColors.blueGrey50,
    fontSize: AppDimens.fontSizeSM12,
    letterSpacing: AppDimens.letterSpacingPT03,
    fontWeight: FontWeight.bold,
    fontFamily: AppFonts.montserrat,
  );

  static const TextStyle textNumberStyle1 = TextStyle(
    color: AppColors.blueGrey50,
    fontSize: AppDimens.fontSizeMD16,
    fontWeight: FontWeight.bold,
    fontFamily: AppFonts.montserrat,
    letterSpacing: AppDimens.letterSpacingPT05,
  );

  static const TextStyle textNumberStyle2 = TextStyle(
    color: AppColors.blueGrey50,
    fontSize: AppDimens.fontSizeRG14,
    fontWeight: FontWeight.w600,
    fontFamily: AppFonts.montserrat,
    letterSpacing: AppDimens.letterSpacingPT05,
  );

   static const TextStyle textFieldStyleMain = TextStyle(
    color: AppColors.blueGrey50,
    fontSize: AppDimens.fontSizeMD16,
    fontWeight: FontWeight.w600,
    fontFamily: AppFonts.montserrat,
  );

    static const TextStyle textFieldStyleHint = TextStyle(
    color: AppColors.blueGrey50,
    fontSize: AppDimens.fontSizeMD15,
    fontWeight: FontWeight.normal,
    fontFamily: AppFonts.montserrat,
  );

  /// Button Text
  /// ->
  static const TextStyle buttonTextPrimary = TextStyle(
    color: AppColors.whitePure,
    fontWeight: FontWeight.bold,
    fontSize: AppDimens.fontSizeMD16,
    fontFamily: AppFonts.raleway,
    letterSpacing: AppDimens.letterSpacingPT09,
    shadows: AppStyles.shadowStyle2,
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
      color: AppColors.black500,
    ),
  ];

  static const List<Shadow> shadowStyleEmpty = [];
}
