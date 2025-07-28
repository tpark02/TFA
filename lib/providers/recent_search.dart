import 'package:flutter/widgets.dart';

class RecentSearch {
  final String destination;
  final String tripDateRange;
  final List<Widget> icons;
  final String destinationCode;

  const RecentSearch({
    required this.destination,
    required this.tripDateRange,
    required this.icons,
    required this.destinationCode,
  });

  @override
  String toString() {
    return 'RecentSearch(destination: $destination, '
        'tripDateRange: $tripDateRange, '
        'destinationCode: $destinationCode)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecentSearch &&
          runtimeType == other.runtimeType &&
          destination == other.destination &&
          tripDateRange == other.tripDateRange &&
          destinationCode == other.destinationCode;

  @override
  int get hashCode =>
      destination.hashCode ^ tripDateRange.hashCode ^ destinationCode.hashCode;
}
