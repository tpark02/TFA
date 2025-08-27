import 'package:TFA/providers/airport/airport_lookup.dart';
import 'package:TFA/providers/flight/flight_search_controller.dart';
import 'package:TFA/screens/flight/flight_list_page.dart';
import 'package:flutter/material.dart';
import 'package:TFA/providers/recent_search.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class RecentSearchItem extends ConsumerWidget {
  const RecentSearchItem({super.key, required this.search});
  final RecentSearch search;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FlightSearchController controller = ref.read(
      flightSearchProvider.notifier,
    );
    final String depCity =
        ref.watch(cityByIataProvider(search.departCode)) ?? search.departCode;
    final String arrCity =
        ref.watch(cityByIataProvider(search.arrivalCode)) ?? search.arrivalCode;

    return InkWell(
      onTap: () async {
        if (search.kind == 'flight' && search.departCode.isNotEmpty) {
          controller.setDepartureCity(depCity);
          controller.setArrivalCode(search.arrivalCode, arrCity);
          controller.setDepartureCode(search.departCode, depCity);
          if (search.departDate.isNotEmpty && search.returnDate.isNotEmpty) {
            controller.setTripDates(
              departDate: DateTime.parse(search.departDate),
              returnDate: DateTime.parse(search.returnDate),
            );
          }
          controller.setPassengers(
            count: search.passengerCnt,
            cabinIndex: search.cabinIdx,
            adult: search.adult,
            children: search.children,
            infantLap: search.infantLap,
            infantSeat: search.infantSeat,
          );
          // controller.updateSearch(
          //   // airports
          //   departureCode: search.departCode,
          //   departureCity: depCity,
          //   arrivalCode: search.arrivalCode,
          //   arrivalCity: arrCity,

          //   // dates: if returnDate is empty → clear it (one-way)
          //   departDate: search.departDate.isNotEmpty
          //       ? DateTime.parse(search.departDate)
          //       : null,
          //   returnDate: search.returnDate.isNotEmpty
          //       ? DateTime.parse(search.returnDate)
          //       : null,
          //   clearReturnDate: search.returnDate.isEmpty, // one-way toggle
          //   // pax / cabin
          //   passengerCount: search.passengerCnt,
          //   cabinIndex: search.cabinIdx,
          //   adult: search.adult,
          //   children: search.children,
          //   infantLap: search.infantLap,
          //   infantSeat: search.infantSeat,
          // );
        }
        // Navigator.of(
        //   context,
        // ).push(MaterialPageRoute<void>(builder: (_) => const FlightListPage()));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // LEFT (Destination + Date+Icons)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    search.destination,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.fontSize,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Date + icons (grouped together)
                  Row(
                    mainAxisSize: MainAxisSize.min, // 🟢 Keep it tight
                    children: <Widget>[
                      Text(
                        search.tripDateRange,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: Theme.of(
                            context,
                          ).textTheme.bodySmall?.fontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[500],
                        ),
                      ),
                      const SizedBox(width: 6),
                      ...search.icons, // 🟢 Icons now hug the text
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // RIGHT (Code + Arrow)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  search.destinationCode,
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                search.destinationCode.isEmpty
                    ? const SizedBox.shrink()
                    : const Icon(
                        Icons.chevron_right,
                        size: 20,
                        color: Colors.grey,
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
