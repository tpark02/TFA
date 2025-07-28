import 'package:chat_app/models/hotel.dart';
import 'package:chat_app/utils/data_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final hotelDataProvider = FutureProvider<List<Hotel>>((ref) async {
  final raw = await loadHotelData();
  final hotelList = raw
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
  debugPrint("✅ Final loaded airports: ${hotelList.length}");
  return hotelList;
});

final searchHotelQueryProvider = StateProvider<String>((ref) => '');
