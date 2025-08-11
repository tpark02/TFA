import 'package:flutter/widgets.dart';

class RecentSearch {
  final String destination;
  final String tripDateRange;
  final List<Widget> icons;
  final String destinationCode;
  final int guests;
  final int rooms;
  final String kind;
  final String departCode;
  final String arrivalCode;
  final String departDate;
  final String returnDate;

  const RecentSearch({
    required this.destination,
    required this.tripDateRange,
    required this.icons,
    required this.destinationCode,
    required this.guests,
    required this.rooms,
    required this.kind,
    required this.departCode,
    required this.arrivalCode,
    required this.returnDate,
    required this.departDate,
  });

  @override
  String toString() {
    return 'RecentSearch(destination: $destination, '
        'tripDateRange: $tripDateRange, '
        'destinationCode: $destinationCode, '
        'guests: $guests, '
        'rooms: $rooms, '
        'kind: $kind, '
        'departCode: $departCode, '
        'arrivalCode: $arrivalCode, '
        'departDate: $departDate, '
        'arrivalDate: $returnDate)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecentSearch &&
          runtimeType == other.runtimeType &&
          destination == other.destination &&
          tripDateRange == other.tripDateRange &&
          destinationCode == other.destinationCode &&
          guests == other.guests &&
          rooms == other.rooms &&
          kind == other.kind &&
          departCode == other.departCode &&
          arrivalCode == other.arrivalCode &&
          departDate == other.departDate &&
          returnDate == other.returnDate;

  @override
  int get hashCode =>
      destination.hashCode ^
      tripDateRange.hashCode ^
      destinationCode.hashCode ^
      guests.hashCode ^
      rooms.hashCode ^
      kind.hashCode ^
      departCode.hashCode ^
      arrivalCode.hashCode ^
      departDate.hashCode ^
      returnDate.hashCode;
}
