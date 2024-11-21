import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/resources/app_colors.dart';

ThemeData darkMode = ThemeData(
  colorScheme: darkColorScheme,
);

const ColorScheme darkColorScheme = ColorScheme.dark(
  brightness: Brightness.dark,

  // --- Primary Colors ---
  // Primary color for main actions
  primary: AppColors.bluePurple600,
  // Text/Icon color on primary
  onPrimary: AppColors.bluePurple400,
  // Darker shade of primary (background for primary elements)
  primaryContainer: AppColors.blueGrey900L1,
  // Text/Icon color on primary container
  onPrimaryContainer: AppColors.bluePurple50,

  // --- Secondary Colors ---
  // Secondary color for accents
  secondary: AppColors.deepPurple600,
  // Text/Icon color on secondary
  onSecondary: AppColors.bluePurple200,
  // Text/Icon color on secondary container
  secondaryContainer: Color(0xFF673AB7),

  // --- Tertiary Colors ---
  // Text/Icon color on tertiary
  onTertiary: AppColors.bluePurple50,

  // --- Error Colors ---
  // Error color (used for error states)
  error: Colors.red,
  // Text/Icon color on error
  onError: AppColors.blackPure,

  // --- Surface and Background Colors ---
  // Background color for surfaces like cards, dialogs, etc.
  surface: Color(0xFF121212),
  // Text/Icon color on surface
  onSurface: AppColors.whitePure,
  // Borders and outlines color (used for borders or subtle divisions)
  outline: Color(0xFF616161),
  // Shadows color for cards, modals, etc.
  shadow: Colors.black45,

  // --- Inverse Colors ---
  // Used for lighter text background in dark mode
  inverseSurface: Color(0xFFE0E0E0),
  // Text/Icon color on inverse surface
  onInverseSurface: AppColors.blackPure,

  // --- Surface Tint Colors ---
  // Tint for elevated surfaces (buttons / card backgrounds)
  surfaceTint: Colors.purple,

  // --- Inverse Primary Color ---
  // Inverse primary color
  inversePrimary: AppColors.bluePurple50,

  // --- Surface Containers ---
  // Different levels of surface containers for varying background shades
  surfaceContainer: AppColors.blueGrey900L1,

  // Lowest level container surface
  surfaceContainerLowest: AppColors.bluePurple900L3,

  // Low level container surface
  surfaceContainerLow: AppColors.bluePurple900L3,

  // High level container surface
  surfaceContainerHigh: AppColors.blueGrey900L2,

  // Highest level container surface
  surfaceContainerHighest: AppColors.blueGrey900L1,
);
