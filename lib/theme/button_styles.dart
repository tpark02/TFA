import 'package:flutter/material.dart';

ButtonStyle primaryButtonStyle(BuildContext context) =>
    OutlinedButton.styleFrom(
      side: BorderSide.none,
      foregroundColor: Theme.of(context).colorScheme.primary,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    );

ButtonStyle outlinedButtonStyle(BuildContext context) =>
    OutlinedButton.styleFrom(
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      side: const BorderSide(color: Colors.transparent, width: 1),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    );

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
