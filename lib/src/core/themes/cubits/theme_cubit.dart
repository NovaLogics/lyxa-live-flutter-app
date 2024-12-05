import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/themes/dark_mode.dart';
import 'package:lyxa_live/src/core/themes/light_mode.dart';

class ThemeCubit extends Cubit<ThemeData> {
  bool _isDarkMode = true;

  ThemeCubit() : super(lightMode);

  bool get isDarkMode => _isDarkMode;

  bool get isLightMode => !_isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;

    if (isDarkMode) {
      emit(darkMode);
    } else {
      emit(lightMode);
    }
  }
}
