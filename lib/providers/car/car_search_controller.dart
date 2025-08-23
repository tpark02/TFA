import 'package:TFA/providers/recent_search.dart';
import 'package:TFA/services/recent_search_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'car_search_state.dart';

class CarSearchController extends StateNotifier<CarSearchState> {
  CarSearchController() : super(const CarSearchState());

  Future<void> initRecentSearch(RecentSearch search) async {
    final List<RecentSearch> updated = <RecentSearch>[
      search,
      ...state.recentSearches,
    ];
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
    final List<RecentSearch> updated = <RecentSearch>[
      search,
      ...state.recentSearches,
    ];
    if (updated.length > 5) updated.removeLast(); // optional: cap at 5 items
    state = state.copyWith(recentSearches: updated);
    // ❌ Only send to backend if not placeholder
    if (search.destination.trim().isEmpty ||
        search.tripDateRange.trim().isEmpty ||
        (search.kind != 'car' &&
            (search.destinationCode.trim().isEmpty ||
                search.passengerCnt == 0))) {
      debugPrint("⚠️ Skipped sending empty search to backend");
      return false;
    }

    // ✅ Send only valid searches
    return await RecentSearchApiService.sendRecentSearch(
      destination: search.destination,
      tripDateRange: search.tripDateRange,
      destinationCode: search.destinationCode,
      passengerCnt: search.passengerCnt,
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

  void setTripDates({
    required DateTime departDate, // non-null
    DateTime? returnDate, // nullable for one-way
  }) {
    final DateFormat iso = DateFormat('yyyy-MM-dd');
    final DateFormat pretty = DateFormat('MMM d');

    final String dIso = iso.format(departDate);
    final String? rIso = (returnDate == null) ? null : iso.format(returnDate);

    final String displayDt = pretty.format(departDate);

    final String displayRt = (returnDate != null) ? pretty.format(returnDate) : '';

    if (state.departDate == dIso &&
        state.returnDate == rIso &&
        state.displayDepartDate == displayDt &&
        state.displayReturnDate == displayRt) {
      return;
    }

    state = state.copyWith(
      departDate: dIso,
      returnDate: rIso,
      displayDepartDate: displayDt,
      displayReturnDate: displayRt,
      clearReturnDate: returnDate == null ? true : false,
    );
  }

  void setDepartDate(DateTime? selectedDate) {
    if (selectedDate == null) {
      state = state.copyWith(departDate: null);
      return;
    }
    final String formatted = DateFormat('yyyy-MM-dd').format(selectedDate);
    final String display = DateFormat('EEE MMM d').format(selectedDate);

    state = state.copyWith(departDate: formatted, displayDepartDate: display);
  }

  void setReturnDate(DateTime? selectedDate) {
    if (selectedDate == null) {
      state = state.copyWith(returnDate: null);
      return;
    }
    final String formatted = DateFormat('yyyy-MM-dd').format(selectedDate);
    final String display = DateFormat('EEE MMM d').format(selectedDate);

    state = state.copyWith(returnDate: formatted, displayReturnDate: display);
  }

  void setBeginTime(String selectedTime) {
    state = state.copyWith(beginTime: selectedTime);
  }

  void setEndTime(String selectedTime) {
    state = state.copyWith(endTime: selectedTime);
  }

  Future<void> loadRecentSearchesFromApi() async {
    try {
      final List<Map<String, dynamic>> results =
          await RecentSearchApiService.fetchRecentSearches('car');
      state = state.copyWith(recentSearches: <RecentSearch>[]);

      for (final Map<String, dynamic> r in results) {
        final guestsValue = r['guests'];
        final int guests = guestsValue is int
            ? guestsValue
            : int.tryParse(guestsValue.toString()) ?? 1;

        initRecentSearch(
          RecentSearch(
            destination: r['destination'],
            tripDateRange: r['trip_date_range'],
            icons: <Widget>[],
            destinationCode: r['destination_code'],
            passengerCnt: guests,
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

final StateNotifierProvider<CarSearchController, CarSearchState>
carSearchProvider = StateNotifierProvider<CarSearchController, CarSearchState>(
  (StateNotifierProviderRef<CarSearchController, CarSearchState> ref) =>
      CarSearchController(),
);
