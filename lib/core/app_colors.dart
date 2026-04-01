import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryBlack = Color(0xFF0F0F0F);
  static const Color softBlack = Color(0xFF1A1A1A);
  static const Color charcoal = Color(0xFF262626);

  static const Color white = Colors.white;
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color greyText = Color(0xFF6B7280);
  static const Color gold = Color(0xFFD4AF37);
  static const Color deepGold = Color(0xFFB8962E);

  static const Color success = Color(0xFF16A34A);
  static const Color danger = Color(0xFFDC2626);
  static const Color border = Color(0xFFE5E7EB);

  static const LinearGradient heroGradient = LinearGradient(
    colors: [
      Color(0xFF0F0F0F),
      Color(0xFF1A1A1A),
      Color(0xFF262626),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Legacy compatibility aliases
  static const Color primaryGreen = gold;
  static const Color darkGreen = white;
  static const Color lightGreen = Color(0xFF2A2A2A);

  static const Color cream = primaryBlack;
  static const Color softCream = softBlack;

  static const Color accentGold = gold;
  static const Color deepOrange = gold;
  static const Color warmBrown = deepGold;

  static const Color black = primaryBlack;

  static const AppPalette lightPalette = AppPalette(
    background: Color(0xFFF6F6F6),
    surface: Colors.white,
    surfaceAlt: Color(0xFFF5F5F5),
    surfaceStrong: Color(0xFFFFF1C7),
    card: Colors.white,
    border: Color(0xFFE5E7EB),
    textPrimary: Color(0xFF0F0F0F),
    textSecondary: Color(0xFF111827),
    textOnStrong: Color(0xFF0F0F0F),
    heroGradient: LinearGradient(
      colors: [
        Color(0xFFFFFBEB),
        Color(0xFFFFF1C7),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    promoGradient: LinearGradient(
      colors: [
        Color(0xFFFFF4CC),
        Color(0xFFFFE39A),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  static const AppPalette darkPalette = AppPalette(
    background: Color(0xFF060D18),
    surface: Color(0xFF0B1523),
    surfaceAlt: Color(0xFF0F1C2E),
    surfaceStrong: Color(0xFF13243C),
    card: Color(0xFF0E1828),
    border: Color(0xFF1D3454),
    textPrimary: Color(0xFFF5F7FB),
    textSecondary: Color(0xFF9DB0C9),
    textOnStrong: Colors.white,
    heroGradient: LinearGradient(
      colors: [
        Color(0xFF08111E),
        Color(0xFF10243F),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    promoGradient: LinearGradient(
      colors: [
        Color(0xFF0A1629),
        Color(0xFF143053),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  static AppPalette palette(bool isDarkMode) =>
      isDarkMode ? darkPalette : lightPalette;
}

class AppPalette {
  final Color background;
  final Color surface;
  final Color surfaceAlt;
  final Color surfaceStrong;
  final Color card;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color textOnStrong;
  final LinearGradient heroGradient;
  final LinearGradient promoGradient;

  const AppPalette({
    required this.background,
    required this.surface,
    required this.surfaceAlt,
    required this.surfaceStrong,
    required this.card,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.textOnStrong,
    required this.heroGradient,
    required this.promoGradient,
  });
}
