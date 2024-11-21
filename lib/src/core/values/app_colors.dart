import 'package:flutter/material.dart';

class AppColors {
// Neutral Colors
  static const Color whiteShade = Color(0xFFFFF8F8);
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
  static const Color bluePurple50 = Color.fromARGB(255, 247, 248, 254);
  static const Color bluePurple100 = Color(0xFFC5CAE9);
  static const Color bluePurple200 = Color(0xFF9FA8DA);
  static const Color bluePurple300 = Color(0xFF7986CB);
  static const Color bluePurple400 = Color(0xFF5C6BC0);
  static const Color bluePurple500 = Color(0xFF3F51B5);
  static const Color bluePurple600 = Color(0xFF3949AB);
  static const Color bluePurple700 = Color(0xFF303F9F);
  static const Color bluePurple800 = Color(0xFF283593);
  static const Color bluePurple900 = Color(0xFF1A237E);
  static const Color bluePurple900X = Color.fromARGB(255, 61, 31, 109);
  static const Color bluePurple900Y = Color.fromARGB(255, 41, 20, 73);
  static const Color bluePurple900Z = Color.fromARGB(255, 27, 10, 52);

  static const Color deepPurpleShade50 = Color(0xFFEDE7F6);
  static const Color deepPurpleShade100 = Color(0xFFD1C4E9);
  static const Color deepPurpleShade200 = Color(0xFFB39DDB);
  static const Color deepPurpleShade300 = Color(0xFF9575CD);
  static const Color deepPurpleShade400 = Color(0xFF7E57C2);
  static const Color deepPurpleShade500 = Color(0xFF673AB7);
  static const Color deepPurpleShade600 = Color(0xFF5E35B1);
  static const Color deepPurpleShade700 = Color(0xFF512DA8);
  static const Color deepPurpleShade800 = Color(0xFF4527A0);
  static const Color deepPurpleShade900 = Color(0xFF311B92);

  static const Color blueGreyShade50 = Color(0xFFECEFF1);
  static const Color blueGreyShade100 = Color(0xFFCFD8DC);
  static const Color blueGreyShade200 = Color(0xFFB0BEC5);
  static const Color blueGreyShade300 = Color(0xFF90A4AE);
  static const Color blueGreyShade400 = Color(0xFF78909C);
  static const Color blueGreyShade500 = Color(0xFF607D8B);
  static const Color blueGreyShade600 = Color(0xFF546E7A);
  static const Color blueGreyShade700 = Color(0xFF455A64);
  static const Color blueGreyShade800 = Color(0xFF37474F);
  static const Color blueGreyShade900 = Color(0xFF263238);
  static const Color blueGreyShade900X = Color.fromARGB(255, 13, 13, 13);
  static const Color blueGreyShade900Y = Color.fromARGB(255, 28, 40, 46);

  static const Color goldShade50 = Color(0xFFFFF8E1);
  static const Color goldShade100 = Color(0xFFFFECB3);
  static const Color goldShade200 = Color(0xFFFFE082);
  static const Color goldShade300 = Color(0xFFFFD54F);
  static const Color goldShade400 = Color(0xFFFFCA28);
  static const Color goldShade500 = Color(0xFFFFB300);
  static const Color goldShade600 = Color(0xFFFFA000);
  static const Color goldShade700 = Color(0xFFFF8F00);
  static const Color goldShade800 = Color(0xFFFB8C00);
  static const Color goldShade900 = Color(0xFFEF6C00);

  static const Color whiteShade50 = Color(0xFFFFFFFF);
  static const Color whiteShade100 = Color(0xFFFFF8F8);
  static const Color whiteShade200 = Color(0xFFFFF2F2);
  static const Color whiteShade300 = Color(0xFFEEEDED);
  static const Color whiteShade400 = Color(0xFFE8E8E8);
  static const Color whiteShade500 = Color(0xFFE0E0E0);
  static const Color whiteShade600 = Color(0xFFD6D6D6);
  static const Color whiteShade700 = Color(0xFFCCCCCC);
  static const Color whiteShade800 = Color(0xFFBDBDBD);
  static const Color whiteShade900 = Color(0xFFAFAFAF);

  static const Color blackShade50 = Color(0xFFE0E0E0);
  static const Color blackShade100 = Color(0xFFBDBDBD);
  static const Color blackShade200 = Color(0xFF9E9E9E);
  static const Color blackShade300 = Color(0xFF757575);
  static const Color blackShade400 = Color(0xFF616161);
  static const Color blackShade500 = Color(0xFF424242);
  static const Color blackShade600 = Color(0xFF2E2E2E);
  static const Color blackShade700 = Color(0xFF212121);
  static const Color blackShade800 = Color(0xFF161616);
  static const Color blackShade900 = Color(0xFF0A0A0A);
}

class AppThemeColors {
  static const Color primary = Color(0xFF6200EA);
  static const Color accent = Color(0xFF03DAC5);
  static const Color background = Color(0xFFF6F6F6);
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF757575);
}
