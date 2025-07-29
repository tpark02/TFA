import 'package:chat_app/providers/airport_selection.dart';
import 'package:chat_app/providers/recent_search.dart';
import 'package:chat_app/providers/flight_search_controller.dart';
import 'package:chat_app/screens/recent_search_panel.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/screens/calendar_sheet.dart';
import 'package:chat_app/screens/search_airport_sheet.dart';
import 'package:chat_app/screens/traveler_selector_sheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlightSearchPanel extends ConsumerStatefulWidget {
  const FlightSearchPanel({super.key});
  @override
  ConsumerState<FlightSearchPanel> createState() => _FlightSearchPanelState();
}

class _FlightSearchPanelState extends ConsumerState<FlightSearchPanel> {
  static const double _padding = 20.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final flightState = ref.watch(flightSearchProvider);
    final controller = ref.read(flightSearchProvider.notifier);

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: _padding),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  // Departure
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide.none,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      onPressed: () async {
                        final result =
                            await showModalBottomSheet<AirportSelection>(
                              context: context,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              builder: (ctx) => const SearchAirportSheet(
                                title: "Airport",
                                isDeparture: true,
                              ),
                            );

                        if (result != null) {
                          controller.setDepartureCode(result.code);
                          controller.setDepartureName(result.name);
                          controller.setDepartureCity(result.city);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.near_me),
                          const SizedBox(width: 8),
                          Text(
                            flightState.departureAirportCode.isEmpty
                                ? 'Departure'
                                : flightState.departureAirportCode,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Arrival
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide.none,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      onPressed: () async {
                        final result =
                            await showModalBottomSheet<AirportSelection>(
                              context: context,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              builder: (ctx) => const SearchAirportSheet(
                                title: "Arrival Airport",
                                isDeparture: false,
                              ),
                            );

                        if (result != null) {
                          controller.setArrivalCode(result.code);
                          controller.setArrivalName(result.name);
                          controller.setArrivalCity(result.city);
                        }
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.swap_calls),
                          const SizedBox(width: 8),
                          Text(
                            flightState.arrivalAirportName.isEmpty
                                ? 'Arrival'
                                : flightState.arrivalAirportCode,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Date + Travelers
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: _padding),
            child: Row(
              children: [
                // Date
                Expanded(
                  flex: 6,
                  child: OutlinedButton(
                    onPressed: () async {
                      final result = await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (ctx) => CalendarSheet(
                          firstTitle: "One Way",
                          secondTitle: "Round Trip",
                          isOnlyTab: false,
                        ),
                      );

                      if (result != null && result['displayDate'] != null) {
                        controller.setDisplayDate(result['displayDate']);
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1,
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_month),
                        const SizedBox(width: _padding),
                        Text(
                          flightState.displayDate ?? 'Select',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Travelers
                Expanded(
                  flex: 4,
                  child: OutlinedButton(
                    onPressed: () async {
                      final result = await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(0),
                          ),
                        ),
                        builder: (ctx) => const TravelerSelectorSheet(),
                      );

                      if (result != null) {
                        final rawPassenger = result['passengerCount'];
                        final rawClassIdx = result['cabinClass'];

                        final pax = rawPassenger is int ? rawPassenger : 1;
                        final cabinIdx = rawClassIdx is int ? rawClassIdx : 0;

                        controller.setPassengers(
                          count: pax,
                          cabinIndex: cabinIdx,
                        );
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1,
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.person),
                        Text(
                          flightState.passengerCount.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Text('|'),
                        const SizedBox(width: 5),
                        const Icon(Icons.airline_seat_recline_normal),
                        Flexible(
                          child: Text(
                            flightState.cabinClass,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8.0),
          // Search button + Recent search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: _padding),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          debugPrint(flightState.toString());
                          final hasPassengers = flightState.passengerCount > 0;
                          final hasAirports =
                              flightState.departureAirportCode.isNotEmpty &&
                              flightState.arrivalAirportCode.isNotEmpty;
                          final hasDate =
                              (flightState.displayDate ?? '').isNotEmpty;

                          if (!hasPassengers || !hasAirports || !hasDate) {
                            return;
                          }

                          controller.addRecentSearch(
                            RecentSearch(
                              destination:
                                  '${flightState.departureCity} - ${flightState.arrivalCity}',
                              tripDateRange: flightState.displayDate ?? '',
                              icons: [
                                const SizedBox(width: 10),
                                Icon(
                                  Icons.person,
                                  color: Colors.grey[500],
                                  size: 20.0,
                                ),
                                Text(flightState.passengerCount.toString()),
                              ],
                              destinationCode:
                                  '${flightState.departureAirportCode} - ${flightState.arrivalAirportCode}',
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.onPrimary,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),

                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Search Flight',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: _padding),
                RecentSearchPanel(panelName: 'flight'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
