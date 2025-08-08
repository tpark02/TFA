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
}

final sortTabProvider = StateProvider<SortTab>((ref) => SortTab.sort);
