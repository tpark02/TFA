// lib/providers/airport/airport_lookup.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:TFA/models/airport.dart';
import 'package:TFA/providers/airport/airport_provider.dart';

/// Build an index for fast lookups: IATA -> Airport
final Provider<Map<String, Airport>> airportIndexProvider = Provider<Map<String, Airport>>((ProviderRef<Map<String, Airport>> ref) {
  final List<Airport> list = ref
      .watch(airportDataProvider)
      .maybeWhen(data: (List<Airport> v) => v, orElse: () => const <Airport>[]);
  final Map<String, Airport> map = <String, Airport>{};
  for (final Airport a in list) {
    if (a.iataCode.isNotEmpty) {
      map[a.iataCode.toUpperCase()] = a;
    }
  }
  return map;
});

/// Get Airport by IATA (e.g., "ICN" -> Airport)
final ProviderFamily<Airport?, String> airportByIataProvider = Provider.family<Airport?, String>((ProviderRef<Airport?> ref, String code) {
  final Map<String, Airport> idx = ref.watch(airportIndexProvider);
  return idx[code.trim().toUpperCase()];
});

/// Get city name by IATA (e.g., "ICN" -> "Seoul")
final ProviderFamily<String?, String> cityByIataProvider = Provider.family<String?, String>((ProviderRef<String?> ref, String code) {
  final Airport? a = ref.watch(airportByIataProvider(code));
  return a?.city; // assumes Airport has a `city` field
});
