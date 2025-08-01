import 'package:TFA/models/cars.dart';
import 'package:TFA/utils/data_loader.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final carDataProvider = FutureProvider<List<Car>>((ref) async {
  // Load CSV from assets
  final raw = await loadCarData();
  final carList = raw
      .skip(1)
      .map((row) {
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

final carsByCityProvider = FutureProvider<Map<String, List<Car>>>((ref) async {
  try {
    final carList = await ref.watch(carDataProvider.future);
    return groupBy(carList, (car) => car.city);
  } catch (e, stack) {
    debugPrint("❌ Failed to group cars: $e\n$stack");
    return {}; // return an empty map instead of null
  }
});

final searchCarQueryProvider = StateProvider<String>((ref) => '');

final filteredCarProvider = FutureProvider<Map<String, List<Car>>>((ref) async {
  final query = ref.watch(searchCarQueryProvider).toLowerCase();

  if (query.length < 2) return {};

  final grouped = await ref.watch(carsByCityProvider.future);

  // 🔍 Filter only country names
  return Map.fromEntries(
    grouped.entries.where((e) => e.key.toLowerCase().contains(query)),
  );
});
