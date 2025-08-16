// lib/widgets/dotted_divider.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';

class DottedDivider extends StatelessWidget {
  const DottedDivider({
    super.key,
    this.thickness = 2, // dot thickness
    this.dashLength = 2, // length of each “dot” (very short => dot-like)
    this.dashGap = 6, // gap between dots
    this.color,
  });

  final double thickness;
  final double dashLength;
  final double dashGap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: thickness, // 🟢 ensures bounded height
      width: double.infinity,
      child: CustomPaint(
        painter: _DashedPainter(
          color ?? Colors.grey.shade400,
          thickness,
          dashLength,
          dashGap,
        ),
      ),
    );
  }
}

class _DashedPainter extends CustomPainter {
  _DashedPainter(this.color, this.thickness, this.dash, this.gap);

  final Color color;
  final double thickness;
  final double dash;
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round; // 🟢 rounded “dots” like the screenshot

    final double y = size.height / 2;
    double x = 0;
    while (x < size.width) {
      final double x2 = math.min(x + dash, size.width);
      canvas.drawLine(Offset(x, y), Offset(x2, y), paint);
      x += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedPainter old) =>
      old.color != color ||
      old.thickness != thickness ||
      old.dash != dash ||
      old.gap != gap;
}
