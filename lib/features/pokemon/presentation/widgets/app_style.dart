import 'package:flutter/material.dart';

class AppStyle {
  static const Color mainColor = Colors.white;
  static const Color mainBackground = Color(0xFF0B0B0E);

  // static const Color primary = Color(0xFF2E7D32);
  // static const Color background = Color(0xFFE8F5E9);

  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color primaryDark = Color(0xFF4CAF50);

  static ThemeData theme = ThemeData.dark().copyWith(
    primaryColor: primaryDark,
    scaffoldBackgroundColor: backgroundDark,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryDark,
        foregroundColor: backgroundDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    ),
    // textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
  );
}
