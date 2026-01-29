import 'package:flutter/material.dart';
import 'package:jagoentertainment/src/core/constants/app_colors.dart';
import 'package:jagoentertainment/src/core/constants/app_textstyles.dart';

class AppThemes {

  // ────── LIGHT THEME ──────
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.baseWhite,
    primaryColor: AppColors.brand,

    colorScheme: const ColorScheme.light(
      primary: AppColors.brand,
      secondary: AppColors.cyan400,
      background: AppColors.baseWhite,
      surface: AppColors.baseWhite,
      onPrimary: AppColors.baseWhite,
      onSecondary: AppColors.baseWhite,
      onBackground: AppColors.baseBlack,
      onSurface: AppColors.baseBlack,
    ),

    // ───── Bottom Navigation Bar Theme (LIGHT) ─────
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.baseWhite,
      selectedItemColor: AppColors.brand,
      unselectedItemColor: AppColors.zinc600,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedLabelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
      type: BottomNavigationBarType.fixed,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.baseWhite,
      foregroundColor: AppColors.baseBlack,
      elevation: 0,
    ),

    textTheme: TextTheme(
      displayLarge: text4XLSemiBold.copyWith(color: AppColors.baseBlack),
      displayMedium: text3XLSemiBold.copyWith(color: AppColors.baseBlack),
      displaySmall: text2XLSemiBold.copyWith(color: AppColors.baseBlack),
      headlineMedium: textLGExtraBold.copyWith(color: AppColors.baseBlack),
      headlineSmall: textLGBold.copyWith(color: AppColors.baseBlack),
      titleLarge: textBaseSemiBold.copyWith(color: AppColors.baseBlack),
      titleMedium: textSMRegular.copyWith(color: AppColors.baseBlack),
      bodyLarge: textBaseRegular.copyWith(color: AppColors.baseBlack),
      bodyMedium: textSMRegular.copyWith(color: AppColors.baseBlack),
      bodySmall: textSMSemiBold.copyWith(color: AppColors.baseBlack),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.brand,
        foregroundColor: AppColors.baseWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.gray100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
  );

  // ────── DARK THEME ──────
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.baseBlack,
    primaryColor: AppColors.brand,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.brand,
      secondary: AppColors.cyan400,
      background: AppColors.baseBlack,
      surface: AppColors.zinc800,
      onPrimary: AppColors.baseWhite,
      onSecondary: AppColors.baseWhite,
      onBackground: AppColors.baseWhite,
      onSurface: AppColors.baseWhite,
    ),

    // ───── Bottom Navigation Bar Theme (DARK) ─────
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.zinc900,
      selectedItemColor: AppColors.brand,
      unselectedItemColor: AppColors.zinc400,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedLabelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
      type: BottomNavigationBarType.fixed,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.zinc900,
      foregroundColor: AppColors.baseWhite,
      elevation: 0,
    ),

    textTheme: TextTheme(
      displayLarge: text4XLSemiBold.copyWith(color: AppColors.baseWhite),
      displayMedium: text3XLSemiBold.copyWith(color: AppColors.baseWhite),
      displaySmall: text2XLSemiBold.copyWith(color: AppColors.baseWhite),
      headlineMedium: textLGExtraBold.copyWith(color: AppColors.baseWhite),
      headlineSmall: textLGBold.copyWith(color: AppColors.baseWhite),
      titleLarge: textBaseSemiBold.copyWith(color: AppColors.baseWhite),
      titleMedium: textSMRegular.copyWith(color: AppColors.baseWhite),
      bodyLarge: textBaseRegular.copyWith(color: AppColors.baseWhite),
      bodyMedium: textSMRegular.copyWith(color: AppColors.baseWhite),
      bodySmall: textSMSemiBold.copyWith(color: AppColors.baseWhite),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.brand,
        foregroundColor: AppColors.baseWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.zinc800,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
