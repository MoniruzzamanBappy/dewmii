import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ─── Palette ────────────────────────────────────────────────────────────────
  static const Color palette01 = Color(0xFFFAE6EF); // Blush 50
  static const Color palette02 = Color(0xFFF2ABC8); // Rose petal
  static const Color palette03 = Color(0xFFC8DBCA); // Sage
  static const Color palette04 = Color(0xFF1E0D16); // Ink black
  static const Color palette05 = Color(0xFFFFFAF8); // Petal white

  // ─── Brand ──────────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFFD4698E); // Deep rose
  static const Color primaryLight = Color(0xFFE891AD); // Lighter rose
  static const Color primaryDark = Color(0xFFB5496F); // Darker rose
  static const Color secondary = palette03; // Sage green
  static const Color accent = Color(0xFFE8C4A0); // Warm sand

  // ─── Light Theme ────────────────────────────────────────────────────────────
  static const Color lightBackground = Color(0xFFFFFAF8);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFFDF4F8);
  static const Color lightTextPrimary = palette04;
  static const Color lightTextSecondary = Color(0xFF8A4C65);
  static const Color lightTextTertiary = Color(0xFFB07090);
  static const Color lightBorder = Color(0xFFF2D9E4);
  static const Color lightBorderStrong = Color(0xFFE4BBCC);
  static const Color lightDivider = Color(0xFFF8ECF2);

  // ─── Dark Theme ─────────────────────────────────────────────────────────────
  static const Color darkBackground = Color(0xFF1C0D18);
  static const Color darkSurface = Color(0xFF2A1122);
  static const Color darkSurfaceVariant = Color(0xFF3A1A2E);
  static const Color darkTextPrimary = Color(0xFFF9DFEB);
  static const Color darkTextSecondary = Color(0xFFCF8AAF);
  static const Color darkTextTertiary = Color(0xFF9A5A7A);
  static const Color darkBorder = Color(0xFF4E2038);
  static const Color darkBorderStrong = Color(0xFF6B3050);
  static const Color darkDivider = Color(0xFF2E1228);

  // ─── UI Utility ─────────────────────────────────────────────────────────────
  static const Color muted = Color(0xFFA07080);
  static const Color softMuted = Color(0xFFF7EBF1);
  static const Color overlay = Color(0x80000000);
  static const Color shimmerBase = Color(0xFFEED6E4);
  static const Color shimmerHigh = Color(0xFFFAEEF5);

  // ─── Status ─────────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF22C55E);
  static const Color successSurface = Color(0xFFDCFCE7);
  static const Color error = Color(0xFFEF4444);
  static const Color errorSurface = Color(0xFFFEE2E2);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningSurface = Color(0xFFFEF3C7);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoSurface = Color(0xFFDBEAFE);
  static const Color danger = error;

  // ─── Gradients ──────────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFE891AD), Color(0xFFD4698E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFFFAE6EF), Color(0xFFF2ABC8), Color(0xFFE8C4D8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient sageGradient = LinearGradient(
    colors: [Color(0xFFFFFAF8), Color(0xFFD8EBD9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF1C0D18), Color(0xFF2A1122), Color(0xFF3A1A2E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkHeroGradient = LinearGradient(
    colors: [Color(0xFF3A1A2E), Color(0xFF4E2038), Color(0xFF5C2545)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ─── Radial / Mesh ──────────────────────────────────────────────────────────
  static const RadialGradient glowGradient = RadialGradient(
    colors: [Color(0x33D4698E), Color(0x00D4698E)],
    radius: 0.8,
  );
}
