import 'package:TFA/providers/airport/airport_selection.dart';
import 'package:TFA/providers/flight/flight_search_controller.dart';
import 'package:TFA/providers/flight/flight_search_state.dart';
import 'package:TFA/screens/shared/calendar_sheet.dart';
import 'package:TFA/screens/shared/search_airport_sheet.dart';
import 'package:TFA/screens/shared/traveler_selector_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SearchSummaryCard extends ConsumerWidget {
  final String from;
  final String to;
  final String dateRange;
  final int passengerCount;
  final String cabinClass;

  const SearchSummaryCard({
    super.key,
    required this.from,
    required this.to,
    required this.dateRange,
    required this.passengerCount,
    required this.cabinClass,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FlightSearchController controller = ref.read(
      flightSearchProvider.notifier,
    );
    final FlightSearchState flightState = ref.watch(flightSearchProvider);

    return Container(
      padding: const EdgeInsets.all(8),
      color: Theme.of(context).colorScheme.secondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Flexible(
                child: InkWell(
                  onTap: () async {
                    final AirportSelection? result =
                        await CupertinoScaffold.showCupertinoModalBottomSheet(
                          context: context,
                          useRootNavigator: true,
                          expand: false, // page sheet instead of full screen
                          builder: (_) => const SearchAirportSheet(
                            title: 'Origin',
                            isDeparture: true,
                          ),
                        );

                    if (result != null) {
                      if (result.code == flightState.arrivalAirportCode) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "❌ Departure airport cannot be the same as the arrival airport.",
                              ),
                            ),
                          );
                        });
                        return;
                      }
                      controller.setDepartureCode(result.code);
                      controller.setDepartureCity(result.city);
                    }
                  },
                  child: Text(
                    from,
                    style: TextStyle(
                      fontSize: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: () {
                  // handle arrow click
                },
                child: controller.returnDate == null
                    ? Icon(
                        Icons.arrow_right_alt,
                        color: Colors.white,
                        size: Theme.of(context).textTheme.bodyMedium?.fontSize,
                      )
                    : InkWell(
                        onTap: () {
                          final String d = flightState.departureAirportCode;
                          final String a = flightState.arrivalAirportCode;

                          final String dcity = flightState.departureCity;
                          final String acity = flightState.arrivalCity;

                          debugPrint(
                            "☘️ search_summary.dart - before swap departure : $d, arrival : $a",
                          );
                          controller.setArrivalCode(d);
                          controller.setDepartureCode(a);

                          controller.setArrivalCity(dcity);
                          controller.setDepartureCity(acity);
                        },
                        child: Icon(
                          Icons.compare_arrows,
                          color: Colors.white,
                          size: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.fontSize,
                        ),
                      ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: InkWell(
                  onTap: () async {
                    final AirportSelection? result =
                        await CupertinoScaffold.showCupertinoModalBottomSheet(
                          context: context,
                          useRootNavigator: true,
                          expand: false, // page sheet instead of full screen
                          builder: (_) => const SearchAirportSheet(
                            title: 'Destination',
                            isDeparture: false,
                          ),
                        );

                    if (result != null) {
                      if (result.code == flightState.departureAirportCode) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "❌ Arrival airport cannot be the same as the departure airport.",
                              ),
                            ),
                          );
                        });
                        controller.setArrivalCode(result.code);
                        controller.setArrivalCity(result.city);
                      }
                    }
                  },
                  child: Text(
                    to,
                    style: TextStyle(
                      fontSize: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextButton(
                onPressed: () async {
                  final Map<String, DateTime?>? result =
                      await Navigator.of(
                        context,
                        rootNavigator: true,
                      ).push<Map<String, DateTime?>>(
                        MaterialPageRoute<Map<String, DateTime?>>(
                          builder: (_) => CalendarSheet(
                            key: UniqueKey(),
                            firstTitle: 'One Way',
                            secondTitle: 'Round Trip',
                            isOnlyTab: false,
                            isRange: false,
                            startDays: 0,
                            endDays: 0,
                          ),
                        ),
                      );

                  if (result != null) {
                    final DateTime? departDate = result['departDate'];
                    final DateTime? returnDate = result['returnDate'];

                    controller.setTripDates(
                      departDate: departDate!,
                      returnDate: returnDate,
                    );
                    debugPrint(
                      "📅 selected dates depart date : $departDate, end date : ${returnDate ?? "empty"}",
                    );
                  }
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  dateRange,
                  style: const TextStyle(color: Colors.white),
                ),
              ),

              Flexible(
                child: InkWell(
                  onTap: () async {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (BuildContext ctx) =>
                          TravelerSelectorSheet(cabinIdx: flightState.cabinIdx),
                    );

                    // if (result != null) {
                    //   final pax = result['passengerCount'] ?? 1;
                    //   final cabinIdx = result['cabinIdx'] ?? 0;
                    //   final adult = result['adult'] ?? 0;
                    //   final children = result['children'] ?? 0;
                    //   final infantLap = result['infantLap'] ?? 0;
                    //   final infantSeat = result['infantSeat'] ?? 0;

                    //   final String cabinClass = getCabinClassByIdx(
                    //     cabinIndex: cabinIdx,
                    //   );
                    //   controller.setPassengers(
                    //     count: pax,
                    //     cabinIndex: cabinIdx,
                    //     adult: adult,
                    //     children: children,
                    //     infantLap: infantLap,
                    //     infantSeat: infantSeat,
                    //     cabinClass: cabinClass,
                    //   );
                    // }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(width: 5),
                      const Text("|", style: TextStyle(color: Colors.white)),
                      const SizedBox(width: 5),
                      const Icon(Icons.person, color: Colors.white, size: 16),
                      const SizedBox(width: 5),
                      Text(
                        passengerCount.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(width: 5),
                      const Text("|", style: TextStyle(color: Colors.white)),
                      const SizedBox(width: 5),
                      const Icon(
                        Icons.airline_seat_recline_normal,
                        color: Colors.white,
                        size: 16,
                      ),
                      Flexible(
                        child: Text(
                          cabinClass,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
