import 'package:flutter/material.dart';

class HotelSearchState {
  final String location;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final int guestCount;
  final int roomCount;
  final RangeValues priceRange;

  const HotelSearchState({
    this.location = '',
    this.checkInDate,
    this.checkOutDate,
    this.guestCount = 1,
    this.roomCount = 1,
    this.priceRange = const RangeValues(0, 1000),
  });

  HotelSearchState copyWith({
    String? location,
    DateTime? checkInDate,
    DateTime? checkOutDate,
    int? guestCount,
    int? roomCount,
    RangeValues? priceRange,
  }) {
    return HotelSearchState(
      location: location ?? this.location,
      checkInDate: checkInDate ?? this.checkInDate,
      checkOutDate: checkOutDate ?? this.checkOutDate,
      guestCount: guestCount ?? this.guestCount,
      roomCount: roomCount ?? this.roomCount,
      priceRange: priceRange ?? this.priceRange,
    );
  }
}
