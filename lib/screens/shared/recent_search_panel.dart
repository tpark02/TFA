import 'package:TFA/providers/car/car_search_controller.dart';
import 'package:TFA/providers/car/car_search_state.dart';
import 'package:TFA/providers/flight/flight_search_state.dart';
import 'package:TFA/providers/hotel/hotel_search_controller.dart';
import 'package:TFA/providers/hotel/hotel_search_state.dart';
import 'package:TFA/providers/recent_search.dart';
import 'package:TFA/providers/flight/flight_search_controller.dart';
import 'package:TFA/widgets/recent_search_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecentSearchPanel extends ConsumerWidget {
  const RecentSearchPanel({super.key, required this.panelName});

  final String panelName;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<RecentSearch> searches = <RecentSearch>[];
    String kind = '';

    if (panelName == 'flight') {
      final FlightSearchState fstate = ref.watch(flightSearchProvider);
      searches = fstate.recentSearches;
      kind = 'flight';
    } else if (panelName == 'hotel') {
      final HotelSearchState hstate = ref.watch(hotelSearchProvider);
      searches = hstate.recentSearches;
      kind = 'hotel';
    } else {
      final CarSearchState cstate = ref.watch(carSearchProvider);
      searches = cstate.recentSearches;
      kind = 'car';
    }
    // Always produce 5 items, fill with empty ones if needed
    final List<RecentSearch> paddedSearches = List<RecentSearch>.generate(
      5,
      (int i) => i < searches.length
          ? searches[i]
          : const RecentSearch(
              destination: '',
              tripDateRange: '',
              icons: <Widget>[],
              destinationCode: '',
              passengerCnt: 0,
              rooms: 0,
              kind: 'flight',
              departCode: '',
              arrivalCode: '',
              departDate: '',
              returnDate: '',
            ),
    );

    // if (searches.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Recent searches",
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.headlineMedium?.fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: paddedSearches.length,
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(
              width: double.infinity,
              child: RecentSearchItem(search: paddedSearches[index]),
            );
          },
          // separatorBuilder: (context, index) =>
          // const Divider(color: Colors.grey, thickness: 0.5, height: 10),
        ),
      ],
    );
  }
}
