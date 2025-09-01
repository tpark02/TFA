import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:TFA/models/anywhere_destination.dart';

class _ThumbFallback extends ConsumerWidget {
  const _ThumbFallback();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.black12,
      alignment: Alignment.center,
      child: const Icon(Icons.public, size: 28, color: Colors.black38),
    );
  }
}

class AnywhereDestinationTile extends ConsumerWidget {
  const AnywhereDestinationTile({super.key, required this.item, this.onTap});
  static double pictureDimension = 100;
  static double picturePadding = 8;
  static double height = pictureDimension + (2 * picturePadding) + 1;
  final AnywhereDestination item;
  final VoidCallback? onTap;

  String _krw(int v) => '₩${NumberFormat('#,###', 'ko_KR').format(v)}';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final onSurface = cs.onSurface;

    return InkWell(
      borderRadius: BorderRadius.circular(0),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cs.primaryContainer,
          borderRadius: BorderRadius.circular(4),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              blurRadius: 8,
              offset: Offset(0, 2),
              color: Color(0x14000000),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            SizedBox.square(
              dimension: pictureDimension,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  bottomLeft: Radius.circular(4),
                ),
                child: SizedBox(
                  width: 200, // give finite constraints
                  height: 150,
                  child: Image.network(
                    item.imageUrl,
                    fit: BoxFit.cover,
                    frameBuilder:
                        (context, child, frame, wasSynchronouslyLoaded) {
                          if (wasSynchronouslyLoaded)
                            return child; // cached: show immediately
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              Container(
                                color: cs.onPrimaryContainer,
                              ), // placeholder bg
                              const Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.4,
                                  ),
                                ),
                              ),
                              AnimatedOpacity(
                                opacity: frame == null ? 0.0 : 1.0,
                                duration: const Duration(milliseconds: 200),
                                child:
                                    child, // fade in when the first frame arrives
                              ),
                            ],
                          );
                        },
                    errorBuilder: (_, __, ___) =>
                        const Center(child: Icon(Icons.image_not_supported)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              fit: FlexFit.loose,
              child: Padding(
                padding: EdgeInsets.all(picturePadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          item.name,
                          textAlign: TextAlign.start,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: cs.onSecondaryContainer,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: cs.secondaryContainer,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'FROM ${_krw(item.minPriceKrw)}',
                            style: TextStyle(
                              color: cs.onSecondaryContainer,
                              fontWeight: FontWeight.w800,
                              fontSize: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.fontSize,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
