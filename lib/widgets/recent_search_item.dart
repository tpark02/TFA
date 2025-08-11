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
    final controller = ref.read(flightSearchProvider.notifier);

    return InkWell(
      onTap: () {
        String kind = search.kind;
        if (kind == 'flight') {
          controller.setArrivalCode(search.arrivalCode);
          controller.setDepartureCode(search.departCode);
          controller.setDepartDate(DateTime.parse(search.departDate));
          if (search.returnDate == '') {
            controller.setClearReturnDate(true);
            // controller.setReturnDate(DateTime.parse(search.returnDate));
          } else {
            controller.setClearReturnDate(false);
            controller.setReturnDate(DateTime.parse(search.returnDate));
          }

          controller.setPassengers(count: search.guests, cabinIndex: 1);
        }
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const FlightListPage()));
      },
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10.0),
              Text(
                search.destination,
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Row(
                children: [
                  Text(
                    search.tripDateRange,
                    style: TextStyle(
                      fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
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
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Column(
                children: [
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
