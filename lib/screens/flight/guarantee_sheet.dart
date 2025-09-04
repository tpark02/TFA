import 'package:TFA/providers/menu_tab_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GuaranteeSheet extends ConsumerWidget {
  const GuaranteeSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8, // how tall it opens
      minChildSize: 0.6,
      maxChildSize: 0.95,
      builder: (_, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(alpha: .2),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Top drag handle
                Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Close button
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),

                // Shield icon
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: .1),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(Icons.shield, color: cs.primary, size: 28),
                ),
                const SizedBox(height: 16),

                // Title
                Text.rich(
                  const TextSpan(
                    children: <InlineSpan>[
                      TextSpan(
                        text: 'Guarantee',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: cs.primary,
                    fontSize: 26,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 16),

                // Description
                Text(
                  "Tickets get canceled. Routes get changed.\n"
                  "And sometimes, you're the one left stranded.\n"
                  "The Skiplagged Guarantee is built to give you\n"
                  "peace of mind, even when plans change.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: .7),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),

                // CTA Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {
                      ref.read(menuTabProvider.notifier).state = MenuTab.search;
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Search Flights',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AspectRatio(
                    aspectRatio: 16 / 10,
                    child: Image.network(
                      'https://images.unsplash.com/photo-1511735111819-9a3f7709049c?w=1200&q=80&auto=format&fit=crop',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey.shade200,
                        alignment: Alignment.center,
                        child: const Icon(Icons.image_not_supported_outlined),
                      ),
                      loadingBuilder: (BuildContext c, Widget child, ImageChunkEvent? prog) => prog == null
                          ? child
                          : Container(color: Colors.black12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
