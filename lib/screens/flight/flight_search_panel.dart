import 'package:TFA/providers/flight/flight_search_controller.dart';
import 'package:TFA/services/airport_service.dart';
import 'package:TFA/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:TFA/widgets/flight/flight_search_inputs.dart';
import 'package:TFA/widgets/flight/flight_search_button.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';

class FlightSearchPanel extends ConsumerStatefulWidget {
  const FlightSearchPanel({super.key});
  @override
  ConsumerState<FlightSearchPanel> createState() => _FlightSearchPanelState();
}

class _FlightSearchPanelState extends ConsumerState<FlightSearchPanel> {
  static const double _padding = 20.0;
  bool _isLoadingCity = true;
  bool _initialized = false;
  final User? user = FirebaseAuth.instance.currentUser;
  late final FlightSearchController controller;
  final AirportService _airportSvc = AirportService();

  Future<void> fetchCurrentCountry() async {
    if (!mounted) return;
    setState(() => _isLoadingCity = true);

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

      final Map<String, dynamic> first = airports.firstWhere(
        (Map<String, dynamic> e) =>
            (e['iataCode'] as String?)?.isNotEmpty == true,
        orElse: () => <String, dynamic>{},
      );
      final String? code = (first['iataCode'] as String?)?.toUpperCase();

      if (code != null) {
        controller.setDepartureCode(code);
        controller.setDepartureCity(city);
        debugPrint('📍 set iataCode from Amadeus: $code');
        return;
      }
      debugPrint('📍 no nearby airport from API (city: $city) → default JFK');
      controller.setDepartureCode('JFK');
      controller.setDepartureCity('New York');
    } catch (e, st) {
      debugPrint('❌ Location/airport error: $e');
      debugPrint('$st');
      controller.setDepartureCode('JFK');
      controller.setDepartureCity('New York');
    } finally {
      if (mounted) setState(() => _isLoadingCity = false);
    }
  }

  @override
  void initState() {
    super.initState();
    controller = ref.read(flightSearchProvider.notifier);

    Future.microtask(() {
      controller.loadRecentSearches();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      _initialized = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (controller.departDate == null || controller.departDate!.isEmpty) {
          final DateTime departDate = DateTime.now();

          controller.setDepartDate(departDate);
          controller.setDisplayDate(startDate: departDate);
        }
      });

      Future.microtask(() async {
        await fetchCurrentCountry();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          FlightSearchInputs(isLoadingCity: _isLoadingCity, padding: _padding),
          const SizedBox(height: 8),
          FlightSearchButton(padding: _padding, user: user),
        ],
      ),
    );
  }
}
