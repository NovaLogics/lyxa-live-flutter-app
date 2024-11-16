import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: lightColorScheme,
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
const Color bluePurpleShade900X = Color.fromARGB(255, 12, 17, 65);

const ColorScheme lightColorScheme = ColorScheme.light(
  brightness: Brightness.light,
  // Primary color for main actions
  primary: bluePurpleShade500,
  // Text/Icon color on primary
  onPrimary: bluePurpleShade900X,
  // Darker shade of primary
  primaryContainer: Color(0xFFD1C4E9),
  // Text/Icon color on primary container
  onPrimaryContainer: Color(0xFF311B92),
  // Secondary color for accents
  secondary: Color(0xFF512DA8),
  // Text/Icon color on secondary
  onSecondary: bluePurpleShade900,
  // Secondary container background
  secondaryContainer: Color(0xFFEDE7F6),
  // Text/Icon color on secondary container
  onSecondaryContainer: Color(0xFF311B92),
  // Error color
  error: Colors.red,
  // Text/Icon color on error
  onError: Colors.white,
  // Card backgrounds, Dialogs
  surface: Colors.white,
  // Text/Icon color on background
  onSurface: Colors.black,
  // Borders and outlines
  outline: Color(0xFFBDBDBD),
  // Shadows for cards, modals, etc.
  shadow: Colors.black26,
  // Used for darker text background in light mode
  inverseSurface: Color(0xFF303030),
  // Text/Icon on inverse surface
  onInverseSurface: Colors.white,
  // Tint for elevated surfaces
  surfaceTint: Color(0xFF673AB7),
);


// const ColorScheme oldTheme = ColorScheme.light(
//     surface: Colors.grey.shade300,
//     primary: Colors.grey.shade500,
//     secondary: Colors.grey.shade200,
//     tertiary: Colors.grey.shade100,
//     inversePrimary: Colors.grey.shade900,
//     surfaceContainerLow: const Color.fromARGB(175, 238, 238, 238),
//   );