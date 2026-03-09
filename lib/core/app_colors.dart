import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryGreen = Color(0xFF166534);
  static const Color darkGreen = Color(0xFF14532D);
  static const Color lightGreen = Color(0xFFDCFCE7);

  static const Color cream = Color(0xFFF8F1DE);
  static const Color softCream = Color(0xFFFFFBF2);

  static const Color accentGold = Color(0xFFEAB308);
  static const Color deepOrange = Color(0xFF9A3412);
  static const Color warmBrown = Color(0xFF7C2D12);

  static const Color white = Colors.white;
  static const Color black = Color(0xFF111827);
  static const Color greyText = Color(0xFF6B7280);
  static const Color border = Color(0xFFE5E7EB);

  static const Color success = Color(0xFF16A34A);
  static const Color danger = Color(0xFFDC2626);

  static const LinearGradient heroGradient = LinearGradient(
    colors: [
      Color(0xFFF8F1DE),
      Color(0xFFFDF7EA),
      Color(0xFFECFCCB),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}