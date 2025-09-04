import 'package:flutter/material.dart';

class Currency {
  final String name;
  final String code;
  final String symbol;
  const Currency({
    required this.name,
    required this.code,
    required this.symbol,
  });
}

class CurrencySelectorSheet extends StatelessWidget {
  final List<Currency> currencies;
  final String selectedCode;
  const CurrencySelectorSheet({super.key, 
    required this.currencies,
    required this.selectedCode,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    // Centered card-like popup
    return Dialog(
      elevation: 8,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420, maxHeight: 520),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // top padding like your screenshot (drag area look)
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: currencies.length,
                separatorBuilder: (_, __) =>
                    Divider(height: 0, color: Colors.grey.shade200),
                itemBuilder: (_, int i) {
                  final Currency c = currencies[i];
                  final bool selected = c.code == selectedCode;
                  return ListTile(
                    title: Text(
                      c.name,
                      style: TextStyle(
                        color: selected ? theme.colorScheme.primary : null,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      '${c.symbol} (${c.code})',
                      style: TextStyle(
                        color: selected
                            ? theme.colorScheme.primary
                            : Colors.black54,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                    onTap: () => Navigator.of(context).pop(c),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
