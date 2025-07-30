import 'package:chat_app/models/hotel.dart';
import 'package:chat_app/utils/data_loader.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final hotelDataProvider = FutureProvider<List<Hotel>>((ref) async {
  final raw = await loadHotelData();
  final hotelList = raw
      .skip(1)
      .map((row) {
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

final hotelsByCityProvider = FutureProvider<Map<String, List<Hotel>>>((
  ref,
) async {
  try {
    final hotelList = await ref.watch(hotelDataProvider.future);
    return groupBy(hotelList, (hotel) => hotel.city);
  } catch (e, stack) {
    debugPrint("❌ Failed to group hotels: $e\n$stack");
    return {}; // return an empty map instead of null
  }
});

final searchHotelQueryProvider = StateProvider<String>((ref) => '');

final filteredHotelProvider = FutureProvider<Map<String, List<Hotel>>>((
  ref,
) async {
  final query = ref.watch(searchHotelQueryProvider).toLowerCase();

  if (query.length < 2) return {};

  final grouped = await ref.watch(hotelsByCityProvider.future);

  // 🔍 Filter only country names
  return Map.fromEntries(
    grouped.entries.where((e) => e.key.toLowerCase().contains(query)),
  );
});
