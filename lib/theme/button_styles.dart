import 'package:flutter/material.dart';

/// Primary filled button style (no border)
ButtonStyle primaryButtonStyle(BuildContext context) =>
    OutlinedButton.styleFrom(
      side: BorderSide.none,
      foregroundColor: Theme.of(context).colorScheme.primary,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    );

/// Outlined button style
ButtonStyle outlinedButtonStyle(BuildContext context) =>
    OutlinedButton.styleFrom(
      side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    );

/// Common bold text style
TextStyle boldBodyTextStyle(BuildContext context) => TextStyle(
  fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
  fontWeight: FontWeight.bold,
);
