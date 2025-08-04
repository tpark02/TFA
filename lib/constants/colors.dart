import 'package:flutter/material.dart';

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,

  primary: Color(0xFF3E5B49), // Deep moss green
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFBBD2C4), // Soft sage green
  onPrimaryContainer: Color(0xFF1E3227),

  secondary: Color(0xFF6A8677), // Muted teal-green
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFDDE7E2),
  onSecondaryContainer: Color(0xFF2A3D35),

  error: Color(0xFFB3261E),
  onError: Color(0xFFFFFFFF),
  errorContainer: Color(0xFFF9DEDC),
  onErrorContainer: Color(0xFF410E0B),

  background: Color(0xFFF8FAF7), // Almost white with green hue
  onBackground: Color(0xFF1D1F1E),

  surface: Color(0xFFFFFFFF),
  onSurface: Color(0xFF1D1F1E),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,

  primary: Color(0xFF3E5B49), // Base deep green
  onPrimary: Color(0xFFDDE7E2),
  primaryContainer: Color(0xFF567463), // Mid-tone moss green
  onPrimaryContainer: Color(0xFFF0FAF4),

  secondary: Color(0xFF8BA59A), // Gentle minty tone
  onSecondary: Color(0xFF22302B),
  secondaryContainer: Color(0xFFA8BFB4),
  onSecondaryContainer: Color(0xFF0D1412),

  error: Color(0xFFF2B8B5),
  onError: Color(0xFF601410),
  errorContainer: Color(0xFF8C1D18),
  onErrorContainer: Color(0xFFF9DEDC),

  background: Color(0xFF141917), // Near-black green tone
  onBackground: Color(0xFFE3E6E4),

  surface: Color(0xFF1D1F1E),
  onSurface: Color(0xFFE3E6E4),
);
