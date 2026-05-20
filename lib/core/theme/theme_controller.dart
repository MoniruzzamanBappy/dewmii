import 'package:flutter/material.dart';

/// Lightweight app-wide theme controller.
///
/// It intentionally uses only Flutter SDK APIs so it remains a drop-in file.
/// When you add persistence later, restore the saved value in [init] and save
/// the mode inside [_set].
class ThemeController {
  ThemeController._();

  static final ValueNotifier<ThemeMode> themeMode = ValueNotifier<ThemeMode>(
    ThemeMode.system,
  );

  static Future<void> init() async {
    themeMode.value = ThemeMode.system;
  }

  static void setLight() => _set(ThemeMode.light);
  static void setDark() => _set(ThemeMode.dark);
  static void setSystem() => _set(ThemeMode.system);

  static void toggleTheme() {
    switch (themeMode.value) {
      case ThemeMode.system:
      case ThemeMode.light:
        _set(ThemeMode.dark);
      case ThemeMode.dark:
        _set(ThemeMode.light);
    }
  }

  static bool isDarkMode(BuildContext context) {
    return switch (themeMode.value) {
      ThemeMode.dark => true,
      ThemeMode.light => false,
      ThemeMode.system =>
        MediaQuery.platformBrightnessOf(context) == Brightness.dark,
    };
  }

  static IconData toggleIcon(BuildContext context) {
    return isDarkMode(context)
        ? Icons.light_mode_rounded
        : Icons.dark_mode_rounded;
  }

  static String toggleTooltip(BuildContext context) {
    return isDarkMode(context) ? 'Switch to light mode' : 'Switch to dark mode';
  }

  static String currentLabel(BuildContext context) {
    if (themeMode.value == ThemeMode.system) return 'System';
    return isDarkMode(context) ? 'Dark' : 'Light';
  }

  static void _set(ThemeMode mode) {
    if (themeMode.value == mode) return;
    themeMode.value = mode;
  }
}
