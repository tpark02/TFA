import 'package:TFA/misc/models/hotel.dart';
import 'package:TFA/utils/data_loader.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final FutureProvider<List<Hotel>> hotelDataProvider = FutureProvider<List<Hotel>>((FutureProviderRef<List<Hotel>> ref) async {
  final List<List> raw = await loadHotelData();
  final List<Hotel> hotelList = raw
      .skip(1)
      .map((List row) {
        try {
          return Hotel.fromCsvRow(row); // ✅ Parse each row into a Hotel object
        } catch (e) {
          debugPrint("❌ Failed to parse row: $e\n$row");
          return null;
        }
      })
      .whereType<Hotel>()
      .toList();
  debugPrint("✅ Final loaded hotels: ${hotelList.length}");
  return hotelList;
});

final FutureProvider<Map<String, List<Hotel>>> hotelsByCityProvider = FutureProvider<Map<String, List<Hotel>>>((
  FutureProviderRef<Map<String, List<Hotel>>> ref,
) async {
  try {
    final List<Hotel> hotelList = await ref.watch(hotelDataProvider.future);
    return groupBy(hotelList, (Hotel hotel) => hotel.city);
  } catch (e, stack) {
    debugPrint("❌ Failed to group hotels: $e\n$stack");
    return <String, List<Hotel>>{}; // return an empty map instead of null
  }
});

final StateProvider<String> searchHotelQueryProvider = StateProvider<String>((StateProviderRef<String> ref) => '');

final FutureProvider<Map<String, List<Hotel>>> filteredHotelProvider = FutureProvider<Map<String, List<Hotel>>>((
  FutureProviderRef<Map<String, List<Hotel>>> ref,
) async {
  final String query = ref.watch(searchHotelQueryProvider).toLowerCase();

  if (query.length < 2) return <String, List<Hotel>>{};

  final Map<String, List<Hotel>> grouped = await ref.watch(hotelsByCityProvider.future);

  // 🔍 Filter only country names
  return Map.fromEntries(
    grouped.entries.where((MapEntry<String, List<Hotel>> e) => e.key.toLowerCase().contains(query)),
  );
});
