// lib/providers/airport/airport_lookup.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:TFA/models/airport.dart';
import 'package:TFA/providers/airport/airport_provider.dart';

/// Build an index for fast lookups: IATA -> Airport
final airportIndexProvider = Provider<Map<String, Airport>>((ref) {
  final list = ref
      .watch(airportDataProvider)
      .maybeWhen(data: (v) => v, orElse: () => const <Airport>[]);
  final map = <String, Airport>{};
  for (final a in list) {
    if (a.iataCode.isNotEmpty) {
      map[a.iataCode.toUpperCase()] = a;
    }
  }
  return map;
});

/// Get Airport by IATA (e.g., "ICN" -> Airport)
final airportByIataProvider = Provider.family<Airport?, String>((ref, code) {
  final idx = ref.watch(airportIndexProvider);
  return idx[code.trim().toUpperCase()];
});

/// Get city name by IATA (e.g., "ICN" -> "Seoul")
final cityByIataProvider = Provider.family<String?, String>((ref, code) {
  final a = ref.watch(airportByIataProvider(code));
  return a?.city; // assumes Airport has a `city` field
});
