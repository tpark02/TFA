import 'package:flutter/widgets.dart';

class RecentSearch {
  final String destination;
  final String tripDateRange;
  final List<Widget> icons;
  final String destinationCode;
  final int passengerCnt;
  final int rooms;
  final String kind;
  final String departCode;
  final String arrivalCode;
  final String departDate;
  final String returnDate;
  final int adult;
  final int children;
  final int infantLap;
  final int infantSeat;
  final int cabinIdx;

  const RecentSearch({
    required this.destination,
    required this.tripDateRange,
    required this.icons,
    required this.destinationCode,
    required this.passengerCnt,
    required this.rooms,
    required this.kind,
    required this.departCode,
    required this.arrivalCode,
    required this.returnDate,
    required this.departDate,
    this.adult = 1,
    this.children = 0,
    this.infantLap = 0,
    this.infantSeat = 0,
    this.cabinIdx = 0,
  });

  @override
  String toString() {
    return 'RecentSearch(destination: $destination, '
        'tripDateRange: $tripDateRange, '
        'destinationCode: $destinationCode, '
        'guests: $passengerCnt, '
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
          passengerCnt == other.passengerCnt &&
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
      passengerCnt.hashCode ^
      rooms.hashCode ^
      kind.hashCode ^
      departCode.hashCode ^
      arrivalCode.hashCode ^
      departDate.hashCode ^
      returnDate.hashCode;
}
