import 'package:TFA/providers/flight/flight_search_controller.dart';
import 'package:TFA/providers/flight/flight_search_state.dart';
import 'package:TFA/providers/sort_tab_provider.dart';
import 'package:TFA/screens/flight/flight_filter_page.dart';
import 'package:TFA/utils/time_utils.dart';
import 'package:TFA/widgets/filter_button.dart';
import 'package:TFA/widgets/flight/flight_list_view.dart';
import 'package:TFA/widgets/sort_sheets/range_picker_sheet.dart';
import 'package:TFA/widgets/sort_sheets/selection_bottom_sheet.dart';
import 'package:TFA/widgets/sort_sheets/sort_bottom_sheet.dart';
import 'package:TFA/widgets/search_summary_card.dart';
import 'package:TFA/widgets/search_summary_loading_card.dart';
import 'package:TFA/widgets/sort_sheets/travel_hack_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlightListPage extends ConsumerStatefulWidget {
  const FlightListPage({super.key});

  @override
  ConsumerState<FlightListPage> createState() => _FlightListPageState();
}

class _FlightListPageState extends ConsumerState<FlightListPage> {
  bool isLoading = true;
  String selectedSort = 'Cost';
  String selectedStops = 'Up to 2 stops';
  RangeValues takeoffRange = const RangeValues(0, 1439);
  RangeValues landingRange = const RangeValues(0, 1439);
  RangeValues flightDurationRange = const RangeValues(0, 1440);
  RangeValues layOverDurationRange = const RangeValues(0, 1470);
  Set<String> selectedAirlines = <String>{};
  Set<String> selectedLayovers = <String>{};
  List<String> kAirlines = [];
  List<String> kLayoverCities = [];
  int flightDurationSt = 0;
  int flightDurationEnd = 0;
  int layOverDurationSt = 0;
  int layOverDurationEnd = 0;
  late final ProviderSubscription<FlightSearchState> _sub;
  Map<String, String> carriersDict = {}; // <-- add this

  RangeValues rangeFromFlights(
    List<Map<String, dynamic>> flights,
    String key, {
    int emptyMin = 0,
    int emptyMax = 1,
  }) {
    int minV = 1 << 30, maxV = 0;

    for (final f in flights) {
      final v = (f[key] ?? 0) as int;
      if (v < minV) minV = v;
      if (v > maxV) maxV = v;
    }

    if (minV == 1 << 30) {
      return RangeValues(emptyMin.toDouble(), emptyMax.toDouble());
    }
    if (minV == maxV) maxV += 1; // avoid zero-width slider
    return RangeValues(minV.toDouble(), maxV.toDouble());
  }

  @override
  void initState() {
    super.initState();

    _sub = ref.listenManual<FlightSearchState>(flightSearchProvider, (
      prev,
      next,
    ) {
      final flights = next.processedFlights;
      if (!mounted || flights.isEmpty) return;

      // Temp sets for this batch
      final layovers = <String>{};
      final airlines = <String>{};

      for (final f in flights) {
        // ---- airlines: use codes, normalize to upper-case
        for (final a in (f['airlines'] as Iterable).cast<String>()) {
          airlines.add(a.toUpperCase());
        }

        // ---- layovers: ONLY middle airports, not origin/destination
        final locations = (f['locations'] as Map).cast<String, dynamic>();
        final path = (f['airportPath'] as String? ?? '');
        final parts = path.split('→').map((s) => s.trim()).toList();
        if (parts.length > 2) {
          final middleIATAs = parts.sublist(1, parts.length - 1);
          for (final iata in middleIATAs) {
            final details = (locations[iata] as Map?)?.cast<String, dynamic>();
            final cityCode = details?['cityCode'] as String?;
            if (cityCode != null && cityCode.isNotEmpty) {
              layovers.add(cityCode.toUpperCase());
            }
          }
        }
      }

      // ---- carriers dict: read from top-level dictionaries
      // Adjust this access to whatever your FlightSearchState exposes.
      // If it's nested differently, point to the right place.
      Map<String, String> carriers = {};
      final results = ref
          .read(flightSearchProvider)
          .flightResults
          .maybeWhen(data: (v) => v, orElse: () => null);
      final dict = (results?['dictionaries'] as Map?)?.cast<String, dynamic>();
      final carriersRaw = (dict?['carriers'] as Map?)?.cast<String, dynamic>();
      if (carriersRaw != null) {
        carriers = carriersRaw.map((k, v) => MapEntry(k, v.toString()));
      }

      setState(() {
        // master lists
        kAirlines = airlines.toList()..sort();
        kLayoverCities = layovers.toList()..sort();

        // initialize selections to everything (adjust if you want persist)
        selectedAirlines
          ..clear()
          ..addAll(airlines);
        selectedLayovers
          ..clear()
          ..addAll(layovers);

        carriersDict = carriers; // used only for display in the sheet

        // ranges
        flightDurationRange = rangeFromFlights(flights, 'durationMin');
        layOverDurationRange = rangeFromFlights(flights, 'layoverMin');
        flightDurationSt = flightDurationRange.start.toInt();
        flightDurationEnd = flightDurationRange.end.toInt() + 1;
        layOverDurationSt = layOverDurationRange.start.toInt();
        layOverDurationEnd = layOverDurationRange.end.toInt() + 1;
      });
    }, fireImmediately: true);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        isLoading = true; // ✅ show loading before search
      });

      final controller = ref.read(flightSearchProvider.notifier);
      final flightState = ref.read(flightSearchProvider);

      final (searchSuccess, searchMessage) = await controller.searchFlights(
        origin: flightState.departureAirportCode,
        destination: flightState.arrivalAirportCode,
        departureDate: flightState.departDate,
        returnDate: flightState.returnDate,
        adults: flightState.passengerCount,
      );

      if (!searchSuccess && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(searchMessage)));
      }

      if (mounted) {
        setState(() {
          isLoading = false;

          final Map<String, dynamic> _ = ref
              .read(flightSearchProvider)
              .flightResults
              .maybeWhen(data: (v) => v, orElse: () => {});
        });
      }
    });
  }

  @override
  void dispose() {
    _sub.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final flightState = ref.watch(flightSearchProvider);
    debugPrint(
      'carriersDict (${carriersDict.length}): '
      '${carriersDict.entries.map((e) => '${e.key}→${e.value}').join(', ')}',
    );
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90), // required!
        child: Container(
          color: Theme.of(context).colorScheme.primary,
          child: SizedBox(height: 30),
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
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: 250,
                  child: SearchSummaryCard(
                    from: flightState.departureAirportCode,
                    to: flightState.arrivalAirportCode,
                    dateRange: flightState.displayDate ?? '',
                    passengerCount: flightState.passengerCount,
                    cabinClass: 'Economy',
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),

                  child: InkWell(
                    onTap: () {},
                    child: Icon(Icons.favorite_border, color: Colors.white),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),

                  child: InkWell(
                    onTap: () {},
                    child: Icon(Icons.share, color: Colors.white),
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
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.all(10),
                        backgroundColor: Colors.white,
                        minimumSize: const Size(0, 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        side: BorderSide(color: Colors.grey[400]!, width: 1),
                      ),
                      onPressed: () async {
                        final result =
                            await showModalBottomSheet<
                              Map<String, List<String>>
                            >(
                              context: context,
                              isScrollControlled: true,
                              useSafeArea: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) {
                                return DraggableScrollableSheet(
                                  expand: true,
                                  initialChildSize: 1.0,
                                  minChildSize: 1.0,
                                  maxChildSize: 1.0,
                                  builder: (context, scrollController) {
                                    return Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(16),
                                        ),
                                      ),
                                      child: FlightFilterPage(
                                        scrollController: scrollController,
                                        selectedAirlines: selectedAirlines,
                                        selectedLayovers: selectedLayovers,
                                        kAirlines: kAirlines,
                                        kLayoverCities: kLayoverCities,
                                        carriersDict: carriersDict,
                                      ),
                                    );
                                  },
                                );
                              },
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
                      child: Icon(Icons.tune, size: 23),
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
                        onSortSelected: (value) {
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
                        builder: (context) => const TravelHackBottomSheet(),
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
                        onSortSelected: (value) {
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
                          label: formatTime,
                          onConfirmed: (range) {
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
                          label: formatTime,
                          onConfirmed: (range) {
                            setState(() => landingRange = range);
                          },
                        ),
                      );
                    },
                  ),
                  FilterButton(
                    label: "Flight Duration",
                    func: () async {
                      final dMin = flightDurationRange.start.floor();
                      final dMax = flightDurationRange.end.ceil();
                      final int divs = (dMax - dMin).clamp(1, 100000);

                      await showRangePickerSheet(
                        context: context,
                        sheet: RangePickerSheet(
                          title: 'Flight Duration',
                          min: flightDurationSt.toDouble(),
                          max: flightDurationEnd.toDouble(),
                          divisions: divs,
                          initial: RangeValues(
                            dMin.toDouble(),
                            dMax.toDouble(),
                          ),
                          label: formatDuration,
                          onConfirmed: (range) =>
                              setState(() => flightDurationRange = range),
                        ),
                      );
                    },
                  ),
                  FilterButton(
                    label: "Layover Duration",
                    func: () async {
                      final lMin = layOverDurationRange.start.floor();
                      final lMax = layOverDurationRange.end.ceil();
                      final int divs = (lMax - lMin).clamp(1, 100000);

                      await showRangePickerSheet(
                        context: context,
                        sheet: RangePickerSheet(
                          title: 'Layover Duration',
                          min: layOverDurationSt.toDouble(),
                          max: layOverDurationEnd.toDouble(),
                          divisions: divs,
                          initial: RangeValues(
                            lMin.toDouble(),
                            lMax.toDouble(),
                          ),
                          label: formatDuration,
                          onConfirmed: (range) =>
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
                        labelOf: (s) => s,
                        onDone: (s) => setState(() {
                          selectedAirlines = s;
                          for (final a in selectedAirlines) {
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
                        items: kLayoverCities, // ← full list
                        selected: selectedLayovers,
                        labelOf: (s) => s,
                        onDone: (s) => setState(() {
                          selectedLayovers = s;
                        }),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
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
    );
  }
}
