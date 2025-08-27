import 'dart:io';
import 'dart:math';

import 'package:TFA/providers/flight/flight_search_controller.dart';
import 'package:TFA/providers/flight/flight_search_state.dart';
import 'package:TFA/providers/sort_tab_provider.dart';
import 'package:TFA/screens/flight/flight_filter_screen.dart';
import 'package:TFA/utils/utils.dart';
import 'package:TFA/widgets/filter_button.dart';
import 'package:TFA/widgets/flight/flight_list_view.dart';
import 'package:TFA/widgets/sort_sheets/range_picker_sheet.dart';
import 'package:TFA/widgets/sort_sheets/selection_bottom_sheet.dart';
import 'package:TFA/widgets/sort_sheets/sort_bottom_sheet.dart';
import 'package:TFA/screens/flight/flight_search_summary_card.dart';
import 'package:TFA/widgets/search_summary_loading_card.dart';
import 'package:TFA/widgets/sort_sheets/travel_hack_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class FlightListPage extends ConsumerStatefulWidget {
  const FlightListPage({super.key});
  @override
  ConsumerState<FlightListPage> createState() => _FlightListPageState();
}

class _FlightListPageState extends ConsumerState<FlightListPage> {
  String selectedSort = 'Cost';
  String selectedStops = 'Up to 2 stops';
  RangeValues takeoffRange = const RangeValues(0, 1439);
  RangeValues landingRange = const RangeValues(0, 1439);
  RangeValues flightDurationRange = const RangeValues(0, 1440);
  RangeValues layOverDurationRange = const RangeValues(0, 1470);
  Set<String> selectedAirlines = <String>{};
  Set<String> selectedLayovers = <String>{};
  List<String> kAirlines = <String>[];
  List<String> kLayoverCities = <String>[];
  int flightDurationSt = 0;
  int flightDurationEnd = 0;
  int layOverDurationSt = 0;
  int layOverDurationEnd = 0;
  // late final ProviderSubscription<FlightSearchState> _sub;
  // bool _rtFetching = false;

  Map<String, String> carriersDict = <String, String>{}; // <-- add this

  Widget _pageBody(BuildContext context, FlightSearchState flightState) {
    final bool isLoading = flightState.isLoading;
    int minDuration = 1000000, maxDuration = 0;
    int minLayOver = 1000000, maxLayOver = 0;

    for (Map<String, dynamic> e in flightState.processedFlights) {
      final List<String> lst = e['layOverAirports'] as List<String>;
      if (lst.isNotEmpty) {
        for (String l in lst) {
          if (!kLayoverCities.contains(l)) kLayoverCities.add(l);
        }
      }
      final airline = e['airline'] as String;
      if (!kAirlines.contains(airline)) kAirlines.add(airline);

      minDuration = min(minDuration, e['durationMin']);
      maxDuration = max(maxDuration, e['durationMin']);
      minLayOver = min(minLayOver, e['layoverMin']);
      maxLayOver = max(maxLayOver, e['layoverMin']);
    }

    flightDurationRange = RangeValues(
      minDuration.toDouble(),
      maxDuration.toDouble(),
    );
    layOverDurationRange = RangeValues(
      minLayOver.toDouble(),
      maxLayOver.toDouble(),
    );

    final List<Widget> content = [
      Container(
        color: Theme.of(context).colorScheme.primary,
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10), // status bar spacing
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
                child: const Icon(Icons.arrow_back_ios, color: Colors.white),
              ),
            ),
            SizedBox(
              width: 250,
              child: FlightSearchSummaryCard(
                from: flightState.departureAirportCode,
                to: flightState.arrivalAirportCode,
                dateRange: flightState.displayDate ?? '',
                passengerCount: flightState.passengerCount.toString(),
                cabinClass: flightState.cabinClass,
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),

              child: InkWell(
                onTap: () {},
                child: const Icon(Icons.favorite_border, color: Colors.white),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),

              child: InkWell(
                onTap: () {},
                child: Platform.isIOS
                    ? const Icon(Icons.ios_share, color: Colors.white)
                    : const Icon(Icons.share, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      Container(
        color: Colors.grey[200],
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(left: 8),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(10),
                    backgroundColor: Colors.white,
                    minimumSize: const Size(0, 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    side: BorderSide(color: Colors.grey[400]!, width: 1),
                  ),
                  onPressed: () async {
                    final Map<String, List<String>>? result =
                        await Navigator.of(
                          context,
                          rootNavigator: true,
                        ).push<Map<String, List<String>>>(
                          MaterialPageRoute<Map<String, List<String>>>(
                            fullscreenDialog: true,
                            builder: (_) => FlightFilterScreen(
                              selectedAirlines: selectedAirlines,
                              selectedLayovers: selectedLayovers,
                              kAirlines: kAirlines,
                              kLayoverCities: kLayoverCities,
                              carriersDict: carriersDict,
                            ),
                          ),
                        );

                    if (result != null) {
                      setState(() {
                        selectedAirlines =
                            result['airlines']?.toSet() ?? selectedAirlines;
                        selectedLayovers =
                            result['layovers']?.toSet() ?? selectedLayovers;
                      });
                    }
                  },
                  child: const Icon(Icons.tune, size: 23),
                ),
              ),
              FilterButton(
                label: "Sort: $selectedSort",
                func: () {
                  showSortBottomSheet(
                    title: "Sort",
                    context: context,
                    selectedSort: selectedSort,
                    sortType: SortTab.sort,
                    onSortSelected: (String value) {
                      setState(() => selectedSort = value);
                    },
                  );
                },
              ),
              FilterButton(
                label: "Travel Hacks",
                func: () {
                  showModalBottomSheet(
                    context: context,
                    useRootNavigator: true,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    builder: (BuildContext context) =>
                        const TravelHackBottomSheet(),
                  );
                },
              ),
              FilterButton(
                label: "Stops: $selectedStops",
                func: () {
                  showSortBottomSheet(
                    title: "Stops",
                    context: context,
                    selectedSort: selectedStops,
                    sortType: SortTab.stops,
                    onSortSelected: (String value) {
                      setState(
                        () => selectedStops = value,
                      ); // update parent state
                    },
                  );
                },
              ),
              FilterButton(
                label: "Take Off",
                func: () async {
                  await showRangePickerSheet(
                    context: context,
                    sheet: RangePickerSheet(
                      title: 'Take Off',
                      min: 0, // min possible minutes
                      max: 1439, // max possible minutes
                      divisions: 1439,
                      initial: takeoffRange, // ✅ use the current value
                      label: formatTimeFromMinutes,
                      onConfirmed: (RangeValues range) {
                        setState(() => takeoffRange = range);
                      },
                    ),
                  );
                },
              ),
              FilterButton(
                label: "Landing",
                func: () async {
                  await showRangePickerSheet(
                    context: context,
                    sheet: RangePickerSheet(
                      title: 'Landing',
                      min: 0,
                      max: 1439,
                      divisions: 1439,
                      initial: landingRange,
                      label: formatTimeFromMinutes,
                      onConfirmed: (RangeValues range) {
                        setState(() => landingRange = range);
                      },
                    ),
                  );
                },
              ),
              FilterButton(
                label: "Flight Duration",
                func: () async {
                  final int dMin = flightDurationRange.start.floor();
                  final int dMax = flightDurationRange.end.ceil();
                  // final int divs = (dMax - dMin).clamp(1, 100000);

                  await showRangePickerSheet(
                    context: context,
                    sheet: RangePickerSheet(
                      title: 'Flight Duration',
                      min: 0,
                      max: 1440,
                      divisions: 1440.clamp(1, 100000),
                      initial: RangeValues(dMin.toDouble(), dMax.toDouble()),
                      label: formatDurationFromMinutes,
                      onConfirmed: (RangeValues range) =>
                          setState(() => flightDurationRange = range),
                    ),
                  );
                },
              ),
              FilterButton(
                label: "Layover Duration",
                func: () async {
                  final int lMin = layOverDurationRange.start.floor();
                  final int lMax = layOverDurationRange.end.ceil();
                  final int divs = (lMax - lMin).clamp(1, 100000);

                  await showRangePickerSheet(
                    context: context,
                    sheet: RangePickerSheet(
                      title: 'Layover Duration',
                      min: 0,
                      max: 1470,
                      divisions: divs,
                      initial: RangeValues(lMin.toDouble(), lMax.toDouble()),
                      label: formatDurationFromMinutes,
                      onConfirmed: (RangeValues range) =>
                          setState(() => layOverDurationRange = range),
                    ),
                  );
                },
              ),
              FilterButton(
                label: "Airlines",
                func: () {
                  showSelectionBottomSheet<String>(
                    context: context,
                    title: 'Airlines',
                    items: kAirlines, // ← full list, not from selected
                    selected: selectedAirlines,
                    labelOf: (String s) => s,
                    onDone: (Set<String> s) => setState(() {
                      selectedAirlines = s;
                      for (final String a in selectedAirlines) {
                        debugPrint('selected airlines - $a');
                      }
                    }),
                  );
                },
              ),
              FilterButton(
                label: "Layover Cities",
                func: () {
                  showSelectionBottomSheet<String>(
                    context: context,
                    title: 'Layover Cities',
                    items: kLayoverCities,
                    selected: selectedLayovers,
                    labelOf: (String s) => s,
                    onDone: (Set<String> s) => setState(() {
                      selectedLayovers = s;
                    }),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    ];

    return Stack(
      children: [
        AbsorbPointer(
          absorbing: isLoading, // 🔒 no taps/scrolls
          child: Column(
            children: <Widget>[
              ...content,
              Expanded(
                child: isLoading
                    ? SearchSummaryLoadingCard(
                        routeText:
                            '${flightState.departureAirportCode} - ${flightState.arrivalAirportCode}',
                        dateText: flightState.displayDate ?? '',
                      )
                    : FlightListView(
                        sortType: selectedSort,
                        stopType: selectedStops,
                        takeoff: takeoffRange,
                        landing: landingRange,
                        flightDuration: flightDurationRange,
                        layOverDuration: layOverDurationRange,
                        selectedAirlines: selectedAirlines,
                        selectedLayovers: selectedLayovers,
                      ),
              ),
            ],
          ),
        ),

        // Optional soft white scrim for extra "disabled" feel
        // if (isLoading)
        //   IgnorePointer(
        //     child: AnimatedOpacity(
        //       duration: const Duration(milliseconds: 200),
        //       opacity: 0.08, // subtle
        //       child: Container(color: Colors.white),
        //     ),
        //   ),

        // // Optional spinner
        // if (isLoading)
        //   const Positioned.fill(
        //     child: IgnorePointer(
        //       child: Center(child: CircularProgressIndicator()),
        //     ),
        //   ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final FlightSearchState flightState = ref.watch(flightSearchProvider);
    final Scaffold page = Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.primary,
        child: SafeArea(child: _pageBody(context, flightState)),
      ),
    );
    return Platform.isIOS ? CupertinoScaffold(body: page) : page;
  }
}
