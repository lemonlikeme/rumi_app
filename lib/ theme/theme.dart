import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF9C27B0);      // Deep Purple
const Color secondaryColor = Color(0xFFFFC107);    // Amber
const Color backgroundLight = Colors.white;        // Light background
const Color backgroundDark = Color(0xFF121212);    // Dark background
const Color surfaceDark = Color(0xFF1E1E1E);        // Dark surface
const Color lavenderPrimaryDark = Color(0xFFCE93D8); // Lavender for dark mode

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: primaryColor,
    secondary: secondaryColor,
    surface: backgroundLight,
    onPrimary: Colors.white,
    onSurface: Colors.black,
  ),
  scaffoldBackgroundColor: backgroundLight,
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primary: lavenderPrimaryDark,
    secondary: secondaryColor,
    surface: surfaceDark,
    onPrimary: Colors.black,
    onSurface: Colors.white,
  ),
  scaffoldBackgroundColor: backgroundDark,
);
