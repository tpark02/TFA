import 'package:TFA/misc/models/cars.dart';
import 'package:TFA/utils/data_loader.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final FutureProvider<List<Car>> carDataProvider = FutureProvider<List<Car>>((FutureProviderRef<List<Car>> ref) async {
  // Load CSV from assets
  final List<List> raw = await loadCarData();
  final List<Car> carList = raw
      .skip(1)
      .map((List row) {
        try {
          return Car.fromCsvRow(row);
        } catch (e) {
          debugPrint("❌ Failed to parse row: $e\n$row");
          return null;
        }
      })
      .whereType<Car>()
      .toList();

  debugPrint("✅ Final loaded cars: ${carList.length}");
  return carList;
});

final FutureProvider<Map<String, List<Car>>> carsByCityProvider = FutureProvider<Map<String, List<Car>>>((FutureProviderRef<Map<String, List<Car>>> ref) async {
  try {
    final List<Car> carList = await ref.watch(carDataProvider.future);
    return groupBy(carList, (Car car) => car.city);
  } catch (e, stack) {
    debugPrint("❌ Failed to group cars: $e\n$stack");
    return <String, List<Car>>{}; // return an empty map instead of null
  }
});

final StateProvider<String> searchCarQueryProvider = StateProvider<String>((StateProviderRef<String> ref) => '');

final FutureProvider<Map<String, List<Car>>> filteredCarProvider = FutureProvider<Map<String, List<Car>>>((FutureProviderRef<Map<String, List<Car>>> ref) async {
  final String query = ref.watch(searchCarQueryProvider).toLowerCase();

  if (query.length < 2) return <String, List<Car>>{};

  final Map<String, List<Car>> grouped = await ref.watch(carsByCityProvider.future);

  // 🔍 Filter only country names
  return Map.fromEntries(
    grouped.entries.where((MapEntry<String, List<Car>> e) => e.key.toLowerCase().contains(query)),
  );
});
