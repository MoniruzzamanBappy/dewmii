import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Default fallback palette: Serenity
  static const Color palette01 = Color(0xFFEAF7FF);
  static const Color palette02 = Color(0xFF7DD3FC);
  static const Color palette03 = Color(0xFFBAE6FD);
  static const Color palette04 = Color(0xFF0F172A);
  static const Color palette05 = Color(0xFFF8FCFF);

  static const Color primary = Color(0xFF38BDF8);
  static const Color primaryLight = Color(0xFF7DD3FC);
  static const Color primaryDark = Color(0xFF0284C7);
  static const Color secondary = Color(0xFF99F6E4);
  static const Color accent = Color(0xFFFACC15);

  static const Color lightBackground = Color(0xFFF8FCFF);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFEAF7FF);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightTextTertiary = Color(0xFF64748B);
  static const Color lightBorder = Color(0xFFD8EEF9);
  static const Color lightBorderStrong = Color(0xFFBAE6FD);
  static const Color lightDivider = Color(0xFFEAF7FF);

  static const Color darkBackground = Color(0xFF07111F);
  static const Color darkSurface = Color(0xFF0F1E2E);
  static const Color darkSurfaceVariant = Color(0xFF162A3D);
  static const Color darkTextPrimary = Color(0xFFE0F2FE);
  static const Color darkTextSecondary = Color(0xFF93C5FD);
  static const Color darkTextTertiary = Color(0xFF60A5FA);
  static const Color darkBorder = Color(0xFF1E3A5F);
  static const Color darkBorderStrong = Color(0xFF2563EB);
  static const Color darkDivider = Color(0xFF102033);

  static const Color muted = Color(0xFF64748B);
  static const Color softMuted = Color(0xFFEAF7FF);
  static const Color overlay = Color(0x80000000);
  static const Color shimmerBase = Color(0xFFD8EEF9);
  static const Color shimmerHigh = Color(0xFFF0FAFF);

  static const Color success = Color(0xFF22C55E);
  static const Color successSurface = Color(0xFFDCFCE7);

  static const Color error = Color(0xFFEF4444);
  static const Color danger = error;
  static const Color errorSurface = Color(0xFFFEE2E2);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningSurface = Color(0xFFFEF3C7);

  static const Color info = Color(0xFF38BDF8);
  static const Color infoSurface = Color(0xFFE0F2FE);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF7DD3FC), Color(0xFF38BDF8), Color(0xFF0EA5E9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFFEAF7FF), Color(0xFFBAE6FD), Color(0xFF7DD3FC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient sageGradient = LinearGradient(
    colors: [Color(0xFFF8FCFF), Color(0xFFDFF7FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF07111F), Color(0xFF0F1E2E), Color(0xFF162A3D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkHeroGradient = LinearGradient(
    colors: [Color(0xFF0F1E2E), Color(0xFF12385A), Color(0xFF075985)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const RadialGradient glowGradient = RadialGradient(
    colors: [Color(0x3338BDF8), Color(0x0038BDF8)],
    radius: 0.8,
  );
}
