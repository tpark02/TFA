import 'dart:io';
import 'dart:math';

import 'package:TFA/l10n/app_localizations.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class FlightListPage extends ConsumerStatefulWidget {
  const FlightListPage({super.key});
  @override
  ConsumerState<FlightListPage> createState() => _FlightListPageState();
}

class _FlightListPageState extends ConsumerState<FlightListPage> {
  // Use the lowercase keys expected by FlightListView (cost, duration, value)
  String selectedSort = 'cost';
  String selectedStops = 'Up to 2 stops';

  RangeValues takeoffRange = const RangeValues(0, 1439);
  RangeValues landingRange = const RangeValues(0, 1439);
  RangeValues flightDurationRange = const RangeValues(0, 1440);
  RangeValues layOverDurationRange = const RangeValues(0, 1470);

  Set<String> selectedAirlines = <String>{};
  Set<String> selectedLayovers = <String>{};
  List<String> kAirlines = <String>[];
  List<String> kLayoverCities = <String>[];

  Map<String, String> carriersDict = <String, String>{};

  Widget _pageBody(BuildContext context, FlightSearchState flightState) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final bool isLoading = flightState.isLoading;
    int minDuration = 1000000, maxDuration = 0;
    int minLayOver = 1000000, maxLayOver = 0;
    final text = AppLocalizations.of(context)!;

    // Build filters data from processed flights
    for (final Map<String, dynamic> e in flightState.processedFlights) {
      final List<String> lst = (e['layOverAirports'] as List<dynamic>)
          .cast<String>();
      if (lst.isNotEmpty) {
        for (final String l in lst) {
          if (!kLayoverCities.contains(l)) kLayoverCities.add(l);
        }
      }
      final String airline = e['airline'] as String;
      if (!kAirlines.contains(airline)) kAirlines.add(airline);

      minDuration = min(minDuration, e['durationMin'] as int);
      maxDuration = max(maxDuration, e['durationMin'] as int);
      minLayOver = min(minLayOver, e['layoverMin'] as int);
      maxLayOver = max(maxLayOver, e['layoverMin'] as int);
    }

    // Update ranges (best-effort: keep within slider domain)
    flightDurationRange = RangeValues(
      min(minDuration, 0).toDouble().clamp(0, 1440),
      max(maxDuration, 0).toDouble().clamp(0, 1440),
    );
    layOverDurationRange = RangeValues(
      min(minLayOver, 0).toDouble().clamp(0, 1470),
      max(maxLayOver, 0).toDouble().clamp(0, 1470),
    );

    final List<Widget> header = <Widget>[
      // Top summary bar
      Material(
        color: cs.primary,
        elevation: 0,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(Icons.arrow_back_ios, color: cs.onPrimary),
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
                const SizedBox(width: 20), // spacer for symmetry
              ],
            ),
          ),
        ),
      ),

      // Filters row
      Container(
        color: cs.surfaceContainerHighest,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              // Tune icon button
              Container(
                margin: const EdgeInsets.only(left: 8),
                child: OutlinedButton(
                  style:
                      OutlinedButton.styleFrom(
                        backgroundColor: cs.surface,
                        minimumSize: const Size(0, 36),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: BorderSide(color: cs.outlineVariant, width: 1),
                        foregroundColor: cs.onSurface,
                      ).copyWith(
                        overlayColor: MaterialStateProperty.resolveWith<Color?>(
                          (states) => states.contains(MaterialState.pressed)
                              ? cs.primary.withValues(alpha: .08)
                              : null,
                        ),
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
                        selectedAirlines = (result['airlines'] ?? <String>[])
                            .toSet();
                        selectedLayovers = (result['layovers'] ?? <String>[])
                            .toSet();
                      });
                    }
                  },
                  child: const Icon(Icons.tune, size: 23),
                ),
              ),

              // Sort (uses lowercase key but shows capitalized label)
              FilterButton(
                label: "${text.sort}: ${_cap(selectedSort)}",
                func: () {
                  showSortBottomSheet(
                    title: text.sort,
                    context: context,
                    selectedSort: selectedSort,
                    sortType: SortTab.sort,
                    onSortSelected: (String value) {
                      setState(() => selectedSort = value.toLowerCase());
                    },
                  );
                },
              ),

              // Stops
              FilterButton(
                label: "${text.stops}: $selectedStops",
                func: () {
                  showSortBottomSheet(
                    title: text.stops,
                    context: context,
                    selectedSort: selectedStops,
                    sortType: SortTab.stops,
                    onSortSelected: (String value) {
                      setState(() => selectedStops = value);
                    },
                  );
                },
              ),

              // Take off
              FilterButton(
                label: text.take_off,
                func: () async {
                  await showRangePickerSheet(
                    context: context,
                    sheet: RangePickerSheet(
                      title: text.take_off,
                      min: 0,
                      max: 1439,
                      divisions: 1439,
                      initial: takeoffRange,
                      label: formatTimeFromMinutes,
                      onConfirmed: (RangeValues range) {
                        setState(() => takeoffRange = range);
                      },
                    ),
                  );
                },
              ),

              // Landing
              FilterButton(
                label: text.landing,
                func: () async {
                  await showRangePickerSheet(
                    context: context,
                    sheet: RangePickerSheet(
                      title: text.landing,
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

              // Flight duration
              FilterButton(
                label: text.flight_duration,
                func: () async {
                  final int dMin = flightDurationRange.start.floor();
                  final int dMax = flightDurationRange.end.ceil();
                  await showRangePickerSheet(
                    context: context,
                    sheet: RangePickerSheet(
                      title: text.flight_duration,
                      min: 0,
                      max: 1440,
                      divisions: 1440,
                      initial: RangeValues(dMin.toDouble(), dMax.toDouble()),
                      label: formatDurationFromMinutes,
                      onConfirmed: (RangeValues range) =>
                          setState(() => flightDurationRange = range),
                    ),
                  );
                },
              ),

              // Layover duration
              FilterButton(
                label: text.layover_duration,
                func: () async {
                  final int lMin = layOverDurationRange.start.floor();
                  final int lMax = layOverDurationRange.end.ceil();
                  final int divs = (lMax - lMin).clamp(1, 1470);
                  await showRangePickerSheet(
                    context: context,
                    sheet: RangePickerSheet(
                      title: text.layover_duration,
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

              // Airlines
              FilterButton(
                label: text.airlines,
                func: () {
                  showSelectionBottomSheet<String>(
                    context: context,
                    title: text.airlines,
                    items: kAirlines,
                    selected: selectedAirlines,
                    labelOf: (String s) => s,
                    onDone: (Set<String> s) => setState(() {
                      selectedAirlines = s;
                    }),
                  );
                },
              ),

              // Layover cities
              FilterButton(
                label: text.layover_cities,
                func: () {
                  showSelectionBottomSheet<String>(
                    context: context,
                    title: text.layover_cities,
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
          absorbing: isLoading,
          child: Column(
            children: <Widget>[
              ...header,
              Expanded(
                child: isLoading
                    ? SearchSummaryLoadingCard(
                        routeText:
                            '${flightState.departureAirportCode} - ${flightState.arrivalAirportCode}',
                        dateText: flightState.displayDate ?? '',
                      )
                    : FlightListView(
                        sortType:
                            selectedSort, // expects 'cost'|'duration'|'value'
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
      ],
    );
  }

  String _cap(String v) =>
      v.isEmpty ? v : (v[0].toUpperCase() + v.substring(1));

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final FlightSearchState flightState = ref.watch(flightSearchProvider);

    final Scaffold page = Scaffold(
      // Keep primary under status-bar for nice blend with summary bar
      body: Container(
        color: Theme.of(context).colorScheme.primary,
        child: SafeArea(
          top: false, // allow our top Material(bar) to paint under status bar
          child: _pageBody(context, flightState),
        ),
      ),
    );

    return Platform.isIOS ? CupertinoScaffold(body: page) : page;
  }
}
