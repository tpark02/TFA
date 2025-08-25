import 'package:TFA/providers/flight/flight_search_controller.dart';
import 'package:TFA/providers/flight/flight_search_state.dart';
import 'package:TFA/screens/flight/flight_list_page.dart';
import 'package:TFA/services/airport_service.dart';
import 'package:TFA/services/location_service.dart';
import 'package:TFA/utils/dev_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:TFA/widgets/flight/flight_search_inputs.dart';
import 'package:TFA/widgets/flight/flight_search_button.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';

class FlightPage extends ConsumerStatefulWidget {
  const FlightPage({super.key});
  @override
  ConsumerState<FlightPage> createState() => _FlightPageState();
}

class _FlightPageState extends ConsumerState<FlightPage> {
  static const double _padding = 20.0;
  bool _isLoadingCity = true;
  bool _initialized = false;
  final User? user = FirebaseAuth.instance.currentUser;
  late final FlightSearchController controller;
  final AirportService _airportSvc = AirportService();
  late final ProviderSubscription<FlightSearchState> _stateSub;
  bool _rtFetching = false;

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
        // controller.setDepartureCity(city);
        debugPrint('📍 set iataCode from Amadeus: $code');
        return;
      }
      debugPrint('📍 no nearby airport from API (city: $city) → default JFK');
      controller.setDepartureCode('JFK', 'New York');
      // controller.setDepartureCity('New York');
    } catch (e, st) {
      debugPrint('❌ Location/airport error: $e');
      debugPrint('$st');
      controller.setDepartureCode('JFK', 'New York');
      // controller.setDepartureCity('New York');
    } finally {
      if (mounted) setState(() => _isLoadingCity = false);
    }
  }

  // ---------------------- add these helpers ----------------------
  bool _stateReady(FlightSearchState s) {
    final bool hasDep = s.departureAirportCode.isNotEmpty;
    final bool hasArr = s.arrivalAirportCode.isNotEmpty;
    final bool hasOut = s.departDate.isNotEmpty;
    // return date optional (allow one-way)
    return hasDep && hasArr && hasOut;
  }

  Future<void> _runSearchFrom(FlightSearchState s) async {
    if (_rtFetching) return;
    _rtFetching = true;

    final FlightSearchController controller = ref.read(
      flightSearchProvider.notifier,
    );

    try {
      // optional: clear existing results before new search
      controller.clearProcessedFlights();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(
          context,
        ).push(MaterialPageRoute<void>(builder: (_) => const FlightListPage()));
      });
      // IMPORTANT: executeFlightSearch returns a list of closures.
      final List<Future<(bool, String)> Function()> ops = controller
          .executeFlightSearch();

      for (final Future<(bool, String)> Function() op in ops) {
        final (bool ok, String msg) = await op(); // <-- invoke each closure
        if (!ok) {
          debugPrint('❌ Search failed: $msg');
          // you can throw or show a snackbar here, then break/return
          break;
        }
        debugPrint('✅ Search step: $msg');
      }
    } catch (e, st) {
      debugPrint('❌ runSearch error: $e\n$st');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      _rtFetching = false;
    }
  }

  // ---------------------- init & dispose ----------------------
  @override
  void initState() {
    super.initState();
    controller = ref.read(flightSearchProvider.notifier);
    // Listen to flightSearchProvider and trigger searches on meaningful changes
    _stateSub = ref.listenManual<FlightSearchState>(
      flightSearchProvider,
      (FlightSearchState? prev, FlightSearchState next) async {
        // identical object → ignore
        if (prev == next) return;

        // ignore “anywhere” (handled by your Anywhere UI)
        if (next.arrivalAirportCode.toLowerCase() == 'anywhere') return;

        // only run when NEW state is ready (don’t gate on prev)
        if (!_stateReady(next)) return;

        // optionally: skip if none of the key params changed
        // final bool changed =
        //     prev == null ||
        //     prev.departureAirportCode != next.departureAirportCode ||
        //     prev.arrivalAirportCode != next.arrivalAirportCode ||
        //     prev.departDate != next.departDate ||
        //     (prev.returnDate ?? '') != (next.returnDate ?? '') ||
        //     prev.cabinIdx != next.cabinIdx ||
        //     prev.adultCnt != next.adultCnt ||
        //     prev.childrenCnt != next.childrenCnt ||
        //     prev.infantLapCnt != next.infantLapCnt ||
        //     prev.infantSeatCnt != next.infantSeatCnt;

        debugPrint('🎯 listenManual fired → running search…');
        await _runSearchFrom(next);
      },
      fireImmediately: false, // first run will wait until a change arrives
    );
  }

  @override
  void dispose() {
    _stateSub.close();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      _initialized = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (controller.departDate == null || controller.departDate!.isEmpty) {
          final DateTime departDate = DateTime.now();

          controller.setTripDates(departDate: departDate);
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
