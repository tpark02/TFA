import 'package:TFA/l10n/app_localizations.dart';
import 'package:TFA/providers/car/car_search_controller.dart';
import 'package:TFA/providers/flight/flight_search_controller.dart';
import 'package:TFA/providers/hotel/hotel_search_controller.dart';
import 'package:TFA/providers/recent_search.dart';
import 'package:TFA/widgets/recent_search_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecentSearchList extends ConsumerWidget {
  const RecentSearchList({super.key, required this.panelName});
  final String panelName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<RecentSearch> searches = switch (panelName) {
      'flight' => ref.watch(flightSearchProvider).recentSearches,
      'hotel' => ref.watch(hotelSearchProvider).recentSearches,
      _ => ref.watch(carSearchProvider).recentSearches,
    };

    // pad to 5 rows for consistent layout
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

    final titleStyle = TextStyle(
      fontSize: Theme.of(context).textTheme.headlineMedium?.fontSize,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.onSurface,
    );
    final text = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Text(text.recent_searches, style: titleStyle),
        ),
        const SizedBox(height: 20),
        // ✅ Proper conditional branches
        if (searches.isNotEmpty) ...[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 30),
              const Icon(Icons.image_outlined, size: 96, color: Colors.black12),
              const SizedBox(height: 30),
              Text(
                text.no_recent_searches,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 18,
                  height: 1.35,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              // SizedBox(height: 20),
            ],
          ),
        ] else ...<Widget>[
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
          ),
        ],
      ],
    );
  }
}
