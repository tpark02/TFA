// lib/screens/flight/anywhere_list_page.dart
import 'dart:async';

import 'package:TFA/models/anywhere_destination.dart';
import 'package:TFA/providers/flight/anywhere_provider.dart';
import 'package:TFA/providers/flight/flight_search_controller.dart';
import 'package:TFA/providers/flight/flight_search_state.dart';
import 'package:TFA/screens/flight/anywhere_map_screen.dart';
import 'package:TFA/screens/flight/flight_list_page.dart';
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
  late final ProviderSubscription<FlightSearchState> _stateSub;

  bool _isMapSelected = false;

  // bool _hasSubscribed = false;

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();

  //   if (_hasSubscribed) return;
  //   _hasSubscribed = true;

  //   _stateSub = ref.listenManual<FlightSearchState>(flightSearchProvider, (
  //     prev,
  //     next,
  //   ) {
  //     debugPrint('🎯 listenManual fired: $prev → $next');
  //     if (prev != next) {
  //       WidgetsBinding.instance.addPostFrameCallback((_) {
  //         if (!mounted) return;

  //         if (next.arrivalAirportCode == 'anywhere' ||
  //             (prev != null && prev.arrivalAirportCode == 'anywhere')) {
  //           return;
  //         }
  //         Navigator.of(
  //           context,
  //         ).push(MaterialPageRoute<void>(builder: (_) => FlightListPage()));
  //       });
  //     }
  //   }, fireImmediately: false);
  // }

  @override
  void initState() {
    super.initState();

    _sub = ref.listenManual<bool>(
      flightSearchProvider.select((FlightSearchState s) => s.isLoading),
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

    _stateSub = ref.listenManual<FlightSearchState>(flightSearchProvider, (
      FlightSearchState? prev,
      FlightSearchState next,
    ) {
      debugPrint('🎯 listenManual fired: $prev → $next');
      if (prev != null &&
          ((prev.arrivalAirportCode != next.arrivalAirportCode) ||
              (prev.departureAirportCode != next.departureAirportCode) ||
              (prev.departDate != next.departDate) ||
              (prev.returnDate != next.returnDate) ||
              (prev.cabinIdx != next.cabinIdx) ||
              (prev.adultCnt != next.adultCnt) ||
              (prev.childrenCnt != next.childrenCnt) ||
              (prev.infantLapCnt != next.infantLapCnt) ||
              (prev.infantSeatCnt != next.infantSeatCnt))) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;

          if (next.arrivalAirportCode == 'anywhere') {
            return;
          }
          Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const FlightListPage()),
          );
        });
      }
    }, fireImmediately: false);
  }

  @override
  void dispose() {
    _t?.cancel();
    _sub.close();
    _stateSub.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<AnywhereDestination>> tiles = ref.watch(
      anywhereDestinationsProvider,
    );
    final FlightSearchState flightState = ref.watch(flightSearchProvider);
    final FlightSearchController controller = ref.read(
      flightSearchProvider.notifier,
    );
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
        children: <Widget>[
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
                    // onTap: () {
                    //   Navigator.of(context).push(
                    //     MaterialPageRoute<void>(
                    //       builder: (_) => const AnywhereMapScreen(),
                    //     ),
                    //   );
                    // },
                    onTap: () {
                      setState(() {
                        _isMapSelected = !_isMapSelected;
                      });
                    },
                    child: _isMapSelected
                        ? const Icon(Icons.list, color: Colors.white)
                        : const Icon(Icons.map_outlined, color: Colors.white),
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
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              child: _show
                  ? SearchSummaryLoadingCard(
                      routeText:
                          '${flightState.departureAirportCode} - Anywhere',
                      dateText: flightState.displayDate ?? '',
                    )
                  : _isMapSelected
                  ? const AnywhereMapScreen()
                  : tiles.when(
                      data: (List<AnywhereDestination> items) => ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        itemCount: items.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (BuildContext context, int i) =>
                            AnywhereDestinationTile(
                              item: items[i],
                              onTap: () {
                                debugPrint(
                                  '☘️ anywhere_list_page.dart - Tapped: ${items[i].name}',
                                );
                                controller.setArrivalCode(items[i].iata);
                                controller.setArrivalCity(items[i].name);
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
                        itemBuilder: (_, __) => const SkeletonCard(),
                      ),
                      error: (Object e, _) =>
                          Center(child: Text('Failed to load: $e')),
                    ),
            ),
          ),
        ],
      ),
      // Your bottom nav already exists; plug this page into the Search tab.
    );
  }
}

class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: AnywhereDestinationTile.height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: <Widget>[
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
              children: <Widget>[
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
