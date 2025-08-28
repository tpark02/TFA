// search_runner.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:TFA/providers/flight/flight_search_controller.dart';
import 'package:TFA/providers/flight/flight_search_state.dart';
import 'package:TFA/screens/flight/flight_list_page.dart';
import 'navigation.dart';

bool stateReady(FlightSearchState s) {
  final hasDep = s.departureAirportCode.isNotEmpty;
  final hasArr = s.arrivalAirportCode.isNotEmpty;
  final hasOut = s.departDate.isNotEmpty; // allow one-way? then relax this
  return hasDep && hasArr && hasOut;
}

final _isFetchingProvider = StateProvider<bool>((_) => false);

class SearchRunner {
  SearchRunner(this.container);
  final ProviderContainer container;

  Future<void> runFromState(FlightSearchState s) async {
    final isFetching = container.read(_isFetchingProvider);
    if (isFetching) return;
    container.read(_isFetchingProvider.notifier).state = true;

    try {
      final ctrl = container.read(flightSearchProvider.notifier);

      // navigate first (like your original code)
      rootNavigatorKey.currentState?.push(
        MaterialPageRoute<void>(builder: (_) => const FlightListPage()),
      );

      // ctrl.clearProcessedFlights();
      final ops = ctrl.executeFlightSearch();
      for (final op in ops) {
        final (ok, msg) = await op();
        if (!ok) {
          debugPrint('❌ Search step failed: $msg');
          break;
        }
        debugPrint('✅ Search step: $msg');
      }
    } catch (e, st) {
      debugPrint('❌ runFromState error: $e\n$st');
      // You don’t have a ScaffoldMessenger here—either show a dialog via navigatorKey
      // or expose an error stream for the UI to consume.
    } finally {
      container.read(_isFetchingProvider.notifier).state = false;
    }
  }
}
