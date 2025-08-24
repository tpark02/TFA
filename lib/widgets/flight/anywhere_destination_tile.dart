// lib/widgets/anywhere/anywhere_destination_tile.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:TFA/models/anywhere_destination.dart';

class _ThumbFallback extends StatelessWidget {
  const _ThumbFallback({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      alignment: Alignment.center,
      child: const Icon(Icons.public, size: 28, color: Colors.black38),
    );
  }
}

class AnywhereDestinationTile extends StatelessWidget {
  const AnywhereDestinationTile({super.key, required this.item, this.onTap});

  final AnywhereDestination item;
  final VoidCallback? onTap;

  String _krw(int v) => '₩${NumberFormat('#,###', 'ko_KR').format(v)}';

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).colorScheme.surface;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              blurRadius: 8,
              offset: Offset(0, 2),
              color: Color(0x14000000),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            SizedBox.square(
              dimension: 84,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  // shows a simple loader color while fetching
                  loadingBuilder:
                      (
                        BuildContext context,
                        Widget child,
                        ImageChunkEvent? progress,
                      ) {
                        if (progress == null) return child;
                        return Container(color: Colors.black12);
                      },
                  // graceful fallback if 404/timeout/etc
                  errorBuilder:
                      (BuildContext context, Object error, StackTrace? stack) =>
                          const _ThumbFallback(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'FROM ${_krw(item.minPriceKrw)}',
                style: TextStyle(
                  color: onSurface.withAlpha((0.9 * 255).toInt()),
                  fontWeight: FontWeight.w800,
                  fontSize: 12.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
