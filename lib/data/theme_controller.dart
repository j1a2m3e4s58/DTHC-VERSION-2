import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;
  String get modeKey => _isDarkMode ? 'dark' : 'light';

  void setThemeMode(String mode) {
    final normalized = mode.trim().toLowerCase();
    final nextValue = normalized == 'dark';
    if (_isDarkMode == nextValue) return;
    _isDarkMode = nextValue;
    notifyListeners();
  }

  void toggle() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
