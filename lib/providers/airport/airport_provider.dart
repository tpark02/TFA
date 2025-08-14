import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:TFA/utils/data_loader.dart';
import 'package:TFA/models/airport.dart';

final FutureProvider<List<Airport>> airportDataProvider =
    FutureProvider<List<Airport>>((FutureProviderRef<List<Airport>> ref) async {
      final List<List> raw = await loadAirportData();
      final List<Airport> airportList = raw
          .map((List row) {
            try {
              final String? name = row[2]?.toString().toLowerCase().trim();
              final String? city = row[3]?.toString().toLowerCase().trim();
              final String? country = row[4]?.toString().toLowerCase().trim();

              if (<String?>[
                name,
                city,
                country,
              ].any((String? v) => v == 'n/a' || v!.isEmpty)) {
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

final StateProvider<String> airportSearchQueryProvider = StateProvider<String>(
  (StateProviderRef<String> ref) => '',
);
