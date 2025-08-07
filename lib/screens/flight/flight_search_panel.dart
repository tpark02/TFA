// lib/screens/flight/flight_search_panel.dart

import 'package:TFA/providers/airport/airport_provider.dart';
import 'package:TFA/providers/flight/flight_search_controller.dart';
import 'package:TFA/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:TFA/widgets/flight/flight_search_inputs.dart';
import 'package:TFA/widgets/flight/flight_search_button.dart';

class FlightSearchPanel extends ConsumerStatefulWidget {
  const FlightSearchPanel({super.key});
  @override
  ConsumerState<FlightSearchPanel> createState() => _FlightSearchPanelState();
}

class _FlightSearchPanelState extends ConsumerState<FlightSearchPanel> {
  static const double _padding = 20.0;
  bool _isLoadingCity = true;
  bool _initialized = false;
  final user = FirebaseAuth.instance.currentUser;
  late final FlightSearchController controller;

  Future<void> fetchCurrentCountry() async {
    setState(() => _isLoadingCity = true);

    try {
      final position = await LocationService.getCurrentLocation();
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final city = placemarks.first.locality ?? '';
        final airportData = ref.watch(airportDataProvider);

        final filteredAirports = airportData.maybeWhen(
          data: (airports) {
            return airports.where((a) {
              return a.airportName.toLowerCase().contains(city) ||
                  a.city.toLowerCase().contains(city);
            }).toList();
          },
          orElse: () => [],
        );
        if (filteredAirports.isNotEmpty) {
          ref
              .read(flightSearchProvider.notifier)
              .setDepartureCode(filteredAirports[0].iataCode);
          debugPrint(
            "\uD83D\uDCCD set iataCode: \${filteredAirports[0].iataCode}",
          );
          return;
        }
        debugPrint("\uD83D\uDCCD set default iataCode: JFK");
      }
    } catch (e) {
      debugPrint("\u274C Location error: \$e");
    } finally {
      if (mounted) setState(() => _isLoadingCity = false);
    }
  }

  @override
  void initState() {
    super.initState();
    controller = ref.read(flightSearchProvider.notifier);

    Future.microtask(() {
      controller.loadRecentSearchesFromApi();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      _initialized = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (controller.departDate == null || controller.departDate!.isEmpty) {
          final departDate = DateTime.now();

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
        children: [
          FlightSearchInputs(isLoadingCity: _isLoadingCity, padding: _padding),
          const SizedBox(height: 8),
          FlightSearchButton(padding: _padding, user: user),
        ],
      ),
    );
  }
}
