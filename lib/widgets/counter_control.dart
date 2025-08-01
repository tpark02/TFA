import 'package:TFA/constants/font_size.dart';
import 'package:flutter/material.dart';

class CounterControl extends StatefulWidget {
  const CounterControl({super.key, required this.count, this.onChanged});
  final int count;
  final ValueChanged<int>? onChanged;

  @override
  State<CounterControl> createState() => _CounterControlState();
}

class _CounterControlState extends State<CounterControl> {
  late int _count;

  @override
  void initState() {
    super.initState();
    _count = widget.count;
  }

  void _increment() {
    setState(() {
      _count++;
      widget.onChanged?.call(_count);
    });
  }

  void _decrement() {
    if (_count > 0) {
      setState(() {
        _count--;
        widget.onChanged?.call(_count);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _circleButton(context, Icons.remove, _decrement, false),
        const SizedBox(width: 10),
        Text('$_count', style: const TextStyle(fontSize: kFontSize14)),
        const SizedBox(width: 10),
        _circleButton(context, Icons.add, _increment),
      ],
    );
  }

  Widget _circleButton(
    BuildContext context,
    IconData icon,
    VoidCallback onPressed, [
    bool isInc = true,
  ]) {
    return Container(
      width: 25,
      height: 25,
      decoration: const ShapeDecoration(
        color: Color(0xFFF0F0F0), // light grey background
        shape: CircleBorder(),
      ),
      child: IconButton(
        icon: Icon(icon, size: 14),
        padding: EdgeInsets.zero, // ← removes the default padding
        constraints: BoxConstraints(), // ← removes min size constraints
        color: isInc
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.secondary,
        onPressed: onPressed,
        splashRadius: 16,
      ),
    );
  }
}
