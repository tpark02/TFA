import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:TFA/providers/flight/flight_search_controller.dart';
import 'package:TFA/providers/flight/flight_search_state.dart';
import 'package:TFA/screens/flight/flight_list_page.dart';
import 'navigation.dart';

bool stateReady(FlightSearchState s) {
  final bool hasDep = s.departureAirportCode.isNotEmpty;
  final bool hasArr = s.arrivalAirportCode.isNotEmpty;
  final bool hasOut = s.departDate.isNotEmpty; // allow one-way? then relax this
  return hasDep && hasArr && hasOut;
}

final StateProvider<bool> _isFetchingProvider = StateProvider<bool>((_) => false);

class SearchRunner {
  SearchRunner(this.container);
  final ProviderContainer container;

  Future<void> runFromState(FlightSearchState s) async {
    final bool isFetching = container.read(_isFetchingProvider);
    if (isFetching) return;
    container.read(_isFetchingProvider.notifier).state = true;

    try {
      final FlightSearchController ctrl = container.read(flightSearchProvider.notifier);

      final List<Future<(bool, String)> Function()> ops = ctrl.executeFlightSearch();

      // navigate first (like your original code)
      searchTabNavKey.currentState?.push(
        MaterialPageRoute<void>(builder: (_) => const FlightListPage()),
      );

      for (final Future<(bool, String)> Function() op in ops) {
        final (bool ok, String msg) = await op();
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
