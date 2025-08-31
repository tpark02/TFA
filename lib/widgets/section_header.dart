import 'package:flutter/material.dart';

class SectionHeader extends SliverPersistentHeaderDelegate {
  SectionHeader(this.title, {this.height = 44});
  final String title;
  final double height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final bool pinned = overlapsContent || shrinkOffset > 0;

    return Material(
      color: cs.surfaceContainerHigh,
      elevation: pinned ? 1 : 0,
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: cs.outlineVariant, width: 1),
          ),
        ),
        child: Text(
          title,
          style: tt.titleSmall?.copyWith(
            color: cs.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => 0;

  @override
  bool shouldRebuild(covariant SectionHeader oldDelegate) => false;
}
