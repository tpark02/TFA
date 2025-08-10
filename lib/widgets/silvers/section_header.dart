import 'package:flutter/material.dart';

class SectionHeader extends SliverPersistentHeaderDelegate {
  SectionHeader(this.title, {this.maxHeight = 44, this.minHeight = 0});
  final String title;
  final double maxHeight;
  final double minHeight; // << collapsed height

  @override
  Widget build(BuildContext c, double shrink, bool overlaps) {
    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: Theme.of(c).textTheme.bodyLarge?.fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight; // << set to 0 so previous headers disappear

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate old) => false;
}
