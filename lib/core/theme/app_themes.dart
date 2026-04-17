import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:login_demo/core/configs/app_configs.dart';
import 'package:login_demo/core/theme/text_style.dart';

import 'app_colors.dart';

class AppThemes {
  static const _font = AppConfigs.fontFamily;
  bool isDarkMode;
  Brightness brightness;
  Color primaryColor;
  Color secondaryColor;
  AppThemes({
    this.isDarkMode = false,
    this.primaryColor = AppColors.primary,
    this.secondaryColor = AppColors.secondary,
  }) : brightness = isDarkMode ? Brightness.dark : Brightness.light;
  Color get backgroundColor =>
      isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight;

  TextTheme get textTheme {
    final textColor = isDarkMode ? Colors.white : AppColors.textBlack;
    return TextTheme(
      displayLarge: TextStyle(fontSize: 96.0, color: textColor),
      displayMedium: TextStyle(fontSize: 60.0, color: textColor),
      displaySmall: TextStyle(fontSize: 48.0, color: textColor),
      headlineMedium: TextStyle(fontSize: 34.0, color: textColor),
      headlineSmall: TextStyle(fontSize: 24.0, color: textColor),
      titleLarge: TextStyle(
        fontSize: 20.0,
        color: textColor,
        fontWeight: FontWeight.w500,
      ),
      titleMedium: TextStyle(fontSize: 16.0, color: textColor),
      titleSmall: TextStyle(
        fontSize: 14.0,
        color: textColor,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(fontSize: 16.0, color: textColor),
      bodyMedium: TextStyle(fontSize: 14.0, color: textColor),
      bodySmall: TextStyle(fontSize: 12.0, color: textColor),
      labelLarge: TextStyle(
        fontSize: 14.0,
        color: textColor,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: TextStyle(fontSize: 14.0, color: textColor),
    );
  }

  ThemeData get theme {
    return ThemeData(
      brightness: brightness,
      primaryColor: primaryColor,
      fontFamily: _font,
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor,
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        titleTextStyle: isDarkMode
            ? AppTextStyle.white.s18.bold
            : AppTextStyle.black.s18.bold,
      ),
      tabBarTheme: TabBarThemeData(
        unselectedLabelColor: isDarkMode ? Colors.white : Colors.black,
        labelColor: Colors.white,
      ),
      iconTheme: IconThemeData(color: primaryColor),
      textTheme: textTheme,
    );
  }
}
