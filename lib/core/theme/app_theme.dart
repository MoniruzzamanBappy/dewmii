import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ).copyWith(
          primary: AppColors.primary,
          onPrimary: Colors.white,
          secondary: AppColors.secondary,
          onSecondary: AppColors.palette04,
          surface: AppColors.lightSurface,
          onSurface: AppColors.lightTextPrimary,
          error: AppColors.error,
          onError: Colors.white,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.lightBackground,
      fontFamily: null,

      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.lightBackground,
        foregroundColor: AppColors.lightTextPrimary,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: AppColors.lightTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(color: AppColors.lightTextPrimary),
      ),

      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: AppColors.lightTextPrimary,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: AppColors.lightTextPrimary,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: AppColors.lightTextPrimary,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: TextStyle(
          color: AppColors.lightTextPrimary,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: AppColors.lightTextPrimary,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          color: AppColors.lightTextPrimary,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: TextStyle(
          color: AppColors.lightTextPrimary,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: TextStyle(
          color: AppColors.lightTextPrimary,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          color: AppColors.lightTextPrimary,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(color: AppColors.lightTextPrimary),
        bodyMedium: TextStyle(color: AppColors.lightTextSecondary),
        bodySmall: TextStyle(color: AppColors.lightTextSecondary),
      ),

      cardTheme: CardThemeData(
        color: AppColors.lightSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.lightBorder),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSurface,
        hintStyle: const TextStyle(color: AppColors.lightTextSecondary),
        labelStyle: const TextStyle(color: AppColors.lightTextSecondary),
        prefixIconColor: AppColors.muted,
        suffixIconColor: AppColors.muted,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.palette02.withValues(alpha: 0.45),
          disabledForegroundColor: Colors.white70,
          minimumSize: const Size(double.infinity, 52),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          minimumSize: const Size(double.infinity, 52),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),

      iconTheme: const IconThemeData(color: AppColors.lightTextPrimary),

      dividerTheme: const DividerThemeData(
        color: AppColors.lightBorder,
        thickness: 1,
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.palette04,
        contentTextStyle: const TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.lightSurface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.muted,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }

  static ThemeData get darkTheme {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
        ).copyWith(
          primary: AppColors.palette02,
          onPrimary: AppColors.palette04,
          secondary: AppColors.secondary,
          onSecondary: AppColors.palette04,
          surface: AppColors.darkSurface,
          onSurface: AppColors.darkTextPrimary,
          error: AppColors.error,
          onError: Colors.white,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      primaryColor: AppColors.palette02,
      scaffoldBackgroundColor: AppColors.darkBackground,
      fontFamily: null,

      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.darkTextPrimary,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: AppColors.darkTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(color: AppColors.darkTextPrimary),
      ),

      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: AppColors.darkTextPrimary,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: AppColors.darkTextPrimary,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: AppColors.darkTextPrimary,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: TextStyle(
          color: AppColors.darkTextPrimary,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: AppColors.darkTextPrimary,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          color: AppColors.darkTextPrimary,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: TextStyle(
          color: AppColors.darkTextPrimary,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: TextStyle(
          color: AppColors.darkTextPrimary,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          color: AppColors.darkTextPrimary,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(color: AppColors.darkTextPrimary),
        bodyMedium: TextStyle(color: AppColors.darkTextSecondary),
        bodySmall: TextStyle(color: AppColors.darkTextSecondary),
      ),

      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.darkBorder),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurface,
        hintStyle: const TextStyle(color: AppColors.darkTextSecondary),
        labelStyle: const TextStyle(color: AppColors.darkTextSecondary),
        prefixIconColor: AppColors.darkTextSecondary,
        suffixIconColor: AppColors.darkTextSecondary,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.palette02, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.palette02,
          foregroundColor: AppColors.palette04,
          disabledBackgroundColor: AppColors.darkBorder,
          disabledForegroundColor: AppColors.darkTextSecondary,
          minimumSize: const Size(double.infinity, 52),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.palette02,
          side: const BorderSide(color: AppColors.palette02),
          minimumSize: const Size(double.infinity, 52),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.palette02,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),

      iconTheme: const IconThemeData(color: AppColors.darkTextPrimary),

      dividerTheme: const DividerThemeData(
        color: AppColors.darkBorder,
        thickness: 1,
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.palette02,
        contentTextStyle: const TextStyle(color: AppColors.palette04),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: AppColors.palette02,
        unselectedItemColor: AppColors.darkTextSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}
