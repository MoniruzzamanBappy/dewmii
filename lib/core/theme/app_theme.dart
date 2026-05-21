import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';
import 'app_theme_palette.dart';

class AppDimens {
  AppDimens._();

  static const double radiusXS = 6;
  static const double radiusSM = 10;
  static const double radiusMD = 14;
  static const double radiusLG = 18;
  static const double radiusXL = 24;
  static const double radiusXXL = 32;
  static const double radiusFull = 999;

  static const double spaceXS = 4;
  static const double spaceSM = 8;
  static const double spaceMD = 16;
  static const double spaceLG = 24;
  static const double spaceXL = 32;
  static const double spaceXXL = 48;

  static const double buttonHeight = 54;
  static const double inputHeight = 54;
  static const double appBarHeight = 60;
  static const double bottomNavHeight = 76;
  static const double cardElevation = 0;
}

class AppTheme {
  AppTheme._();

  static InputDecorationTheme _inputTheme({
    required Color fill,
    required Color border,
    required Color focused,
    required Color hint,
  }) {
    return InputDecorationTheme(
      filled: true,
      fillColor: fill,
      hintStyle: TextStyle(
        color: hint,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      labelStyle: TextStyle(color: hint, fontSize: 14),
      floatingLabelStyle: TextStyle(
        color: focused,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
      prefixIconColor: hint,
      suffixIconColor: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        borderSide: BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        borderSide: BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        borderSide: BorderSide(color: focused, width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        borderSide: const BorderSide(color: AppColors.error, width: 1.8),
      ),
      errorStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    );
  }

  static ButtonStyle _elevatedStyle({
    required Color bg,
    required Color fg,
    required Color disabledBg,
    required Color disabledFg,
  }) {
    return ElevatedButton.styleFrom(
      elevation: 0,
      shadowColor: Colors.transparent,
      backgroundColor: bg,
      foregroundColor: fg,
      disabledBackgroundColor: disabledBg,
      disabledForegroundColor: disabledFg,
      minimumSize: const Size(double.infinity, AppDimens.buttonHeight),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      textStyle: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
      ),
    );
  }

  static TextTheme _textTheme({
    required Color primaryText,
    required Color secondaryText,
    required Color tertiaryText,
  }) {
    return TextTheme(
      displayLarge: TextStyle(
        color: primaryText,
        fontWeight: FontWeight.w900,
        letterSpacing: -1.5,
      ),
      displayMedium: TextStyle(
        color: primaryText,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.0,
      ),
      displaySmall: TextStyle(
        color: primaryText,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
      ),
      headlineLarge: TextStyle(
        color: primaryText,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
      ),
      headlineMedium: TextStyle(
        color: primaryText,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      headlineSmall: TextStyle(color: primaryText, fontWeight: FontWeight.w700),
      titleLarge: TextStyle(
        color: primaryText,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ),
      titleMedium: TextStyle(color: primaryText, fontWeight: FontWeight.w600),
      titleSmall: TextStyle(
        color: primaryText,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
      bodyLarge: TextStyle(
        color: primaryText,
        fontWeight: FontWeight.w400,
        height: 1.6,
      ),
      bodyMedium: TextStyle(color: secondaryText, height: 1.5),
      bodySmall: TextStyle(color: secondaryText, fontSize: 12, height: 1.4),
      labelLarge: TextStyle(
        color: primaryText,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.1,
      ),
      labelMedium: TextStyle(
        color: secondaryText,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
      labelSmall: TextStyle(
        color: tertiaryText,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
    );
  }

  static ThemeData theme(AppThemePalette palette) {
    final isDark = palette.isDark;

    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: palette.primary,
          brightness: palette.brightness,
        ).copyWith(
          primary: palette.primary,
          onPrimary: isDark ? palette.background : Colors.white,
          primaryContainer: palette.surfaceVariant,
          onPrimaryContainer: palette.primaryDark,
          secondary: palette.secondary,
          onSecondary: palette.textPrimary,
          secondaryContainer: palette.secondary.withValues(alpha: 0.35),
          surface: palette.surface,
          onSurface: palette.textPrimary,
          surfaceContainerHighest: palette.surfaceVariant,
          outline: palette.border,
          outlineVariant: palette.divider,
          error: AppColors.error,
          onError: Colors.white,
          shadow: Colors.black.withValues(alpha: isDark ? 0.30 : 0.08),
        );

    return ThemeData(
      useMaterial3: true,
      brightness: palette.brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: palette.background,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: palette.background,
        foregroundColor: palette.textPrimary,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: AppDimens.appBarHeight,
        titleTextStyle: TextStyle(
          color: palette.textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(color: palette.textPrimary, size: 22),
        actionsIconTheme: IconThemeData(color: palette.textPrimary, size: 22),
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),
      textTheme: _textTheme(
        primaryText: palette.textPrimary,
        secondaryText: palette.textSecondary,
        tertiaryText: palette.textTertiary,
      ),
      cardTheme: CardThemeData(
        color: palette.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusLG),
          side: BorderSide(color: palette.border, width: 1),
        ),
      ),
      inputDecorationTheme: _inputTheme(
        fill: palette.surface,
        border: palette.border,
        focused: palette.primary,
        hint: palette.textTertiary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: _elevatedStyle(
          bg: palette.primary,
          fg: isDark ? palette.background : Colors.white,
          disabledBg: palette.primaryLight.withValues(alpha: 0.35),
          disabledFg: isDark ? palette.textSecondary : Colors.white70,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: palette.primary,
          foregroundColor: isDark ? palette.background : Colors.white,
          disabledBackgroundColor: palette.primaryLight.withValues(alpha: 0.35),
          disabledForegroundColor: isDark
              ? palette.textSecondary
              : Colors.white70,
          minimumSize: const Size(double.infinity, AppDimens.buttonHeight),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusLG),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: palette.primary,
          side: BorderSide(color: palette.primary, width: 1.5),
          minimumSize: const Size(double.infinity, AppDimens.buttonHeight),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusLG),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: palette.primary,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.1,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusSM),
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: palette.textPrimary,
          highlightColor: palette.primary.withValues(alpha: 0.08),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusSM),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: palette.surfaceVariant,
        selectedColor: palette.primary.withValues(alpha: 0.15),
        labelStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: palette.textPrimary,
        ),
        secondaryLabelStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: palette.primary,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusFull),
          side: BorderSide(color: palette.border),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: AppDimens.bottomNavHeight,
        backgroundColor: palette.surface,
        indicatorColor: palette.primary.withValues(alpha: 0.12),
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? palette.primary : palette.muted,
            letterSpacing: 0.2,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? palette.primary : palette.muted,
            size: 22,
          );
        }),
        shadowColor: Colors.black.withValues(alpha: isDark ? 0.22 : 0.06),
        elevation: 0,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceMD,
          vertical: 4,
        ),
        minLeadingWidth: 0,
        iconColor: palette.muted,
        textColor: palette.textPrimary,
        tileColor: Colors.transparent,
        selectedColor: palette.primary,
        selectedTileColor: palette.primary.withValues(alpha: 0.10),
      ),
      dividerTheme: DividerThemeData(
        color: palette.divider,
        thickness: 1,
        space: 1,
      ),
      iconTheme: IconThemeData(color: palette.textPrimary),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? palette.primary : palette.textPrimary,
        contentTextStyle: TextStyle(
          color: isDark ? palette.background : Colors.white,
          fontWeight: FontWeight.w500,
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        ),
        insetPadding: const EdgeInsets.all(16),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusXL),
        ),
        titleTextStyle: TextStyle(
          color: palette.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        contentTextStyle: TextStyle(
          color: palette.textSecondary,
          fontSize: 14,
          height: 1.5,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimens.radiusXXL),
          ),
        ),
        showDragHandle: true,
        dragHandleColor: palette.borderStrong,
        dragHandleSize: const Size(40, 4),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? palette.primary
              : palette.muted,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? palette.primary.withValues(alpha: 0.30)
              : palette.border,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? palette.primary
              : Colors.transparent,
        ),
        checkColor: WidgetStateProperty.all(
          isDark ? palette.background : Colors.white,
        ),
        side: BorderSide(color: palette.borderStrong, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: palette.primary,
        linearTrackColor: palette.border,
        circularTrackColor: palette.border,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: palette.primary,
        unselectedLabelColor: palette.muted,
        indicatorColor: palette.primary,
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        dividerColor: palette.border,
      ),
    );
  }
}
