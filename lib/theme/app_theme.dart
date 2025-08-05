// lib/theme/app_theme.dart
import 'package:TFA/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      displayLarge: TextStyle(fontSize: 32),
      displayMedium: TextStyle(fontSize: 28),
      displaySmall: TextStyle(fontSize: 24),
      headlineMedium: TextStyle(fontSize: 20),
      bodyLarge: TextStyle(fontSize: 16),
      bodyMedium: TextStyle(fontSize: 14),
      bodySmall: TextStyle(fontSize: 12),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: darkColorScheme,
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      displayLarge: TextStyle(fontSize: 32),
      displayMedium: TextStyle(fontSize: 28),
      displaySmall: TextStyle(fontSize: 24),
      headlineMedium: TextStyle(fontSize: 20),
      bodyLarge: TextStyle(fontSize: 16),
      bodyMedium: TextStyle(fontSize: 14),
      bodySmall: TextStyle(fontSize: 12),
    ),
  );
}
