import 'package:TFA/providers/airport/airport_provider.dart';
import 'package:TFA/providers/airport/airport_selection.dart';
import 'package:TFA/providers/recent_search.dart';
import 'package:TFA/providers/flight/flight_search_controller.dart';
import 'package:TFA/screens/flight/flight_list_page.dart';
import 'package:TFA/screens/shared/recent_search_panel.dart';
import 'package:TFA/screens/shared/search_airport_sheet.dart';
import 'package:TFA/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:TFA/screens/shared/calendar_sheet.dart';
import 'package:TFA/screens/shared/traveler_selector_sheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
          debugPrint("📍 set iataCode: ${filteredAirports[0].iataCode}");
          return;
        }
        debugPrint("📍 set default iataCode: JFK");
      }
    } catch (e) {
      debugPrint("❌ Location error: $e");
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
    final flightState = ref.watch(flightSearchProvider);

    // final flights = flightState.flightResults.maybeWhen(
    //   data: (value) => value,
    //   orElse: () => [],
    // );

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
                          Align(
                            alignment: Alignment.centerLeft,
                            child: _isLoadingCity
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                    ),
                                  )
                                : Text(
                                    flightState.departureAirportCode.isEmpty
                                        ? 'Departure'
                                        : flightState.departureAirportCode,
                                    style: TextStyle(
                                      fontSize: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.fontSize,
                                      fontWeight: FontWeight.bold,
                                    ),
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
                              fontSize: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.fontSize,
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
                          key: UniqueKey(),
                          firstTitle: "One Way",
                          secondTitle: "Round Trip",
                          isOnlyTab: false,
                          isRange: false,
                          startDays: 0,
                          endDays: 0,
                        ),
                      );

                      if (result != null) {
                        controller.setDepartDate(result['startDate']);
                        controller.setReturnDate(result['endDate']);
                        controller.setDisplayDate(
                          startDate: result['startDate'],
                          endDate: result['endDate'],
                        );
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 3),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1,
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(Icons.calendar_month),
                        Text(
                          flightState.displayDate ?? 'Select',
                          style: TextStyle(
                            fontSize: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.fontSize,
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
                            fontSize: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.fontSize,
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
                              fontSize: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.fontSize,
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
                        onPressed: () async {
                          debugPrint('===Search Flight===');
                          debugPrint(flightState.toString());

                          // final (
                          //   searchSuccess,
                          //   searchMessage,
                          // ) = await controller.searchFlights(
                          //   origin: flightState.departureAirportCode,
                          //   destination: flightState.arrivalAirportCode,
                          //   departureDate: flightState.departDate,
                          //   returnDate: flightState.returnDate,
                          //   adults: flightState.passengerCount,
                          // );

                          // if (!searchSuccess) {
                          //   ScaffoldMessenger.of(context).showSnackBar(
                          //     SnackBar(content: Text(searchMessage)),
                          //   );
                          //   return;
                          // }
                          // debugPrint('flight search successful');

                          // // 🔍 Debug print each flight (pretty JSON)
                          // for (var i = 0; i < flights.length; i++) {
                          //   final pretty = const JsonEncoder.withIndent(
                          //     '  ',
                          //   ).convert(flights[i]);
                          //   debugPrint('✈️ Flight #$i:\n$pretty');
                          // }

                          final hasPassengers = flightState.passengerCount > 0;
                          final hasAirports =
                              flightState.departureAirportCode.isNotEmpty &&
                              flightState.arrivalAirportCode.isNotEmpty;
                          final hasDate =
                              (flightState.displayDate ?? '').isNotEmpty;

                          if (!hasPassengers || !hasAirports || !hasDate) {
                            return;
                          }

                          final idToken = await user!.getIdToken();

                          bool success = await controller.addRecentSearch(
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
                              guests: flightState.passengerCount,
                              rooms: 0,
                              kind: 'flight',
                            ),
                            idToken!,
                          );

                          if (!success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '❌ Failed to save flight recent search',
                                ),
                              ),
                            );
                          }

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const FlightListPage(),
                            ),
                          );
                        }, // onpressed end
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

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
