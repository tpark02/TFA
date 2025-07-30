import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/utils/data_loader.dart';
import 'package:chat_app/models/airport.dart';

final airportDataProvider = FutureProvider<List<Airport>>((ref) async {
  final raw = await loadAirportData();
  final airportList = raw
      .map((row) {
        try {
          final name = row[2]?.toString().toLowerCase().trim();
          final city = row[3]?.toString().toLowerCase().trim();
          final country = row[4]?.toString().toLowerCase().trim();

          if ([name, city, country].any((v) => v == 'n/a' || v!.isEmpty)) {
            debugPrint("🚫 Skipped dirty row: $row");
            return null;
          }

          return Airport.fromCsvRow(row);
        } catch (e) {
          debugPrint("❌ Failed to parse row: $e\n$row");
          return null;
        }
      })
      .whereType<Airport>()
      .toList();

  debugPrint("✅ Final loaded airports: ${airportList.length}");
  return airportList;
});

final airportSearchQueryProvider = StateProvider<String>((ref) => '');
