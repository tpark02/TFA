import 'package:flutter/material.dart';

const ColorScheme lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF002D6B), // 🔵 Deep Blue
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFF90CAF9), // lighter blue
  onPrimaryContainer: Color(0xFF1565C0),

  // 🟦 Secondary: Light Blue Accent (matches primary nicely)
  secondary: Color(0xFF64B5F6), // Light Blue 300
  onSecondary: Color(0xFF0D47A1),
  secondaryContainer: Color(0xFFBBDEFB),
  onSecondaryContainer: Color(0xFF00274D),

  error: Color(0xFFB3261E),
  onError: Color(0xFFFFFFFF),
  errorContainer: Color(0xFFF9DEDC),
  onErrorContainer: Color(0xFF410E0B),

  surface: Color(0xFFFFFFFF),
  onSurface: Color(0xFF1D1F1E),
);

const ColorScheme darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF1565C0), // 🔵 Deep Blue
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFF0D47A1), // darker tone
  onPrimaryContainer: Color(0xFFE3F2FD),

  secondary: Color(0xFF8BA59A),
  onSecondary: Color(0xFF22302B),
  secondaryContainer: Color(0xFFA8BFB4),
  onSecondaryContainer: Color(0xFF0D1412),

  error: Color(0xFFF2B8B5),
  onError: Color(0xFF601410),
  errorContainer: Color(0xFF8C1D18),
  onErrorContainer: Color(0xFFF9DEDC),

  surface: Color(0xFF1D1F1E),
  onSurface: Color(0xFFE3E6E4),
);

const Color primaryFontColor = Colors.black87;
Color secondaryFontColor = Colors.grey.shade700;
const Color appBackgroundColor = Colors.white;
const Color appGreyColor = Color(0xFFF7F8FB);
