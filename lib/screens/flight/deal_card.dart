import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:TFA/providers/menu_tab_provider.dart';
import 'package:TFA/providers/flight/flight_search_controller.dart';

class DealCard extends ConsumerWidget {
  const DealCard({
    super.key,
    required this.title,
    required this.date,
    required this.imageUrl,
    required this.originalPrice,
    required this.discountPrice,
    required this.seed,
    this.width = 200,
    this.height = 150,
  });

  final String title;
  final String date;
  final String imageUrl; // optional external image; falls back to picsum seed
  final String originalPrice;
  final String discountPrice;
  final String seed;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;

    return TextButton(
      onPressed: () {
        // set destination then switch to Search tab
        ref.read(flightSearchProvider.notifier).setArrivalCode(seed, title);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(menuTabProvider.notifier).state = MenuTab.search;
        });
      },
      child: Material(
        color: cs.surface,
        elevation: 5,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  width: width,
                  height: height,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      imageUrl.isNotEmpty
                          ? imageUrl
                          : 'https://picsum.photos/seed/$seed/200/150',
                      fit: BoxFit.cover,
                      frameBuilder:
                          (context, child, frame, wasSynchronouslyLoaded) {
                            if (wasSynchronouslyLoaded) return child; // cached
                            return Stack(
                              fit: StackFit.expand,
                              children: [
                                Container(color: Colors.black12), // placeholder
                                const Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.2,
                                    ),
                                  ),
                                ),
                                AnimatedOpacity(
                                  opacity: frame == null ? 0.0 : 1.0,
                                  duration: const Duration(milliseconds: 200),
                                  child: child, // fade in on first frame
                                ),
                              ],
                            );
                          },
                      errorBuilder: (_, __, ___) =>
                          const Center(child: Icon(Icons.image_not_supported)),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: cs.primary,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.transparent, width: 1),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          spreadRadius: 1,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    child: Text(
                      title,
                      style: TextStyle(
                        color: cs.surface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.transparent, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: cs.errorContainer,
                          blurRadius: 8,
                          spreadRadius: 1,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 0,
                    ),
                    child: Text(
                      '$originalPrice → $discountPrice',
                      style: TextStyle(
                        fontSize: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.fontSize,
                        fontWeight: FontWeight.bold,
                        color: cs.surface,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
