import 'package:TFA/providers/recent_search.dart';
import 'package:TFA/services/recent_search_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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
      rooms: search.rooms,
      kind: search.kind,
      departCode: search.departCode,
      arrivalCode: search.arrivalCode,
      departDate: search.departDate,
      returnDate: search.returnDate,
      jwtToken: jwtToken,
    );
  }

  void clearSearch() {
    state = const CarSearchState();
  }

  void setBeginDate(DateTime? selectedDate) {
    if (selectedDate == null) {
      state = state.copyWith(beginDate: null);
      return;
    }
    final String formatted = DateFormat('yyyy-MM-dd').format(selectedDate);
    final display = DateFormat('EEE MMM d').format(selectedDate);

    state = state.copyWith(beginDate: formatted, displayBeginDate: display);
  }

  void setEndDate(DateTime? selectedDate) {
    if (selectedDate == null) {
      state = state.copyWith(endDate: null);
      return;
    }
    final String formatted = DateFormat('yyyy-MM-dd').format(selectedDate);
    final display = DateFormat('EEE MMM d').format(selectedDate);

    state = state.copyWith(endDate: formatted, displayEndDate: display);
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
            rooms: 0,
            kind: 'car',
            departCode: r['depart_code'],
            arrivalCode: r['arrival_code'],
            departDate: r['depart_date'],
            returnDate: r['return_date'],
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
