import 'package:flutter/material.dart';

enum AppThemeVariant {
  light,
  dark,
  serenity,
  rose,
  violet,
  banana,
  seaFoam,
  slate,
}

class ThemeController {
  ThemeController._();

  static final ValueNotifier<AppThemeVariant> themeVariant =
      ValueNotifier<AppThemeVariant>(AppThemeVariant.serenity);

  static Future<void> init() async {
    themeVariant.value = AppThemeVariant.serenity;
  }

  static void setTheme(AppThemeVariant variant) {
    if (themeVariant.value == variant) return;
    themeVariant.value = variant;
  }

  static bool isDarkMode(BuildContext context) {
    return themeVariant.value == AppThemeVariant.dark;
  }

  static IconData currentIcon() {
    switch (themeVariant.value) {
      case AppThemeVariant.light:
        return Icons.light_mode_rounded;
      case AppThemeVariant.dark:
        return Icons.dark_mode_rounded;
      case AppThemeVariant.serenity:
        return Icons.water_drop_rounded;
      case AppThemeVariant.rose:
        return Icons.favorite_rounded;
      case AppThemeVariant.violet:
        return Icons.auto_awesome_rounded;
      case AppThemeVariant.banana:
        return Icons.wb_sunny_rounded;
      case AppThemeVariant.seaFoam:
        return Icons.spa_rounded;
      case AppThemeVariant.slate:
        return Icons.layers_rounded;
    }
  }

  static String currentTooltip() {
    return 'Change theme';
  }

  static String currentLabel() {
    return variantLabel(themeVariant.value);
  }

  static String variantLabel(AppThemeVariant variant) {
    switch (variant) {
      case AppThemeVariant.light:
        return 'Light';
      case AppThemeVariant.dark:
        return 'Dark';
      case AppThemeVariant.serenity:
        return 'Serenity';
      case AppThemeVariant.rose:
        return 'Rose';
      case AppThemeVariant.violet:
        return 'Violet';
      case AppThemeVariant.banana:
        return 'Banana';
      case AppThemeVariant.seaFoam:
        return 'Sea Foam';
      case AppThemeVariant.slate:
        return 'Slate';
    }
  }
}
