import 'package:chat_app/providers/hotel/hotel_search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HotelSearchController extends StateNotifier<HotelSearchState> {
  HotelSearchController() : super(const HotelSearchState());

  void updateLocation(String location) {
    state = state.copyWith(location: location);
  }

  void updateGuestCount(int count) {
    state = state.copyWith(guestCount: count);
  }

  void updateRoomCount(int count) {
    state = state.copyWith(roomCount: count);
  }

  void updateCheckInDate(DateTime date) {
    state = state.copyWith(checkInDate: date);
  }

  void updateCheckOutDate(DateTime date) {
    state = state.copyWith(checkOutDate: date);
  }

  void updatePriceRange(RangeValues range) {
    state = state.copyWith(priceRange: range);
  }

  void reset() {
    state = const HotelSearchState(); // back to defaults
  }
}

final hotelSearchProvider =
    StateNotifierProvider<HotelSearchController, HotelSearchState>(
      (ref) => HotelSearchController(),
    );
