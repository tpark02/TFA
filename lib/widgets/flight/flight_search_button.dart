// lib/screens/flight/widgets/search_button.dart

import 'package:TFA/providers/flight/flight_search_state.dart';
import 'package:TFA/screens/flight/anywhere_list_page.dart';
import 'package:TFA/screens/flight/flight_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:TFA/providers/flight/flight_search_controller.dart';
import 'package:TFA/providers/recent_search.dart';
import 'package:TFA/screens/shared/recent_search_panel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FlightSearchButton extends ConsumerStatefulWidget {
  const FlightSearchButton({
    super.key,
    required this.padding,
    required this.user,
  });

  final double padding;
  final User? user;

  @override
  ConsumerState<FlightSearchButton> createState() => _FlightSearchButtonState();
}

class _FlightSearchButtonState extends ConsumerState<FlightSearchButton> {
  @override
  Widget build(BuildContext context) {
    final FlightSearchController controller = ref.read(
      flightSearchProvider.notifier,
    );
    final FlightSearchState flightState = ref.watch(flightSearchProvider);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.padding),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    final bool hasPassengers = flightState.passengerCount > 0;
                    final bool hasAirports =
                        flightState.departureAirportCode.isNotEmpty &&
                        flightState.arrivalAirportCode.isNotEmpty;
                    final bool hasDate =
                        (flightState.displayDate ?? '').isNotEmpty;

                    if (!hasPassengers || !hasDate) return;

                    if (!hasAirports ||
                        flightState.arrivalAirportCode == 'anywhere') {
                      controller.setArrivalAnyWhere = 'anywhere';
                      controller.setLoading(true);
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const AnywhereListPage(),
                        ),
                      );
                      return;
                    }
                    final String? idToken = await widget.user?.getIdToken();

                    if (idToken == null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('❌ Unable to retrieve user token'),
                          ),
                        );
                      });
                      return;
                    }
                    final bool success = await controller.addRecentSearch(
                      RecentSearch(
                        destination:
                            '${flightState.departureCity} - ${flightState.arrivalCity}',
                        tripDateRange: flightState.displayDate ?? '',
                        icons: <Widget>[
                          const SizedBox(width: 10),
                          Icon(Icons.person, color: Colors.grey[500], size: 20),
                          Text(flightState.passengerCount.toString()),
                        ],
                        destinationCode:
                            '${flightState.departureAirportCode} - ${flightState.arrivalAirportCode}',
                        passengerCnt: flightState.passengerCount,
                        adult: flightState.adultCnt,
                        children: flightState.childrenCnt,
                        infantLap: flightState.infantLapCnt,
                        infantSeat: flightState.infantSeatCnt,
                        cabinIdx: flightState.cabinIdx,
                        rooms: 0,
                        kind: 'flight',
                        departCode: flightState.departureAirportCode,
                        arrivalCode: flightState.arrivalAirportCode,
                        departDate: flightState.departDate,
                        returnDate: flightState.returnDate ?? '',
                      ),
                      idToken,
                    );

                    if (!success) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              '❌ Failed to save flight recent search',
                            ),
                          ),
                        );
                      });
                    }
                    controller.clearProcessedFlights();
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const FlightListPage(),
                        ),
                      );
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Search Flight',
                        style: TextStyle(
                          fontSize: Theme.of(
                            context,
                          ).textTheme.headlineMedium?.fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          const RecentSearchPanel(panelName: 'flight'),
        ],
      ),
    );
  }
}
