// lib/screens/flight/anywhere_list_page.dart
import 'dart:async';

import 'package:TFA/providers/flight/anywhere_provider.dart';
import 'package:TFA/providers/flight/flight_search_controller.dart';
import 'package:TFA/providers/flight/flight_search_state.dart';
import 'package:TFA/widgets/flight/anywhere_destination_tile.dart';
import 'package:TFA/widgets/search_summary_card.dart';
import 'package:TFA/widgets/search_summary_loading_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnywhereListPage extends ConsumerStatefulWidget {
  const AnywhereListPage({super.key});
  @override
  ConsumerState<AnywhereListPage> createState() => _AnywhereListState();
}

class _AnywhereListState extends ConsumerState<AnywhereListPage> {
  Timer? _t;
  bool _show = false;
  late final ProviderSubscription<bool> _sub;

  @override
  void initState() {
    super.initState();

    _sub = ref.listenManual<bool>(
      flightSearchProvider.select((s) => s.isLoading),
      (bool? prev, bool isLoading) {
        _t?.cancel();

        if (isLoading) {
          setState(() => _show = true);
          _t = Timer(const Duration(seconds: 2), () {
            if (!mounted) return;
            ref.read(flightSearchProvider.notifier).setLoading(false);
          });
        } else {
          setState(() => _show = false);
        }
      },
      fireImmediately: true,
    );
  }

  @override
  void dispose() {
    _t?.cancel();
    _sub.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(anywhereDestinationsProvider);
    final FlightSearchState flightState = ref.watch(flightSearchProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: Container(
          color: Theme.of(context).colorScheme.primary,
          child: const SizedBox(height: 30),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).colorScheme.primary,
            padding: const EdgeInsets.fromLTRB(
              0,
              30,
              0,
              10,
            ), // status bar spacing
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: 250,
                  child: SearchSummaryCard(
                    from: flightState.departureAirportCode,
                    to: flightState.arrivalAirportCode,
                    dateRange: flightState.displayDate ?? '',
                    passengerCount: flightState.passengerCount,
                    cabinClass: flightState.cabinClass,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),

                  child: InkWell(
                    onTap: () {},
                    child: const Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),

                  child: InkWell(
                    onTap: () {},
                    child: const Icon(Icons.share, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const ColoredBox(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Center(child: Text('Prices are not real-time.')),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _show
                ? SearchSummaryLoadingCard(
                    routeText: '${flightState.departureAirportCode} - Anywhere',
                    dateText: flightState.displayDate ?? '',
                  )
                : data.when(
                    data: (items) => ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) => AnywhereDestinationTile(
                        item: items[i],
                        onTap: () {
                          // TODO: navigate to flight list with origin/dates prefilled
                          debugPrint('Tapped: ${items[i].name}');
                        },
                      ),
                    ),
                    loading: () => ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      itemCount: 6,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, __) => _SkeletonCard(),
                    ),
                    error: (e, _) => Center(child: Text('Failed to load: $e')),
                  ),
          ),
        ],
      ),
      // Your bottom nav already exists; plug this page into the Search tab.
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 108,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 18, width: 140, color: Colors.black12),
                const SizedBox(height: 10),
                Container(height: 14, width: 90, color: Colors.black12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
