import 'package:TFA/providers/airport/airport_lookup.dart';
import 'package:TFA/providers/flight/flight_search_controller.dart';
import 'package:TFA/screens/flight/flight_list_page.dart';
import 'package:flutter/material.dart';
import 'package:TFA/providers/recent_search.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      onTap: () {
        final String kind = search.kind;
        if (kind == 'flight') {
          if (search.departCode == '') return;
          controller.setDepartureCity(depCity);
          // controller.setArrivalCity(arrCity);

          controller.setArrivalCode(search.arrivalCode, arrCity);
          controller.setDepartureCode(search.departCode, depCity);

          if (search.departDate.isNotEmpty && search.returnDate.isNotEmpty) {
            final DateTime dt = DateTime.parse(search.departDate);
            final DateTime rt = DateTime.parse(search.returnDate);
            controller.setTripDates(departDate: dt, returnDate: rt);
          }

          controller.setPassengers(
            count: search.passengerCnt,
            cabinIndex: search.cabinIdx,
            adult: search.adult,
            children: search.children,
            infantLap: search.infantLap,
            infantSeat: search.infantSeat,
          );
        }
        Navigator.of(
          context,
        ).push(MaterialPageRoute<void>(builder: (_) => const FlightListPage()));
      },
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 10.0),
                Text(
                  search.destination,
                  maxLines: 1,
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      search.tripDateRange,
                      maxLines: 1,
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: Theme.of(
                          context,
                        ).textTheme.bodySmall?.fontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[500],
                      ),
                    ),
                    ...search.icons,
                  ],
                ),
                const SizedBox(height: 10.0),
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Column(
                children: <Widget>[
                  Text(
                    search.destinationCode,
                    style: TextStyle(
                      fontSize: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
