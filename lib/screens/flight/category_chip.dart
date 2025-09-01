import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:TFA/providers/menu_tab_provider.dart';
import 'package:TFA/providers/flight/flight_search_controller.dart';

class CategoryChip extends ConsumerWidget {
  const CategoryChip({
    super.key,
    required this.label,
    required this.iata,
    this.width = 72,
    this.radius = 28,
  });

  final String label;
  final String iata;
  final double width;
  final double radius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final diameter = radius * 2;

    return InkWell(
      onTap: () {
        // set destination and switch to Search tab
        ref.read(flightSearchProvider.notifier).setArrivalCode(iata, label);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(menuTabProvider.notifier).state = MenuTab.search;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        width: width,
        child: Column(
          children: <Widget>[
            Material(
              color: cs.surface,
              elevation: 5,
              borderRadius: BorderRadius.circular(90),
              child: CircleAvatar(
                radius: radius,
                backgroundColor: cs.surfaceContainerHighest,
                child: ClipOval(
                  child: SizedBox(
                    width: diameter,
                    height: diameter,
                    child: Image.network(
                      'https://picsum.photos/seed/$label/100/100',
                      fit: BoxFit.cover,
                      // spinner until the first frame is painted
                      frameBuilder:
                          (context, child, frame, wasSynchronouslyLoaded) {
                            if (wasSynchronouslyLoaded) return child; // cached
                            return Stack(
                              fit: StackFit.expand,
                              children: [
                                const Center(
                                  child: SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.2,
                                    ),
                                  ),
                                ),
                                AnimatedOpacity(
                                  opacity: frame == null ? 0.0 : 1.0,
                                  duration: const Duration(milliseconds: 200),
                                  child: child,
                                ),
                              ],
                            );
                          },
                      errorBuilder: (_, __, ___) => const Icon(Icons.person),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
