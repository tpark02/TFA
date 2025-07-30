import 'package:chat_app/providers/car/car_search_controller.dart';
import 'package:chat_app/providers/hotel/hotel_search_controller.dart';
import 'package:chat_app/providers/recent_search.dart';
import 'package:chat_app/providers/flight_search_controller.dart';
import 'package:chat_app/screens/recent_search_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecentSearchPanel extends ConsumerWidget {
  const RecentSearchPanel({super.key, required this.panelName});

  final String panelName;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<RecentSearch> searches = [];

    if (panelName == 'flight') {
      final fstate = ref.watch(flightSearchProvider);
      searches = fstate.recentSearches;
    } else if (panelName == 'hotel') {
      final hstate = ref.watch(hotelSearchProvider);
      searches = hstate.recentSearches;
    } else {
      final cstate = ref.watch(carSearchProvider);
      searches = cstate.recentSearches;
    }
    // Always produce 5 items, fill with empty ones if needed
    final paddedSearches = List<RecentSearch>.generate(
      5,
      (i) => i < searches.length
          ? searches[i]
          : const RecentSearch(
              destination: '',
              tripDateRange: '',
              icons: [],
              destinationCode: '',
            ),
    );

    if (searches.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Recent searches",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: paddedSearches.length,
          itemBuilder: (context, index) {
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
