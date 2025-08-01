import 'package:TFA/providers/recent_search.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'car_search_state.dart';

class CarSearchController extends StateNotifier<CarSearchState> {
  CarSearchController() : super(const CarSearchState());

  void updateQuery(String query) {
    state = state.copyWith(query: query);
  }

  void setCountry(String country) {
    state = state.copyWith(selectedCountry: country);
  }

  void setCity(String city) {
    state = state.copyWith(selectedCity: city);
  }

  void addRecentSearch(RecentSearch search) {
    final updated = [search, ...state.recentSearches];
    if (updated.length > 5) updated.removeLast(); // optional: cap at 5 items
    state = state.copyWith(recentSearches: updated);
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
}

final carSearchProvider =
    StateNotifierProvider<CarSearchController, CarSearchState>(
      (ref) => CarSearchController(),
    );
