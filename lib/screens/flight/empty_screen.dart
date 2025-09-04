import 'package:TFA/providers/menu_tab_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmptyScreen extends ConsumerWidget {
  const EmptyScreen({super.key, required this.msg, required this.showButton});
  final String msg;
  final bool showButton;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double width = MediaQuery.of(context).size.width;
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

    return Container(
      color: cs.surface,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.image_outlined, size: 96, color: cs.outlineVariant),
              const SizedBox(height: 24),
              Text(
                msg,
                textAlign: TextAlign.center,
                style: tt.titleMedium?.copyWith(
                  height: 1.35,
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: 24),
              if (showButton) ...<Widget>[
                SizedBox(
                  width: width * 0.8,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: cs.onPrimary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        ref.read(menuTabProvider.notifier).state =
                            MenuTab.search;
                      });
                    },
                    child: Text(
                      'Search for a flight',
                      style: tt.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: cs.onPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
