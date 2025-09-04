import 'package:flutter/material.dart';

typedef LabelOf<T> = String Function(T item);

Future<void> showSelectionBottomSheet<T>({
  required BuildContext context,
  required String title,
  required List<T> items,
  required Set<T> selected,
  required LabelOf<T> labelOf,
  required void Function(Set<T> newSelection) onDone,
  bool showOnlyAction = true,
  Widget Function(T item)? trailingOf,
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
        trailingOf: trailingOf,
      );
    },
  );
}

class _SelectionContent<T> extends StatefulWidget {
  const _SelectionContent({
    required this.title,
    required this.items,
    required this.initialSelected,
    required this.labelOf,
    required this.onDone,
    required this.showOnlyAction,
    required this.trailingOf,
  });

  final String title;
  final List<T> items;
  final Set<T> initialSelected;
  final LabelOf<T> labelOf;
  final void Function(Set<T>) onDone;
  final bool showOnlyAction;
  final Widget Function(T item)? trailingOf;

  @override
  State<_SelectionContent<T>> createState() => _SelectionContentState<T>();
}

class _SelectionContentState<T> extends State<_SelectionContent<T>> {
  late Set<T> _selected;

  @override
  void initState() {
    super.initState();
    _selected = <T>{...widget.initialSelected};
  }

  void _toggle(T item, bool checked, bool isOnlyClicked) {
    setState(() {
      if (isOnlyClicked) {
        _selected
          ..clear()
          ..add(item);
      } else {
        if (checked) {
          _selected.add(item);
        } else {
          _selected.remove(item);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double h = MediaQuery.of(context).size.height;
    final double maxHeight = widget.trailingOf == null ? h * 0.6 : h * 0.5;

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 0, 0),
              child: Text(
                widget.title,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                itemCount: widget.items.length,
                separatorBuilder: (_, __) => const SizedBox.shrink(),
                itemBuilder: (BuildContext context, int index) {
                  final item = widget.items[index];
                  final String label = widget.labelOf(item);
                  final bool isSelected = _selected.contains(item);

                  return ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    leading: Checkbox(
                      fillColor: WidgetStateProperty.all(Colors.transparent),
                      checkColor: Theme.of(context).colorScheme.primary,
                      shape: const CircleBorder(),
                      side: BorderSide.none,
                      value: isSelected,
                      onChanged: (bool? v) => _toggle(item, v ?? false, false),
                    ),
                    title: Text(
                      label,
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w300,
                        fontSize: 16,
                      ),
                    ),
                    trailing: widget.trailingOf != null
                        ? widget.trailingOf!(item)
                        : (widget.showOnlyAction
                            ? InkWell(
                                onTap: () => _toggle(item, true, true),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    'only',
                                    style: TextStyle(
                                      color: Colors.lightBlue,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              )
                            : null),
                    onTap: () => _toggle(item, !isSelected, false),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48),
                    shape: const RoundedRectangleBorder(
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
