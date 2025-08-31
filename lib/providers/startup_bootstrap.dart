import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:TFA/providers/flight/flight_search_controller.dart';
import 'package:TFA/services/airport_service.dart';
import 'package:TFA/services/location_service.dart';

final _airportSvc = AirportService();

/// Runs once at app start. Safe to call without BuildContext.
Future<void> runStartupBootstrap(ProviderContainer container) async {
  final ctrl = container.read(flightSearchProvider.notifier);

  // 1) Set default depart date if empty
  if ((ctrl.departDate ?? '').isEmpty) {
    ctrl.setTripDates(departDate: DateTime.now());
  }

  // 2) Location → nearest airport → set departure (only if user hasn't set one)
  try {
    if (container.read(flightSearchProvider).departureAirportCode.isEmpty) {
      final Position pos = await LocationService.getCurrentLocation();

      final airports = await _airportSvc.nearbyAirports(
        lat: pos.latitude,
        lon: pos.longitude,
        radiusKm: 150,
        limit: 5,
      );

      final placemarks = await placemarkFromCoordinates(
        pos.latitude,
        pos.longitude,
      );
      final city = placemarks.isNotEmpty
          ? (placemarks.first.locality ?? '')
          : '';

      final first = airports.firstWhere(
        (e) => (e['iataCode'] as String?)?.isNotEmpty == true,
        orElse: () => const <String, dynamic>{},
      );
      final String? code = (first['iataCode'] as String?)?.toUpperCase();

      if (code != null) {
        ctrl.setDepartureCode(code, city);
        debugPrint('📍 Bootstrap set depart IATA: $code ($city)');
      } else {
        ctrl.setDepartureCode('JFK', 'New York');
        debugPrint('📍 Bootstrap fallback to JFK');
      }
    }
  } catch (e, st) {
    debugPrint('❌ Bootstrap location error: $e\n$st');
    // Gentle fallback if nothing set yet
    if (container.read(flightSearchProvider).departureAirportCode.isEmpty) {
      ctrl.setDepartureCode('JFK', 'New York');
    }
  }

  // 3) Load recent searches (does not need context)
  try {
    if (ctrl.mounted) {
      await ctrl.loadRecentSearches();
    }
  } catch (e, st) {
    debugPrint('❌ loadRecentSearches error: $e\n$st');
  }
}
