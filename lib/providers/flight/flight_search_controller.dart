import 'package:TFA/providers/recent_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'flight_search_state.dart';
import 'package:TFA/services/recent_search_service.dart';

class FlightSearchController extends StateNotifier<FlightSearchState> {
  FlightSearchController() : super(const FlightSearchState());

  void addRecentSearch(RecentSearch search, String jwtToken) {
    // ✅ Always update state, even for empty ones (to preserve visual 5-item layout)
    final updated = [search, ...state.recentSearches];
    if (updated.length > 5) updated.removeLast();
    state = state.copyWith(recentSearches: updated);

    // ❌ Only send to backend if not placeholder
    if (search.destination.trim().isEmpty ||
        search.tripDateRange.trim().isEmpty ||
        search.destinationCode.trim().isEmpty) {
      debugPrint("⚠️ Skipped sending empty search to backend");
      return;
    }

    // ✅ Send only valid searches
    RecentSearchApiService.sendRecentSearch(
      destination: search.destination,
      tripDateRange: search.tripDateRange,
      destinationCode: search.destinationCode,
      jwtToken: jwtToken,
    );
  }

  void setDepartureCity(String city) {
    state = state.copyWith(departureCity: city);
  }

  void setArrivalCity(String city) {
    state = state.copyWith(arrivalCity: city);
  }

  void setDepartureCode(String code) {
    state = state.copyWith(departureAirportCode: code);
  }

  void setDepartureName(String name) {
    state = state.copyWith(departureAirportName: name);
  }

  void setArrivalCode(String code) {
    state = state.copyWith(arrivalAirportCode: code);
  }

  void setArrivalName(String name) {
    state = state.copyWith(arrivalAirportName: name);
  }

  void setDisplayDate(String displayDate) {
    state = state.copyWith(displayDate: displayDate);
  }

  void setPassengers({required int count, required int cabinIndex}) {
    String cabin;
    switch (cabinIndex) {
      case 0:
        cabin = 'Economy';
        break;
      case 1:
        cabin = 'Premium Economy';
        break;
      case 2:
        cabin = 'Business';
        break;
      case 3:
        cabin = 'First';
        break;
      default:
        cabin = 'Economy';
    }

    state = state.copyWith(passengerCount: count, cabinClass: cabin);
  }
}

final flightSearchProvider =
    StateNotifierProvider<FlightSearchController, FlightSearchState>(
      (ref) => FlightSearchController(),
    );
