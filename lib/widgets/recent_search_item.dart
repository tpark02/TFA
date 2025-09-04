import 'package:TFA/providers/airport/airport_lookup.dart';
import 'package:TFA/providers/flight/flight_search_controller.dart';
import 'package:flutter/material.dart';
import 'package:TFA/providers/recent_search.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecentSearchItem extends ConsumerWidget {
  const RecentSearchItem({super.key, required this.search});
  final RecentSearch search;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

    final FlightSearchController controller = ref.read(flightSearchProvider.notifier);
    final String depCity =
        ref.watch(cityByIataProvider(search.departCode)) ?? search.departCode;
    final String arrCity =
        ref.watch(cityByIataProvider(search.arrivalCode)) ?? search.arrivalCode;

    return InkWell(
      onTap: () async {
        if (search.kind == 'flight' && search.departCode.isNotEmpty) {
          // Replace all the individual setters with a single call:
          controller.clearProcessedFlights();
          controller.updateSearch(
            // airports
            departureCode: search.departCode,
            departureCity: depCity,
            arrivalCode: search.arrivalCode,
            arrivalCity: arrCity,

            // dates
            departDate: search.departDate.isNotEmpty
                ? DateTime.parse(search.departDate)
                : null,
            returnDate: search.returnDate.isNotEmpty
                ? DateTime.parse(search.returnDate)
                : null,
            clearReturnDate:
                search.returnDate.isEmpty, // remove return if empty
            // pax / cabin
            passengerCount: search.passengerCnt,
            cabinIndex: search.cabinIdx,
            adult: search.adult,
            children: search.children,
            infantLap: search.infantLap,
            infantSeat: search.infantSeat,
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    search.destination,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: tt.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        search.tripDateRange,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: tt.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 6),
                      ...search.icons,
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  search.destinationCode,
                  style: tt.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(width: 4),
                if (search.destinationCode.isNotEmpty)
                  Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: cs.onSurfaceVariant,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
