import 'package:TFA/providers/flight/flight_search_controller.dart';
import 'package:TFA/services/airport_service.dart';
import 'package:TFA/services/location_service.dart';
import 'package:TFA/utils/dev_logger.dart';
import 'package:TFA/screens/flight/flight_search_button.dart';
import 'package:TFA/screens/flight/flight_search_inputs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class FlightPage extends ConsumerStatefulWidget {
  const FlightPage({super.key});
  @override
  ConsumerState<FlightPage> createState() => _FlightPageState();
}

class _FlightPageState extends ConsumerState<FlightPage> {
  static const double _padding = 20.0;
  bool _initialized = false;
  final User? user = FirebaseAuth.instance.currentUser;
  late final FlightSearchController controller;
  final AirportService _airportSvc = AirportService();

  Future<void> fetchCurrentCountry() async {
    try {
      final FlightSearchController controller = ref.read(
        flightSearchProvider.notifier,
      );
      final Position pos = await LocationService.getCurrentLocation();
      final List<Map<String, dynamic>> airports = await _airportSvc
          .nearbyAirports(
            lat: pos.latitude,
            lon: pos.longitude,
            radiusKm: 150,
            limit: 5,
          );

      final List<Placemark> placemarks = await placemarkFromCoordinates(
        pos.latitude,
        pos.longitude,
      );
      final String city = placemarks.isNotEmpty
          ? (placemarks.first.locality ?? '')
          : '';

      logInfo('nearby airports fetched: ${airports.length}', name: 'airport');
      logJson(
        airports.take(3).toList(),
        name: 'airport',
        headline: 'nearby aiports',
      );

      final Map<String, dynamic> first = airports.firstWhere(
        (Map<String, dynamic> e) =>
            (e['iataCode'] as String?)?.isNotEmpty == true,
        orElse: () => <String, dynamic>{},
      );
      final String? code = (first['iataCode'] as String?)?.toUpperCase();

      if (code != null) {
        controller.setDepartureCode(code, city);
        return;
      }
      controller.setDepartureCode('JFK', 'New York');
    } catch (e, st) {
      debugPrint('❌ Location/airport error: $e');
      debugPrint('$st');
      controller.setDepartureCode('JFK', 'New York');
    }
  }

  @override
  void initState() {
    super.initState();
    controller = ref.read(flightSearchProvider.notifier);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.departDate == null || controller.departDate!.isEmpty) {
        final DateTime departDate = DateTime.now();
        controller.setTripDates(departDate: departDate);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
        child: Column(
          children: <Widget>[
            const FlightSearchInputs(isLoadingCity: false, padding: _padding),
            const SizedBox(height: 12),
            FlightSearchButton(padding: _padding, user: user),
          ],
        ),
      ),
    );
  }
}
