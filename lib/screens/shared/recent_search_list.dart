// lib/screens/shared/recent_search_list.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:TFA/l10n/app_localizations.dart';
import 'package:TFA/providers/car/car_search_controller.dart';
import 'package:TFA/providers/flight/flight_search_controller.dart';
import 'package:TFA/providers/hotel/hotel_search_controller.dart';
import 'package:TFA/providers/recent_search.dart';
import 'package:TFA/widgets/recent_search_item.dart';

class RecentSearchList extends ConsumerWidget {
  const RecentSearchList({super.key, required this.panelName});
  final String panelName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    // Select correct provider based on panelName
    final List<RecentSearch> searches = switch (panelName) {
      'flight' => ref.watch(flightSearchProvider).recentSearches,
      'hotel' => ref.watch(hotelSearchProvider).recentSearches,
      _ => ref.watch(carSearchProvider).recentSearches,
    };

    // Always generate 5 placeholders for consistent height
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

    final text = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          text.recent_searches,
          style: tt.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: cs.onSurface,
          ),
        ),
        const SizedBox(height: 20),

        // Show empty state or recent searches
        if (searches.isEmpty) ...[
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Column(
                children: [
                  Icon(
                    Icons.image_outlined,
                    size: 96,
                    color: cs.onSurfaceVariant,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    text.no_recent_searches,
                    textAlign: TextAlign.center,
                    style: tt.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ] else ...[
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
