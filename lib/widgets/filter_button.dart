import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  final String label;
  final VoidCallback func;

  const FilterButton({super.key, required this.label, required this.func});

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(left: 8),
      child: OutlinedButton(
        onPressed: func,
        style:
            OutlinedButton.styleFrom(
              backgroundColor: cs.surface,
              minimumSize: const Size(0, 36),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              side: BorderSide(color: cs.outlineVariant, width: 1),
              foregroundColor: cs.onSurface,
            ).copyWith(
              overlayColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) => states.contains(WidgetState.pressed)
                    ? cs.primary.withValues(alpha: .08)
                    : states.contains(WidgetState.hovered)
                    ? cs.primary.withValues(alpha: .06)
                    : null,
              ),
            ),
        child: Text(
          label,
          style: tt.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: cs.onSurface,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
