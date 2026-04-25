// lib/core/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary Islamic Colors
  static const Color primaryGreen = Color(0xFF1B5E35);
  static const Color primaryGreenLight = Color(0xFF2E7D52);
  static const Color gold = Color(0xFFC9A84C);
  static const Color goldLight = Color(0xFFE8C97A);
  static const Color goldDark = Color(0xFF8A6D2E);

  // Dark Theme
  static const Color darkBg = Color(0xFF0A0F1A);
  static const Color darkSurface = Color(0xFF111827);
  static const Color darkCard = Color(0xFF1A2438);
  static const Color darkBorder = Color(0xFF1E2D45);
  static const Color darkText = Color(0xFFE8E0D0);
  static const Color darkTextMuted = Color(0xFF8A9AB5);

  // Light Theme
  static const Color lightBg = Color(0xFFF5F0E8);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFEDE8DC);
  static const Color lightBorder = Color(0xFFD4C9B0);
  static const Color lightText = Color(0xFF1A1208);
  static const Color lightTextMuted = Color(0xFF6B5E45);

  // Accent
  static const Color accentBlue = Color(0xFF1A3A5C);
  static const Color accentTeal = Color(0xFF0D5E6E);
  static const Color error = Color(0xFFB00020);
  static const Color success = Color(0xFF2E7D52);
}

class AppTheme {
  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.gold,
          secondary: AppColors.primaryGreen,
          surface: AppColors.darkSurface,
          background: AppColors.darkBg,
          onPrimary: AppColors.darkBg,
          onSecondary: Colors.white,
          onSurface: AppColors.darkText,
          onBackground: AppColors.darkText,
          error: AppColors.error,
        ),
        scaffoldBackgroundColor: AppColors.darkBg,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.darkSurface,
          foregroundColor: AppColors.gold,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: AppColors.gold,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Amiri',
          ),
        ),
        cardTheme: CardTheme(
          color: AppColors.darkCard,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.darkBorder, width: 1),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.darkSurface,
          selectedItemColor: AppColors.gold,
          unselectedItemColor: AppColors.darkTextMuted,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        textTheme: _buildTextTheme(AppColors.darkText, AppColors.darkTextMuted),
        dividerColor: AppColors.darkBorder,
        iconTheme: const IconThemeData(color: AppColors.gold),
      );

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primaryGreen,
          secondary: AppColors.gold,
          surface: AppColors.lightSurface,
          background: AppColors.lightBg,
          onPrimary: Colors.white,
          onSecondary: AppColors.darkBg,
          onSurface: AppColors.lightText,
          onBackground: AppColors.lightText,
          error: AppColors.error,
        ),
        scaffoldBackgroundColor: AppColors.lightBg,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Amiri',
          ),
        ),
        cardTheme: CardTheme(
          color: AppColors.lightCard,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.lightBorder, width: 1),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.lightSurface,
          selectedItemColor: AppColors.primaryGreen,
          unselectedItemColor: AppColors.lightTextMuted,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        textTheme: _buildTextTheme(AppColors.lightText, AppColors.lightTextMuted),
        dividerColor: AppColors.lightBorder,
        iconTheme: const IconThemeData(color: AppColors.primaryGreen),
      );

  static TextTheme _buildTextTheme(Color primary, Color secondary) => TextTheme(
        displayLarge: TextStyle(color: primary, fontFamily: 'Amiri', fontSize: 32, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: primary, fontFamily: 'Amiri', fontSize: 28, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(color: primary, fontFamily: 'Amiri', fontSize: 24),
        headlineLarge: TextStyle(color: primary, fontFamily: 'Amiri', fontSize: 22, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: primary, fontFamily: 'Amiri', fontSize: 20),
        headlineSmall: TextStyle(color: primary, fontFamily: 'Amiri', fontSize: 18),
        titleLarge: TextStyle(color: primary, fontFamily: 'Amiri', fontSize: 16, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: primary, fontSize: 14),
        titleSmall: TextStyle(color: secondary, fontSize: 12),
        bodyLarge: TextStyle(color: primary, fontSize: 16, height: 1.8),
        bodyMedium: TextStyle(color: primary, fontSize: 14, height: 1.6),
        bodySmall: TextStyle(color: secondary, fontSize: 12),
        labelLarge: TextStyle(color: primary, fontSize: 14, fontWeight: FontWeight.bold),
        labelMedium: TextStyle(color: secondary, fontSize: 12),
        labelSmall: TextStyle(color: secondary, fontSize: 10),
      );
}
