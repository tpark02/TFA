import 'package:TFA/providers/airport/airport_selection.dart';
import 'package:TFA/providers/flight/flight_search_controller.dart';
import 'package:TFA/screens/shared/calendar_sheet.dart';
import 'package:TFA/screens/shared/search_airport_sheet.dart';
import 'package:TFA/screens/shared/traveler_selector_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    ref.watch(flightSearchProvider);

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
                        await showModalBottomSheet<AirportSelection>(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (BuildContext ctx) =>
                              const SearchAirportSheet(
                                title: 'Origin',
                                isDeparture: true,
                              ),
                        );

                    if (result != null) {
                      controller.setDepartureCode(result.code);
                      // controller.setDepartureName(result.name);
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
                    : Icon(
                        Icons.compare_arrows,
                        color: Colors.white,
                        size: Theme.of(context).textTheme.bodyMedium?.fontSize,
                      ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: InkWell(
                  onTap: () async {
                    final AirportSelection? result =
                        await showModalBottomSheet<AirportSelection>(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (BuildContext ctx) =>
                              const SearchAirportSheet(
                                title: 'Destination',
                                isDeparture: false,
                              ),
                        );

                    if (result != null) {
                      controller.setArrivalCode(result.code);
                      // controller.setArrivalName(result.name);
                      controller.setArrivalCity(result.city);
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
                  final result = await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (BuildContext ctx) => CalendarSheet(
                      key: UniqueKey(),
                      firstTitle: 'One Way',
                      secondTitle: 'Round Trip',
                      isOnlyTab: false,
                      isRange: false,
                      startDays: 0,
                      endDays: 0,
                    ),
                  );

                  if (result != null) {
                    final DateTime? startDate = result['startDate'];
                    final DateTime? endDate = result['endDate'];

                    debugPrint(
                      "📅📅📅 selected dates start date : $startDate, end date : $endDate",
                    );
                    controller.setDepartDate(startDate);

                    if (endDate == null) {
                      controller.setClearReturnDate(true);
                    } else {
                      controller.setClearReturnDate(false);
                      controller.setReturnDate(endDate);
                    }

                    controller.setDisplayDate(
                      startDate: result['startDate'],
                      endDate: result['endDate'],
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
                    final result = await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (BuildContext ctx) =>
                          const TravelerSelectorSheet(),
                    );

                    if (result != null) {
                      final pax = result['passengerCount'] ?? 1;
                      final cabin = result['cabinClass'] ?? 0;
                      controller.setPassengers(count: pax, cabinIndex: cabin);
                    }
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
