import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

// Neutral Colors
  static const Color whitePure = Color(0xFFFFFFFF);
  static const Color whiteShade = Color(0xFFFFF8F8);
  static const Color blackPure = Color(0xFF000000);
  static const Color blackShade = Color(0xFF0A0A0A);
  static const Color grayLight = Color(0xFFDDDDDD);
  static const Color grayDark = Color(0xFF888888);
  static const Color grayNeutral = Color(0xFFCCCCCC);

// Primary Colors
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color primaryRed = Color(0xFFF44336);
  static const Color primaryGreen = Color(0xFF4CAF50);
  static const Color primaryYellow = Color(0xFFFFEB3B);
  static const Color primaryOrange = Color(0xFFFF9800);

// Accent Colors
  static const Color accentBlue = Color(0xFF42A5F5);
  static const Color accentRed = Color(0xFFEF5350);
  static const Color accentGreen = Color(0xFF66BB6A);
  static const Color accentYellow = Color(0xFFFFEE58);
  static const Color accentOrange = Color(0xFFFFA726);

  // Background Colors
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF303030);
  static const Color backgroundSurface = Color(0xFFFAFAFA);
  static const Color backgroundOverlay = Color(0xB3000000);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color textDisabled = Color(0xFF9E9E9E);

  // Border Colors
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color borderDark = Color(0xFFBDBDBD);
  static const Color borderPrimary = Color(0xFF2196F3);

  // Utility Colors
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color warningYellow = Color(0xFFFFEB3B);
  static const Color errorRed = Color(0xFFF44336);
  static const Color infoBlue = Color(0xFF2196F3);

  // App Color Palette
  // -> BLUE PURPLE
  static const Color bluePurple50 = Color(0xFFF7F8FE);
  static const Color bluePurple100 = Color(0xFFC5CAE9);
  static const Color bluePurple200 = Color(0xFF9FA8DA);
  static const Color bluePurple300 = Color(0xFF7986CB);
  static const Color bluePurple400 = Color(0xFF5C6BC0);
  static const Color bluePurple500 = Color(0xFF3F51B5);
  static const Color bluePurple600 = Color(0xFF3949AB);
  static const Color bluePurple700 = Color(0xFF303F9F);
  static const Color bluePurple800 = Color(0xFF283593);
  static const Color bluePurple900 = Color(0xFF1A237E);
  static const Color bluePurple900L1 = Color(0xFF3D1F6D);
  static const Color bluePurple900L2 = Color(0xFF291449);
  static const Color bluePurple900L3 = Color(0xFF1B0A34);

  // -> DEEP PURPLE
  static const Color deepPurple50 = Color(0xFFEDE7F6);
  static const Color deepPurple100 = Color(0xFFD1C4E9);
  static const Color deepPurple200 = Color(0xFFB39DDB);
  static const Color deepPurple300 = Color(0xFF9575CD);
  static const Color deepPurple400 = Color(0xFF7E57C2);
  static const Color deepPurple500 = Color(0xFF673AB7);
  static const Color deepPurple600 = Color(0xFF5E35B1);
  static const Color deepPurple700 = Color(0xFF512DA8);
  static const Color deepPurple800 = Color(0xFF4527A0);
  static const Color deepPurple900 = Color(0xFF311B92);

  // -> BLUE GREY
  static const Color blueGrey50 = Color(0xFFECEFF1);
  static const Color blueGrey100 = Color(0xFFCFD8DC);
  static const Color blueGrey200 = Color(0xFFB0BEC5);
  static const Color blueGrey300 = Color(0xFF90A4AE);
  static const Color blueGrey400 = Color(0xFF78909C);
  static const Color blueGrey500 = Color(0xFF607D8B);
  static const Color blueGrey600 = Color(0xFF546E7A);
  static const Color blueGrey700 = Color(0xFF455A64);
  static const Color blueGrey800 = Color(0xFF37474F);
  static const Color blueGrey900 = Color(0xFF263238);
  static const Color blueGrey900L1 = Color(0xFF0D0D0D);
  static const Color blueGrey900L2 = Color(0xFF1C2830);

  // -> GOLD
  static const Color gold50 = Color(0xFFFFF8E1);
  static const Color gold100 = Color(0xFFFFECB3);
  static const Color gold200 = Color(0xFFFFE082);
  static const Color gold300 = Color(0xFFFFD54F);
  static const Color gold400 = Color(0xFFFFCA28);
  static const Color gold500 = Color(0xFFFFB300);
  static const Color gold600 = Color(0xFFFFA000);
  static const Color gold700 = Color(0xFFFF8F00);
  static const Color gold800 = Color(0xFFFB8C00);
  static const Color gold900 = Color(0xFFEF6C00);

  // -> GREEN
  static const Color green50 = Color(0xFFE8F5E9); 
  static const Color green100 = Color(0xFFC8E6C9); 
  static const Color green200 = Color(0xFFA5D6A7); 
  static const Color green300 = Color(0xFF81C784); 
  static const Color green400 = Color(0xFF66BB6A); 
  static const Color green500 = Color(0xFF4CAF50); 
  static const Color green600 = Color(0xFF43A047); 
  static const Color green700 = Color(0xFF388E3C); 
  static const Color green800 = Color(0xFF2C6B2F); 
  static const Color green900 = Color(0xFF1B5E20); 

  // -> TEAL
static const Color teal50 = Color(0xFFE0F2F1);  
static const Color teal100 = Color(0xFFB2DFDB); 
static const Color teal200 = Color(0xFF80CBC4); 
static const Color teal300 = Color(0xFF4DB6AC); 
static const Color teal400 = Color(0xFF26A69A); 
static const Color teal500 = Color(0xFF03DAC5); 
static const Color teal600 = Color(0xFF00B8A2); 
static const Color teal700 = Color(0xFF00A396); 
static const Color teal800 = Color(0xFF008C7A); 
static const Color teal900 = Color(0xFF00796B); 

  // -> WHITE
  static const Color white50 = Color(0xFFFFFFFF);
  static const Color white100 = Color(0xFFFFF8F8);
  static const Color white200 = Color(0xFFFFF2F2);
  static const Color white300 = Color(0xFFEEEDED);
  static const Color white400 = Color(0xFFE8E8E8);
  static const Color white500 = Color(0xFFE0E0E0);
  static const Color white600 = Color(0xFFD6D6D6);
  static const Color white700 = Color(0xFFCCCCCC);
  static const Color white800 = Color(0xFFBDBDBD);
  static const Color white900 = Color(0xFFAFAFAF);

  // -> BLACK
  static const Color black50 = Color(0xFFE0E0E0);
  static const Color black100 = Color(0xFFBDBDBD);
  static const Color black200 = Color(0xFF9E9E9E);
  static const Color black300 = Color(0xFF757575);
  static const Color black400 = Color(0xFF616161);
  static const Color black500 = Color(0xFF424242);
  static const Color black600 = Color(0xFF2E2E2E);
  static const Color black700 = Color(0xFF212121);
  static const Color black800 = Color(0xFF161616);
  static const Color black900 = Color(0xFF0A0A0A);
}

class AppThemeColors {
  static const Color primary = Color(0xFF6200EA);
  static const Color accent = Color(0xFF03DAC5);
  static const Color background = Color(0xFFF6F6F6);
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF757575);
}
