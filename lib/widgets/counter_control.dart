import 'package:flutter/material.dart';

class CounterControl extends StatefulWidget {
  const CounterControl({
    super.key,
    required this.count,
    this.onChanged,
    this.min = 0,
    this.max,
    this.size = 32, // diameter of the circular buttons
  });

  final int count;
  final ValueChanged<int>? onChanged;
  final int min; // lowest allowed value (inclusive)
  final int? max; // highest allowed value (inclusive), null = no cap
  final double size; // button diameter

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
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

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
    final cs = Theme.of(context).colorScheme;
    final double d = widget.size;

    // background uses surface containers for subtle elevation in both themes
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
          child: Icon(
            icon,
            size: d * 0.55, // scale icon with button size
            color: enabled ? fg : disabledFg,
          ),
        ),
      ),
    );
  }
}
