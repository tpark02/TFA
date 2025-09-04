import 'package:flutter/material.dart';
import 'package:TFA/screens/flight/flight_filter_page.dart';

class FlightFilterScreen extends StatefulWidget {
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
  State<FlightFilterScreen> createState() => _FlightFilterScreenState();
}

class _FlightFilterScreenState extends State<FlightFilterScreen> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: FlightFilterPage(
          scrollController: _controller,
          selectedAirlines: widget.selectedAirlines,
          selectedLayovers: widget.selectedLayovers,
          kAirlines: widget.kAirlines,
          kLayoverCities: widget.kLayoverCities,
          carriersDict: widget.carriersDict,
        ),
      ),
    );
  }
}
