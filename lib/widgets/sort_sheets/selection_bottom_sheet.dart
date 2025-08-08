import 'package:flutter/material.dart';

/// A generic selection bottom sheet with checkboxes and an optional "only" action per item.
/// Works with any data type T.
Future<void> showSelectionBottomSheet<T>({
  required BuildContext context,
  required String title,
  required List<T> items,
  required Set<T> selected,
  required String Function(T) labelOf,
  required void Function(Set<T> newSelection) onDone,
  bool showOnlyAction = true,
  double maxHeightFraction = 0.6,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
    ),
    builder: (_) {
      return _SelectionContent<T>(
        title: title,
        items: items,
        initialSelected: selected,
        labelOf: labelOf,
        onDone: onDone,
        showOnlyAction: showOnlyAction,
        maxHeightFraction: maxHeightFraction,
      );
    },
  );
}

class _SelectionContent<T> extends StatefulWidget {
  final String title;
  final List<T> items;
  final Set<T> initialSelected;
  final String Function(T) labelOf;
  final void Function(Set<T>) onDone;
  final bool showOnlyAction;
  final double maxHeightFraction;

  const _SelectionContent({
    required this.title,
    required this.items,
    required this.initialSelected,
    required this.labelOf,
    required this.onDone,
    required this.showOnlyAction,
    required this.maxHeightFraction,
  });

  @override
  State<_SelectionContent<T>> createState() => _SelectionContentState<T>();
}

class _SelectionContentState<T> extends State<_SelectionContent<T>> {
  late Set<T> _selected;

  @override
  void initState() {
    super.initState();
    _selected = {...widget.initialSelected};
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight =
        MediaQuery.of(context).size.height * widget.maxHeightFraction;

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 0, 0),
              child: Text(
                textAlign: TextAlign.left,
                widget.title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // const Divider(height: 1),
            Expanded(
              child: ListView.separated(
                itemCount: widget.items.length,
                separatorBuilder: (_, __) => const SizedBox.shrink(),
                itemBuilder: (context, index) {
                  final item = widget.items[index];
                  final label = widget.labelOf(item);
                  final isSelected = _selected.contains(item);

                  return ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    leading: Checkbox(
                      fillColor: WidgetStateProperty.all(Colors.transparent),
                      checkColor: Theme.of(context).colorScheme.primary,
                      shape: const CircleBorder(),
                      side: BorderSide.none,
                      value: isSelected,
                      onChanged: (v) {
                        setState(() {
                          if (v == true) {
                            _selected.add(item);
                          } else {
                            _selected.remove(item);
                          }
                        });
                      },
                    ),
                    title: Text(
                      label,
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    trailing: widget.showOnlyAction
                        ? InkWell(
                            onTap: () {
                              setState(() {
                                _selected
                                  ..clear()
                                  ..add(item);
                              });
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'only',
                                style: TextStyle(
                                  color: Colors.lightBlue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          )
                        : null,
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                    ),
                  ),
                  onPressed: () {
                    widget.onDone(_selected);
                    Navigator.pop(context);
                  },
                  child: const Text('Done'),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
