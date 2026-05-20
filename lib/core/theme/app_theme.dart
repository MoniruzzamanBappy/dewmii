import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';

/// Centralized design tokens — use these instead of hard-coded values.
class AppDimens {
  AppDimens._();

  // Border radii
  static const double radiusXS = 6;
  static const double radiusSM = 10;
  static const double radiusMD = 14;
  static const double radiusLG = 18;
  static const double radiusXL = 24;
  static const double radiusXXL = 32;
  static const double radiusFull = 999;

  // Spacing
  static const double spaceXS = 4;
  static const double spaceSM = 8;
  static const double spaceMD = 16;
  static const double spaceLG = 24;
  static const double spaceXL = 32;
  static const double spaceXXL = 48;

  // Component heights
  static const double buttonHeight = 54;
  static const double inputHeight = 54;
  static const double appBarHeight = 60;
  static const double bottomNavHeight = 76;
  static const double cardElevation = 0;
}

class AppTheme {
  AppTheme._();

  // ─── Shared helpers ─────────────────────────────────────────────────────────

  static InputDecorationTheme _inputTheme({
    required Color fill,
    required Color border,
    required Color focused,
    required Color hint,
  }) => InputDecorationTheme(
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

  static ButtonStyle _elevatedStyle({
    required Color bg,
    required Color fg,
    required Color disabledBg,
    required Color disabledFg,
  }) => ElevatedButton.styleFrom(
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

  // ─── Light Theme ────────────────────────────────────────────────────────────

  static ThemeData get lightTheme {
    final cs =
        ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ).copyWith(
          primary: AppColors.primary,
          onPrimary: Colors.white,
          primaryContainer: AppColors.palette01,
          onPrimaryContainer: AppColors.primaryDark,
          secondary: AppColors.secondary,
          onSecondary: AppColors.palette04,
          secondaryContainer: AppColors.palette03.withValues(alpha: 0.35),
          surface: AppColors.lightSurface,
          onSurface: AppColors.lightTextPrimary,
          surfaceContainerHighest: AppColors.lightSurfaceVariant,
          outline: AppColors.lightBorder,
          outlineVariant: AppColors.lightDivider,
          error: AppColors.error,
          onError: Colors.white,
          shadow: Colors.black.withValues(alpha: 0.08),
        );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: cs,
      scaffoldBackgroundColor: AppColors.lightBackground,

      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.lightBackground,
        foregroundColor: AppColors.lightTextPrimary,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: AppDimens.appBarHeight,
        titleTextStyle: const TextStyle(
          color: AppColors.lightTextPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.lightTextPrimary,
          size: 22,
        ),
        actionsIconTheme: const IconThemeData(
          color: AppColors.lightTextPrimary,
          size: 22,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),

      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: AppColors.lightTextPrimary,
          fontWeight: FontWeight.w900,
          letterSpacing: -1.5,
        ),
        displayMedium: TextStyle(
          color: AppColors.lightTextPrimary,
          fontWeight: FontWeight.w800,
          letterSpacing: -1.0,
        ),
        displaySmall: TextStyle(
          color: AppColors.lightTextPrimary,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
        headlineLarge: TextStyle(
          color: AppColors.lightTextPrimary,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          color: AppColors.lightTextPrimary,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
        headlineSmall: TextStyle(
          color: AppColors.lightTextPrimary,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: TextStyle(
          color: AppColors.lightTextPrimary,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        ),
        titleMedium: TextStyle(
          color: AppColors.lightTextPrimary,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          color: AppColors.lightTextPrimary,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
        bodyLarge: TextStyle(
          color: AppColors.lightTextPrimary,
          fontWeight: FontWeight.w400,
          height: 1.6,
        ),
        bodyMedium: TextStyle(color: AppColors.lightTextSecondary, height: 1.5),
        bodySmall: TextStyle(
          color: AppColors.lightTextSecondary,
          fontSize: 12,
          height: 1.4,
        ),
        labelLarge: TextStyle(
          color: AppColors.lightTextPrimary,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.1,
        ),
        labelMedium: TextStyle(
          color: AppColors.lightTextSecondary,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
        labelSmall: TextStyle(
          color: AppColors.lightTextTertiary,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),

      cardTheme: CardThemeData(
        color: AppColors.lightSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusLG),
          side: const BorderSide(color: AppColors.lightBorder, width: 1),
        ),
      ),

      inputDecorationTheme: _inputTheme(
        fill: AppColors.lightSurface,
        border: AppColors.lightBorder,
        focused: AppColors.primary,
        hint: AppColors.lightTextTertiary,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: _elevatedStyle(
          bg: AppColors.primary,
          fg: Colors.white,
          disabledBg: AppColors.palette02.withValues(alpha: 0.4),
          disabledFg: Colors.white60,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
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
          foregroundColor: AppColors.primary,
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
          foregroundColor: AppColors.lightTextPrimary,
          highlightColor: AppColors.primary.withValues(alpha: 0.08),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusSM),
          ),
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.lightSurfaceVariant,
        selectedColor: AppColors.primary.withValues(alpha: 0.15),
        labelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.lightTextPrimary,
        ),
        secondaryLabelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusFull),
          side: const BorderSide(color: AppColors.lightBorder),
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        height: AppDimens.bottomNavHeight,
        backgroundColor: AppColors.lightSurface,
        indicatorColor: AppColors.primary.withValues(alpha: 0.12),
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? AppColors.primary : AppColors.muted,
            letterSpacing: 0.2,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? AppColors.primary : AppColors.muted,
            size: 22,
          );
        }),
        shadowColor: Colors.black.withValues(alpha: 0.06),
        elevation: 0,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),

      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppDimens.spaceMD,
          vertical: 4,
        ),
        minLeadingWidth: 0,
        iconColor: AppColors.muted,
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.lightDivider,
        thickness: 1,
        space: 1,
      ),

      iconTheme: const IconThemeData(color: AppColors.lightTextPrimary),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.palette04,
        contentTextStyle: const TextStyle(
          color: Colors.white,
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
        backgroundColor: AppColors.lightSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusXL),
        ),
        titleTextStyle: const TextStyle(
          color: AppColors.lightTextPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        contentTextStyle: const TextStyle(
          color: AppColors.lightTextSecondary,
          fontSize: 14,
          height: 1.5,
        ),
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.lightSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimens.radiusXXL),
          ),
        ),
        showDragHandle: true,
        dragHandleColor: AppColors.lightBorderStrong,
        dragHandleSize: Size(40, 4),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? AppColors.primary
              : AppColors.muted,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? AppColors.primary.withValues(alpha: 0.3)
              : AppColors.lightBorder,
        ),
      ),

      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? AppColors.primary
              : Colors.transparent,
        ),
        checkColor: WidgetStateProperty.all(Colors.white),
        side: const BorderSide(color: AppColors.lightBorderStrong, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.lightBorder,
        circularTrackColor: AppColors.lightBorder,
      ),

      tabBarTheme: const TabBarThemeData(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.muted,
        indicatorColor: AppColors.primary,
        labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        unselectedLabelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        dividerColor: AppColors.lightBorder,
      ),
    );
  }

  // ─── Dark Theme ─────────────────────────────────────────────────────────────

  static ThemeData get darkTheme {
    final cs =
        ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
        ).copyWith(
          primary: AppColors.palette02,
          onPrimary: AppColors.palette04,
          primaryContainer: AppColors.darkSurfaceVariant,
          onPrimaryContainer: AppColors.palette02,
          secondary: AppColors.secondary,
          onSecondary: AppColors.palette04,
          surface: AppColors.darkSurface,
          onSurface: AppColors.darkTextPrimary,
          surfaceContainerHighest: AppColors.darkSurfaceVariant,
          outline: AppColors.darkBorder,
          outlineVariant: AppColors.darkDivider,
          error: AppColors.error,
          onError: Colors.white,
          shadow: Colors.black.withValues(alpha: 0.3),
        );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: cs,
      scaffoldBackgroundColor: AppColors.darkBackground,

      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.darkTextPrimary,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: AppDimens.appBarHeight,
        titleTextStyle: const TextStyle(
          color: AppColors.darkTextPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.darkTextPrimary,
          size: 22,
        ),
        actionsIconTheme: const IconThemeData(
          color: AppColors.darkTextPrimary,
          size: 22,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),

      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: AppColors.darkTextPrimary,
          fontWeight: FontWeight.w900,
          letterSpacing: -1.5,
        ),
        displayMedium: TextStyle(
          color: AppColors.darkTextPrimary,
          fontWeight: FontWeight.w800,
          letterSpacing: -1.0,
        ),
        displaySmall: TextStyle(
          color: AppColors.darkTextPrimary,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
        headlineLarge: TextStyle(
          color: AppColors.darkTextPrimary,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          color: AppColors.darkTextPrimary,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
        headlineSmall: TextStyle(
          color: AppColors.darkTextPrimary,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: TextStyle(
          color: AppColors.darkTextPrimary,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        ),
        titleMedium: TextStyle(
          color: AppColors.darkTextPrimary,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          color: AppColors.darkTextPrimary,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
        bodyLarge: TextStyle(
          color: AppColors.darkTextPrimary,
          fontWeight: FontWeight.w400,
          height: 1.6,
        ),
        bodyMedium: TextStyle(color: AppColors.darkTextSecondary, height: 1.5),
        bodySmall: TextStyle(
          color: AppColors.darkTextSecondary,
          fontSize: 12,
          height: 1.4,
        ),
        labelLarge: TextStyle(
          color: AppColors.darkTextPrimary,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.1,
        ),
        labelMedium: TextStyle(
          color: AppColors.darkTextSecondary,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
        labelSmall: TextStyle(
          color: AppColors.darkTextTertiary,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),

      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusLG),
          side: const BorderSide(color: AppColors.darkBorder, width: 1),
        ),
      ),

      inputDecorationTheme: _inputTheme(
        fill: AppColors.darkSurface,
        border: AppColors.darkBorder,
        focused: AppColors.palette02,
        hint: AppColors.darkTextSecondary,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: _elevatedStyle(
          bg: AppColors.palette02,
          fg: AppColors.palette04,
          disabledBg: AppColors.darkBorderStrong,
          disabledFg: AppColors.darkTextSecondary,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.palette02,
          side: const BorderSide(color: AppColors.palette02, width: 1.5),
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
          foregroundColor: AppColors.palette02,
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
          foregroundColor: AppColors.darkTextPrimary,
          highlightColor: AppColors.palette02.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusSM),
          ),
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkSurfaceVariant,
        selectedColor: AppColors.palette02.withValues(alpha: 0.2),
        labelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.darkTextPrimary,
        ),
        secondaryLabelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.palette02,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusFull),
          side: const BorderSide(color: AppColors.darkBorder),
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        height: AppDimens.bottomNavHeight,
        backgroundColor: AppColors.darkSurface,
        indicatorColor: AppColors.palette02.withValues(alpha: 0.15),
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? AppColors.palette02 : AppColors.darkTextSecondary,
            letterSpacing: 0.2,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? AppColors.palette02 : AppColors.darkTextSecondary,
            size: 22,
          );
        }),
        elevation: 0,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),

      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppDimens.spaceMD,
          vertical: 4,
        ),
        minLeadingWidth: 0,
        iconColor: AppColors.darkTextSecondary,
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.darkDivider,
        thickness: 1,
        space: 1,
      ),

      iconTheme: const IconThemeData(color: AppColors.darkTextPrimary),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.palette02,
        contentTextStyle: const TextStyle(
          color: AppColors.palette04,
          fontWeight: FontWeight.w600,
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        ),
        insetPadding: const EdgeInsets.all(16),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.darkSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusXL),
        ),
        titleTextStyle: const TextStyle(
          color: AppColors.darkTextPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        contentTextStyle: const TextStyle(
          color: AppColors.darkTextSecondary,
          fontSize: 14,
          height: 1.5,
        ),
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.darkSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimens.radiusXXL),
          ),
        ),
        showDragHandle: true,
        dragHandleColor: AppColors.darkBorderStrong,
        dragHandleSize: Size(40, 4),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? AppColors.palette02
              : AppColors.darkTextSecondary,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? AppColors.palette02.withValues(alpha: 0.35)
              : AppColors.darkBorder,
        ),
      ),

      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? AppColors.palette02
              : Colors.transparent,
        ),
        checkColor: WidgetStateProperty.all(AppColors.palette04),
        side: const BorderSide(color: AppColors.darkBorderStrong, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.palette02,
        linearTrackColor: AppColors.darkBorder,
        circularTrackColor: AppColors.darkBorder,
      ),

      tabBarTheme: const TabBarThemeData(
        labelColor: AppColors.palette02,
        unselectedLabelColor: AppColors.darkTextSecondary,
        indicatorColor: AppColors.palette02,
        labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        unselectedLabelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        dividerColor: AppColors.darkBorder,
      ),
    );
  }
}
