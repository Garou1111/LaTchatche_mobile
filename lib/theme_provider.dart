import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  // Default theme is light
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  // Function to toggle the theme mode
  void toggleTheme(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}
