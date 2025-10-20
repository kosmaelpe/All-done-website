import 'package:flutter/material.dart';

ThemeData buildPastelTheme() {
  const seed = Color(0xFFAED6F1); // soft pastel blue
  final colorScheme = ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.light).copyWith(
    primary: const Color(0xFF9AD0EC),
    secondary: const Color(0xFFF7C8E0),
    tertiary: const Color(0xFFB8E0D2),
    surface: const Color(0xFFFFF9F4),
  );

  return ThemeData(
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colorScheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.primary,
      foregroundColor: Colors.black87,
      elevation: 0,
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.secondary,
        foregroundColor: Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
