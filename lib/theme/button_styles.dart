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
      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    );

/// Common bold text style
TextStyle boldBodyTextStyle(BuildContext context) => TextStyle(
  fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
  fontWeight: FontWeight.bold,
);

ButtonStyle flatSegmentStyle(BuildContext ctx) => TextButton.styleFrom(
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  alignment: Alignment.centerLeft,
  foregroundColor: Theme.of(ctx).colorScheme.primary,
  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
  minimumSize: Size.zero,
  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
);
