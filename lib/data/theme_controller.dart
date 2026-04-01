import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  static const String _themePreferenceKey = 'dthc_theme_mode';
  bool _isDarkMode = false;

  ThemeController() {
    _loadSavedThemeMode();
  }

  bool get isDarkMode => _isDarkMode;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;
  String get modeKey => _isDarkMode ? 'dark' : 'light';

  Future<void> _loadSavedThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMode = prefs.getString(_themePreferenceKey);
    if (savedMode == null || savedMode.trim().isEmpty) return;

    final normalized = savedMode.trim().toLowerCase();
    final nextValue = normalized == 'dark';
    if (_isDarkMode == nextValue) return;

    _isDarkMode = nextValue;
    notifyListeners();
  }

  Future<void> setThemeMode(String mode) async {
    final normalized = mode.trim().toLowerCase();
    final nextValue = normalized == 'dark';
    if (_isDarkMode == nextValue) return;
    _isDarkMode = nextValue;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themePreferenceKey, modeKey);
    notifyListeners();
  }

  Future<void> toggle() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themePreferenceKey, modeKey);
    notifyListeners();
  }
}
