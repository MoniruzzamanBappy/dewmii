import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color palette01 = Color(0xFFFAE6EF); // Blush 50
  static const Color palette02 = Color(0xFFF2ABC8); // Rose petal
  static const Color palette03 = Color(0xFFC8DBCA); // Sage
  static const Color palette04 = Color(0xFF1E0D16); // Ink black
  static const Color palette05 = Color(0xFFFFFAF8); // Petal white

  // Brand Colors
  static const Color primary = Color(0xFFD4698E); // Deep rose
  static const Color primaryDark = palette04;
  static const Color secondary = palette03;

  // Light Theme
  static const Color lightBackground = Color(0xFFFFFAF8);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = palette04;
  static const Color lightTextSecondary = Color(0xFF8A4C65);
  static const Color lightBorder = Color(0xFFF2D9E4);

  // Dark Theme
  static const Color darkBackground = Color(0xFF3A1A2B);
  static const Color darkSurface = Color(0xFF4E2338);
  static const Color darkTextPrimary = Color(0xFFF9DFEB);
  static const Color darkTextSecondary = Color(0xFFE8AECB);
  static const Color darkBorder = Color(0xFF6B3050);

  // Extra UI Colors
  static const Color muted = Color(0xFFA07080);
  static const Color softMuted = Color(0xFFF7EBF1);
  static const Color accent = palette03;

  // Status Colors
  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFF2ABC8), Color(0xFFFAE6EF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient softGradient = LinearGradient(
    colors: [Color(0xFFFFFAF8), Color(0xFFC8DBCA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF3A1A2B), Color(0xFF4E2338), Color(0xFF5C2642)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
