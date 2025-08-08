import 'package:flutter/material.dart';

typedef LabelFormatter = String Function(int value);

class RangePickerSheet extends StatefulWidget {
  final String title;
  final double min;
  final double max;
  final RangeValues initial;
  final int? divisions; // null = smooth
  final LabelFormatter label; // how to show values
  final Color? primaryColor;
  final String confirmText;
  // final String cancelText;
  final ValueChanged<RangeValues> onConfirmed;

  const RangePickerSheet({
    super.key,
    required this.title,
    required this.min,
    required this.max,
    required this.initial,
    required this.label,
    required this.onConfirmed,
    this.divisions,
    this.primaryColor,
    this.confirmText = 'Done',
    // this.cancelText = 'Cancel',
  }) : assert(min < max);

  @override
  State<RangePickerSheet> createState() => _RangePickerSheetState();
}

class _RangePickerSheetState extends State<RangePickerSheet> {
  late RangeValues _values;

  @override
  void initState() {
    super.initState();
    final clampedStart = _clamp(widget.initial.start, widget.min, widget.max);
    final clampedEnd = _clamp(widget.initial.end, widget.min, widget.max);
    _values = RangeValues(
      clampedStart <= clampedEnd ? clampedStart : clampedEnd,
      clampedEnd >= clampedStart ? clampedEnd : clampedStart,
    );
  }

  static double _clamp(double v, double min, double max) =>
      v < min ? min : (v > max ? max : v);

  @override
  Widget build(BuildContext context) {
    final primary =
        widget.primaryColor ?? Theme.of(context).colorScheme.primary;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 12, 0, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: primary,
                  ),
                ),
              ),
            ),
            // const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.label(_values.start.toInt())),
                  Text(widget.label(_values.end.toInt())),
                ],
              ),
            ),
            RangeSlider(
              min: widget.min,
              max: widget.max,
              values: _values,
              divisions: widget.divisions,
              labels: RangeLabels(
                widget.label(_values.start.toInt()),
                widget.label(_values.end.toInt()),
              ),
              onChanged: (v) => setState(() => _values = v),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      onPressed: () {
                        widget.onConfirmed(_values);
                        Navigator.pop(context);
                      },
                      child: Text(widget.confirmText),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper to open as a modal bottom sheet
Future<void> showRangePickerSheet({
  required BuildContext context,
  required RangePickerSheet sheet,
}) {
  return showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
    ),
    builder: (_) => sheet,
  );
}
