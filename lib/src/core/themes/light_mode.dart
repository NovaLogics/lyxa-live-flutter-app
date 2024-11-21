import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/values/app_colors.dart';

ThemeData lightMode = ThemeData(
  colorScheme: lightColorScheme,
);

const ColorScheme lightColorScheme = ColorScheme.light(
  brightness: Brightness.light,

  // --- Primary Colors ---
  // Primary color for main actions (used for buttons, primary background)
  primary: AppColors.bluePurple900L2,
  // Text/Icon color on primary 
  onPrimary: AppColors.bluePurple900L1,
  // Lighter shade of primary (used for backgrounds, cards, etc.)
  primaryContainer: AppColors.bluePurple50,
  // Text/Icon color on primary container 
  onPrimaryContainer: Color(0xFF311B92),

  // --- Secondary Colors ---
  // Secondary color for accents 
  secondary: Color(0xFF512DA8),
  // Text/Icon color on secondary 
  onSecondary: AppColors.bluePurple900L2,
  // Secondary container background 
  secondaryContainer: Color(0xFFEDE7F6),
  // Text/Icon color on secondary container 
  onSecondaryContainer: Color(0xFF311B92),

  // --- Tertiary Colors ---
  // Text/Icon color on tertiary (for additional accent elements)
  onTertiary: AppColors.bluePurple900,

  // --- Error Colors ---
  // Error color (used for error states)
  error: Colors.red,
  // Text/Icon color on error 
  onError: Colors.white,

  // --- Surface and Background Colors ---
  // Background color for surfaces like cards, dialogs, etc.
  surface: Colors.white,
  // Text/Icon color on surface 
  onSurface: Colors.black,
  // Borders and outlines color (used for borders or subtle divisions)
  outline: Color(0xFFBDBDBD),
  // Shadows color for cards, modals, etc.
  shadow: Colors.black26,

  // --- Inverse Colors ---
  // Used for darker text background in light mode
  inverseSurface: Color(0xFF303030),
  // Text/Icon color on inverse surface 
  onInverseSurface: Colors.white,

  // --- Surface Tint Colors ---
  // Tint for elevated surfaces 
  surfaceTint: Color(0xFF673AB7),

  // --- Inverse Primary Color ---
  // Inverse primary color 
  inversePrimary: Colors.black,

  // --- Surface Containers ---
  // Different levels of surface containers with varying background shades
  surfaceContainer: AppColors.blueGrey900L2,
  // Lowest level container surface 
  surfaceContainerLowest: AppColors.bluePurple50,
  // Low level container surface 
  surfaceContainerLow: AppColors.bluePurple50,
  // High level container surface 
  surfaceContainerHigh: AppColors.blueGrey100,
  // Highest level container surface 
  surfaceContainerHighest: AppColors.blueGrey50,
);

