// flight_page_trigger_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SortTab {
  sort,
  travelHacks,
  stops,
  takeoff,
  landing,
  flightDuration,
  layoverDuration,
  airlines,
  layoverCities,
  hotelSort,
}

final StateProvider<SortTab> sortTabProvider = StateProvider<SortTab>(
  (StateProviderRef<SortTab> ref) => SortTab.sort,
);
