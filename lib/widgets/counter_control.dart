import 'package:flutter/material.dart';

class CounterControl extends StatefulWidget {
  const CounterControl({
    super.key,
    required this.count,
    this.onChanged,
    this.min = 0,
    this.max,
    this.size = 32,
  });

  final int count;
  final ValueChanged<int>? onChanged;
  final int min;
  final int? max;
  final double size;

  @override
  State<CounterControl> createState() => _CounterControlState();
}

class _CounterControlState extends State<CounterControl> {
  late int _count;

  bool get _canDec => _count > widget.min;
  bool get _canInc => widget.max == null ? true : _count < widget.max!;

  @override
  void initState() {
    super.initState();
    _count = widget.count.clamp(widget.min, widget.max ?? 1 << 30);
  }

  void _increment() {
    if (!_canInc) return;
    setState(() => _count++);
    widget.onChanged?.call(_count);
  }

  void _decrement() {
    if (!_canDec) return;
    setState(() => _count--);
    widget.onChanged?.call(_count);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _circleButton(
          context: context,
          icon: Icons.remove,
          onPressed: _decrement,
          enabled: _canDec,
        ),
        const SizedBox(width: 12),
        Text('$_count', style: tt.bodyMedium?.copyWith(color: cs.onSurface)),
        const SizedBox(width: 12),
        _circleButton(
          context: context,
          icon: Icons.add,
          onPressed: _increment,
          enabled: _canInc,
          isPrimary: true,
        ),
      ],
    );
  }

  Widget _circleButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback onPressed,
    bool enabled = true,
    bool isPrimary = false,
  }) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final double d = widget.size;
    final Color bg = isPrimary
        ? cs.primaryContainer
        : cs.surfaceContainerHighest;
    final Color fg = isPrimary ? cs.onPrimaryContainer : cs.onSurface;
    final Color disabledFg = cs.onSurface.withValues(alpha: 0.38);
    final Color disabledBg = cs.surfaceContainerHigh;

    return Material(
      color: enabled ? bg : disabledBg,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: enabled ? onPressed : null,
        child: SizedBox(
          width: d,
          height: d,
          child: Icon(icon, size: d * 0.55, color: enabled ? fg : disabledFg),
        ),
      ),
    );
  }
}
