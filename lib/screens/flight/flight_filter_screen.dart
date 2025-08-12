// 🟢 NEW: thin wrapper screen that provides a ScrollController
import 'package:TFA/screens/flight/flight_filter_page.dart';
import 'package:flutter/material.dart';

class FlightFilterScreen extends StatelessWidget {
  const FlightFilterScreen({
    super.key,
    required this.selectedAirlines,
    required this.selectedLayovers,
    required this.kAirlines,
    required this.kLayoverCities,
    required this.carriersDict,
  });

  final Set<String> selectedAirlines;
  final Set<String> selectedLayovers;
  final List<String> kAirlines;
  final List<String> kLayoverCities;
  final Map<String, String> carriersDict;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // full-screen page
      body: SafeArea(
        child: FlightFilterPage(
          scrollController:
              ScrollController(), // 🟢 Replaces DraggableScrollableSheet controller
          selectedAirlines: selectedAirlines,
          selectedLayovers: selectedLayovers,
          kAirlines: kAirlines,
          kLayoverCities: kLayoverCities,
          carriersDict: carriersDict,
        ),
      ),
    );
  }
}
