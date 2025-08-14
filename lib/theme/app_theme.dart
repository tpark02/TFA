import 'dart:io';
import 'package:TFA/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    final TextTheme baseTextTheme = Platform.isAndroid
        ? GoogleFonts.poppinsTextTheme()
        : Typography.material2021().black; // system font fallback

    return ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,
      textTheme: baseTextTheme.copyWith(
        displayLarge: baseTextTheme.displayLarge?.copyWith(fontSize: 32),
        displayMedium: baseTextTheme.displayMedium?.copyWith(fontSize: 28),
        displaySmall: baseTextTheme.displaySmall?.copyWith(fontSize: 24),
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(fontSize: 20),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(fontSize: 16),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(fontSize: 14),
        bodySmall: baseTextTheme.bodySmall?.copyWith(fontSize: 12),
      ),
    );
  }

  static ThemeData get darkTheme {
    final TextTheme baseTextTheme = Platform.isAndroid
        ? GoogleFonts.poppinsTextTheme()
        : Typography.material2021().white;

    return ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme,
      textTheme: baseTextTheme.copyWith(
        displayLarge: baseTextTheme.displayLarge?.copyWith(fontSize: 32),
        displayMedium: baseTextTheme.displayMedium?.copyWith(fontSize: 28),
        displaySmall: baseTextTheme.displaySmall?.copyWith(fontSize: 24),
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(fontSize: 20),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(fontSize: 16),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(fontSize: 14),
        bodySmall: baseTextTheme.bodySmall?.copyWith(fontSize: 12),
      ),
    );
  }
}
