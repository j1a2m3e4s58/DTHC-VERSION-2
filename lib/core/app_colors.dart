import 'package:flutter/material.dart';

class AppColors {
  // New DTHC brand colors
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
}