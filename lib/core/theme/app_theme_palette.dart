import 'package:flutter/material.dart';

import 'theme_controller.dart';

class AppThemePalette {
  final Brightness brightness;

  final Color background;
  final Color surface;
  final Color surfaceVariant;

  final Color primary;
  final Color primaryLight;
  final Color primaryDark;

  final Color secondary;
  final Color accent;

  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;

  final Color border;
  final Color borderStrong;
  final Color divider;

  final Color muted;
  final Color softMuted;

  final Color shimmerBase;
  final Color shimmerHigh;

  final LinearGradient primaryGradient;
  final LinearGradient heroGradient;

  const AppThemePalette({
    required this.brightness,
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.primary,
    required this.primaryLight,
    required this.primaryDark,
    required this.secondary,
    required this.accent,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.border,
    required this.borderStrong,
    required this.divider,
    required this.muted,
    required this.softMuted,
    required this.shimmerBase,
    required this.shimmerHigh,
    required this.primaryGradient,
    required this.heroGradient,
  });

  bool get isDark => brightness == Brightness.dark;
}

class AppThemePalettes {
  AppThemePalettes._();

  static const AppThemePalette light = AppThemePalette(
    brightness: Brightness.light,
    background: Color(0xFFF8FCFF),
    surface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0xFFEAF7FF),
    primary: Color(0xFF38BDF8),
    primaryLight: Color(0xFF7DD3FC),
    primaryDark: Color(0xFF0284C7),
    secondary: Color(0xFFBAE6FD),
    accent: Color(0xFFFACC15),
    textPrimary: Color(0xFF0F172A),
    textSecondary: Color(0xFF475569),
    textTertiary: Color(0xFF64748B),
    border: Color(0xFFD8EEF9),
    borderStrong: Color(0xFFBAE6FD),
    divider: Color(0xFFEAF7FF),
    muted: Color(0xFF64748B),
    softMuted: Color(0xFFEAF7FF),
    shimmerBase: Color(0xFFD8EEF9),
    shimmerHigh: Color(0xFFF0FAFF),
    primaryGradient: LinearGradient(
      colors: [Color(0xFF7DD3FC), Color(0xFF38BDF8), Color(0xFF0EA5E9)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    heroGradient: LinearGradient(
      colors: [Color(0xFFEAF7FF), Color(0xFFBAE6FD), Color(0xFF7DD3FC)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  static const AppThemePalette dark = AppThemePalette(
    brightness: Brightness.dark,
    background: Color(0xFF07111F),
    surface: Color(0xFF0F1E2E),
    surfaceVariant: Color(0xFF162A3D),
    primary: Color(0xFF7DD3FC),
    primaryLight: Color(0xFFBAE6FD),
    primaryDark: Color(0xFF38BDF8),
    secondary: Color(0xFF0EA5E9),
    accent: Color(0xFFFACC15),
    textPrimary: Color(0xFFE0F2FE),
    textSecondary: Color(0xFF93C5FD),
    textTertiary: Color(0xFF60A5FA),
    border: Color(0xFF1E3A5F),
    borderStrong: Color(0xFF2563EB),
    divider: Color(0xFF102033),
    muted: Color(0xFF93A4B8),
    softMuted: Color(0xFF162A3D),
    shimmerBase: Color(0xFF1E3A5F),
    shimmerHigh: Color(0xFF162A3D),
    primaryGradient: LinearGradient(
      colors: [Color(0xFF0F1E2E), Color(0xFF12385A), Color(0xFF075985)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    heroGradient: LinearGradient(
      colors: [Color(0xFF0F1E2E), Color(0xFF12385A), Color(0xFF075985)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  static const AppThemePalette serenity = AppThemePalette(
    brightness: Brightness.light,
    background: Color(0xFFF8FCFF),
    surface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0xFFEAF7FF),
    primary: Color(0xFF38BDF8),
    primaryLight: Color(0xFF7DD3FC),
    primaryDark: Color(0xFF0284C7),
    secondary: Color(0xFF99F6E4),
    accent: Color(0xFFFACC15),
    textPrimary: Color(0xFF0F172A),
    textSecondary: Color(0xFF475569),
    textTertiary: Color(0xFF64748B),
    border: Color(0xFFD8EEF9),
    borderStrong: Color(0xFFBAE6FD),
    divider: Color(0xFFEAF7FF),
    muted: Color(0xFF64748B),
    softMuted: Color(0xFFEAF7FF),
    shimmerBase: Color(0xFFD8EEF9),
    shimmerHigh: Color(0xFFF0FAFF),
    primaryGradient: LinearGradient(
      colors: [Color(0xFF7DD3FC), Color(0xFF38BDF8), Color(0xFF0EA5E9)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    heroGradient: LinearGradient(
      colors: [Color(0xFFEAF7FF), Color(0xFFBAE6FD), Color(0xFF7DD3FC)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  static const AppThemePalette rose = AppThemePalette(
    brightness: Brightness.light,
    background: Color(0xFFFFF7FB),
    surface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0xFFFFEAF2),
    primary: Color(0xFFE11D74),
    primaryLight: Color(0xFFF472B6),
    primaryDark: Color(0xFFBE185D),
    secondary: Color(0xFFFFD6E8),
    accent: Color(0xFFF9A8D4),
    textPrimary: Color(0xFF3B1022),
    textSecondary: Color(0xFF8A3A5C),
    textTertiary: Color(0xFFB05C7E),
    border: Color(0xFFF5C8DA),
    borderStrong: Color(0xFFEFA3C2),
    divider: Color(0xFFFFE4EF),
    muted: Color(0xFF9F5D78),
    softMuted: Color(0xFFFFEAF2),
    shimmerBase: Color(0xFFF5C8DA),
    shimmerHigh: Color(0xFFFFF1F7),
    primaryGradient: LinearGradient(
      colors: [Color(0xFFF472B6), Color(0xFFE11D74), Color(0xFFBE185D)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    heroGradient: LinearGradient(
      colors: [Color(0xFFFFF7FB), Color(0xFFFFD6E8), Color(0xFFF9A8D4)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  static const AppThemePalette violet = AppThemePalette(
    brightness: Brightness.light,
    background: Color(0xFFFBF8FF),
    surface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0xFFF1E9FF),
    primary: Color(0xFF7C3AED),
    primaryLight: Color(0xFFA78BFA),
    primaryDark: Color(0xFF5B21B6),
    secondary: Color(0xFFEDE9FE),
    accent: Color(0xFFC4B5FD),
    textPrimary: Color(0xFF24113F),
    textSecondary: Color(0xFF6D5A88),
    textTertiary: Color(0xFF8B7BA5),
    border: Color(0xFFD8CCF5),
    borderStrong: Color(0xFFC4B5FD),
    divider: Color(0xFFF1E9FF),
    muted: Color(0xFF76658F),
    softMuted: Color(0xFFF1E9FF),
    shimmerBase: Color(0xFFD8CCF5),
    shimmerHigh: Color(0xFFFBF8FF),
    primaryGradient: LinearGradient(
      colors: [Color(0xFFA78BFA), Color(0xFF7C3AED), Color(0xFF5B21B6)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    heroGradient: LinearGradient(
      colors: [Color(0xFFFBF8FF), Color(0xFFEDE9FE), Color(0xFFC4B5FD)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  static const AppThemePalette banana = AppThemePalette(
    brightness: Brightness.light,
    background: Color(0xFFFFFBEA),
    surface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0xFFFFF4BA),
    primary: Color(0xFFEAB308),
    primaryLight: Color(0xFFFDE047),
    primaryDark: Color(0xFFA16207),
    secondary: Color(0xFFFEF3C7),
    accent: Color(0xFFF97316),
    textPrimary: Color(0xFF3F2D0C),
    textSecondary: Color(0xFF7A5B16),
    textTertiary: Color(0xFF9A741B),
    border: Color(0xFFEED98B),
    borderStrong: Color(0xFFEAB308),
    divider: Color(0xFFFFF4BA),
    muted: Color(0xFF846A22),
    softMuted: Color(0xFFFFF4BA),
    shimmerBase: Color(0xFFEED98B),
    shimmerHigh: Color(0xFFFFFBEA),
    primaryGradient: LinearGradient(
      colors: [Color(0xFFFDE047), Color(0xFFEAB308), Color(0xFFA16207)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    heroGradient: LinearGradient(
      colors: [Color(0xFFFFFBEA), Color(0xFFFEF3C7), Color(0xFFFDE047)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  static const AppThemePalette seaFoam = AppThemePalette(
    brightness: Brightness.light,
    background: Color(0xFFF0FDFA),
    surface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0xFFCCFBF1),
    primary: Color(0xFF14B8A6),
    primaryLight: Color(0xFF5EEAD4),
    primaryDark: Color(0xFF0F766E),
    secondary: Color(0xFFCCFBF1),
    accent: Color(0xFF38BDF8),
    textPrimary: Color(0xFF123D3A),
    textSecondary: Color(0xFF4B6F6B),
    textTertiary: Color(0xFF5E8C85),
    border: Color(0xFF99F6E4),
    borderStrong: Color(0xFF5EEAD4),
    divider: Color(0xFFCCFBF1),
    muted: Color(0xFF5A7C78),
    softMuted: Color(0xFFCCFBF1),
    shimmerBase: Color(0xFF99F6E4),
    shimmerHigh: Color(0xFFF0FDFA),
    primaryGradient: LinearGradient(
      colors: [Color(0xFF5EEAD4), Color(0xFF14B8A6), Color(0xFF0F766E)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    heroGradient: LinearGradient(
      colors: [Color(0xFFF0FDFA), Color(0xFFCCFBF1), Color(0xFF5EEAD4)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  static const AppThemePalette slate = AppThemePalette(
    brightness: Brightness.light,
    background: Color(0xFFF8FAFC),
    surface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0xFFE2E8F0),
    primary: Color(0xFF64748B),
    primaryLight: Color(0xFF94A3B8),
    primaryDark: Color(0xFF334155),
    secondary: Color(0xFFE2E8F0),
    accent: Color(0xFF38BDF8),
    textPrimary: Color(0xFF0F172A),
    textSecondary: Color(0xFF475569),
    textTertiary: Color(0xFF64748B),
    border: Color(0xFFCBD5E1),
    borderStrong: Color(0xFF94A3B8),
    divider: Color(0xFFE2E8F0),
    muted: Color(0xFF64748B),
    softMuted: Color(0xFFE2E8F0),
    shimmerBase: Color(0xFFCBD5E1),
    shimmerHigh: Color(0xFFF8FAFC),
    primaryGradient: LinearGradient(
      colors: [Color(0xFF94A3B8), Color(0xFF64748B), Color(0xFF334155)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    heroGradient: LinearGradient(
      colors: [Color(0xFFF8FAFC), Color(0xFFE2E8F0), Color(0xFFCBD5E1)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  static AppThemePalette byVariant(AppThemeVariant variant) {
    switch (variant) {
      case AppThemeVariant.light:
        return light;
      case AppThemeVariant.dark:
        return dark;
      case AppThemeVariant.serenity:
        return serenity;
      case AppThemeVariant.rose:
        return rose;
      case AppThemeVariant.violet:
        return violet;
      case AppThemeVariant.banana:
        return banana;
      case AppThemeVariant.seaFoam:
        return seaFoam;
      case AppThemeVariant.slate:
        return slate;
    }
  }
}

extension AppPaletteX on BuildContext {
  AppThemePalette get palette {
    return AppThemePalettes.byVariant(ThemeController.themeVariant.value);
  }
}
