import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/values/app_colors.dart';

ThemeData darkMode = ThemeData(
  colorScheme: darkColorScheme,
);

const Color bluePurpleShade50 = Color.fromARGB(255, 247, 248, 254);
const Color bluePurpleShade100 = Color(0xFFC5CAE9);
const Color bluePurpleShade200 = Color(0xFF9FA8DA);
const Color bluePurpleShade300 = Color(0xFF7986CB);
const Color bluePurpleShade400 = Color(0xFF5C6BC0);
const Color bluePurpleShade500 = Color(0xFF3F51B5);
const Color bluePurpleShade600 = Color(0xFF3949AB);
const Color bluePurpleShade700 = Color(0xFF303F9F);
const Color bluePurpleShade800 = Color(0xFF283593);
const Color bluePurpleShade900 = Color(0xFF1A237E);

const ColorScheme darkColorScheme = ColorScheme.dark(
  brightness: Brightness.dark,
  // Primary color for main actions
  primary: bluePurpleShade600,
  // Text/Icon color on primary
  onPrimary: bluePurpleShade400,
  // Darker shade of primary
  primaryContainer: Color(0xFF512DA8),
  // Text/Icon color on primary container
  onPrimaryContainer: bluePurpleShade50,
  // Secondary color for accents
  secondary: AppColors.deepPurpleShade600,
  // Text/Icon color on secondary
  onSecondary: bluePurpleShade200,
  //text/Icon color on secondary container
  secondaryContainer: Color(0xFF673AB7),

  onTertiary: bluePurpleShade400,
  // Error color
  error: Colors.red,
  // Text/Icon color on error
  onError: Colors.black,
  // Card backgrounds, Dialogs
  surface: Color(0xFF121212),
  // Text/Icon color on background
  onSurface: Colors.white,
  // Borders and outlines
  outline: Color(0xFF616161),
  // Shadows for cards, modals, etc.
  shadow: Colors.black45,
  // Used for lighter text background in dark mode
  inverseSurface: Color(0xFFE0E0E0),
  // Text/Icon on inverse surface
  onInverseSurface: Colors.black,
  // Tint for elevated surfaces
  surfaceTint: Colors.purple,

  inversePrimary: bluePurpleShade50,

  surfaceContainer: AppColors.blueGreyShade900X,

  surfaceContainerLowest: AppColors.deepPurpleShade500,
  surfaceContainerLow: AppColors.deepPurpleShade700,
  surfaceContainerHigh: AppColors.blueGreyShade900Y,
  surfaceContainerHighest: AppColors.blueGreyShade900X,
);
