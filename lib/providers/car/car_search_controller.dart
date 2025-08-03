import 'package:TFA/providers/recent_search.dart';
import 'package:TFA/services/recent_search_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'car_search_state.dart';

class CarSearchController extends StateNotifier<CarSearchState> {
  CarSearchController() : super(const CarSearchState());

  Future<void> initRecentSearch(RecentSearch search) async {
    final updated = [search, ...state.recentSearches];
    if (updated.length > 5) updated.removeLast();
    state = state.copyWith(recentSearches: updated);
  }

  void updateQuery(String query) {
    state = state.copyWith(query: query);
  }

  void setCountry(String country) {
    state = state.copyWith(selectedCountry: country);
  }

  void setCity(String city) {
    state = state.copyWith(selectedCity: city);
  }

  Future<bool> addRecentSearch(RecentSearch search, String jwtToken) async {
    final updated = [search, ...state.recentSearches];
    if (updated.length > 5) updated.removeLast(); // optional: cap at 5 items
    state = state.copyWith(recentSearches: updated);
    // ❌ Only send to backend if not placeholder
    if (search.destination.trim().isEmpty ||
        search.tripDateRange.trim().isEmpty ||
        (search.kind != 'car' &&
            (search.destinationCode.trim().isEmpty || search.guests == 0))) {
      debugPrint("⚠️ Skipped sending empty search to backend");
      return false;
    }

    // ✅ Send only valid searches
    return await RecentSearchApiService.sendRecentSearch(
      destination: search.destination,
      tripDateRange: search.tripDateRange,
      destinationCode: search.destinationCode,
      guests: search.guests,
      kind: search.kind,
      jwtToken: jwtToken,
    );
  }

  void clearSearch() {
    state = const CarSearchState();
  }

  void setBeginDate(String selectedDate) {
    state = state.copyWith(beginDate: selectedDate);
  }

  void setEndDate(String selectedDate) {
    state = state.copyWith(endDate: selectedDate);
  }

  void setBeginTime(String selectedTime) {
    state = state.copyWith(beginTime: selectedTime);
  }

  void setEndTime(String selectedTime) {
    state = state.copyWith(endTime: selectedTime);
  }

  Future<void> loadRecentSearchesFromApi() async {
    try {
      final results = await RecentSearchApiService.fetchRecentSearches('car');
      state = state.copyWith(recentSearches: []);

      for (final r in results) {
        final guestsValue = r['guests'];
        final guests = guestsValue is int
            ? guestsValue
            : int.tryParse(guestsValue.toString()) ?? 1;

        initRecentSearch(
          RecentSearch(
            destination: r['destination'],
            tripDateRange: r['trip_date_range'],
            icons: [],
            destinationCode: r['destination_code'],
            guests: guests,
            kind: 'car',
          ),
        );
      }

      debugPrint("✅ Fetched into state: $results");
    } catch (e) {
      debugPrint("❌ Failed loading recent searches: $e");
    }
  }
}

final carSearchProvider =
    StateNotifierProvider<CarSearchController, CarSearchState>(
      (ref) => CarSearchController(),
    );
