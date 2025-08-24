import 'dart:async';
import 'dart:io';

import 'package:TFA/providers/flight/flight_search_controller.dart';
import 'package:TFA/providers/flight/flight_search_state.dart';
import 'package:TFA/providers/sort_tab_provider.dart';
import 'package:TFA/screens/flight/flight_filter_screen.dart';
import 'package:TFA/types/typedefs.dart';
import 'package:TFA/utils/utils.dart';
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
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class FlightListPage extends ConsumerStatefulWidget {
  const FlightListPage({super.key});

  @override
  ConsumerState<FlightListPage> createState() => _FlightListPageState();
}

class OpFailed implements Exception {
  final String message;
  OpFailed(this.message);
  @override
  String toString() => message;
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
  late final ProviderSubscription<FlightSearchState> _sub;
  bool _rtFetching = false;

  Map<String, String> carriersDict = <String, String>{}; // <-- add this

  Map<String, dynamic> _asMap(dynamic v) =>
      v is Map ? v.cast<String, dynamic>() : const <String, dynamic>{};

  Iterable _asIter(dynamic v) => v is Iterable ? v : const <dynamic>[];

  RangeValues rangeFromFlights(
    List<Map<String, dynamic>> flights,
    String key, {
    int emptyMin = 0,
    int emptyMax = 1,
  }) {
    int minV = 1 << 30, maxV = 0;

    for (final Map<String, dynamic> f in flights) {
      final int v = (f[key] ?? 0) as int;
      if (v < minV) minV = v;
      if (v > maxV) maxV = v;
    }

    if (minV == 1 << 30) {
      return RangeValues(emptyMin.toDouble(), emptyMax.toDouble());
    }
    if (minV == maxV) maxV += 1; // avoid zero-width slider
    return RangeValues(minV.toDouble(), maxV.toDouble());
  }

  void _makeCarrier({
    required Set<String> airlines,
    required Set<String> layovers,
    required List<Map<String, dynamic>> flights,
    required Map<String, dynamic> results,
  }) {
    // ---- carriers dict: read from top-level dictionaries
    // Adjust this access to whatever your FlightSearchState exposes.
    // If it's nested differently, point to the right place.
    Map<String, String> carriers = <String, String>{};
    // 🟢 CHANGE carriers dict extraction (still inside _sub)

    final Map<String, dynamic> dict = _asMap(results['dictionaries']);
    final Map<String, dynamic> carriersRaw = _asMap(dict['carriers']);
    carriers = carriersRaw.map((String k, v) => MapEntry(k, v.toString()));

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
  }

  Widget _pageBody(BuildContext context, FlightSearchState flightState) {
    final bool isLoading = flightState.isLoading;
    return Column(
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
                  child: const Icon(Icons.arrow_back_ios, color: Colors.white),
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
                  child: const Icon(Icons.favorite_border, color: Colors.white),
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
                            MaterialPageRoute(
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
                    final int divs = (dMax - dMin).clamp(1, 100000);

                    await showRangePickerSheet(
                      context: context,
                      sheet: RangePickerSheet(
                        title: 'Flight Duration',
                        min: flightDurationSt.toDouble(),
                        max: flightDurationEnd.toDouble(),
                        divisions: divs,
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
                        min: layOverDurationSt.toDouble(),
                        max: layOverDurationEnd.toDouble(),
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
                      items: kLayoverCities, // ← full list
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
    );
  }

  Future<void> _onSearchChange(FlightSearchParams next) async {
    if (!mounted) return;

    final String departureAirport = next.$1;
    final String arrivalAirPort = next.$2;
    final String? departureDate = next.$3; // String?
    final String? returnDate = next.$4; // String? (may be null)
    final int passengerCount = next.$5;

    if (_rtFetching) return;
    _rtFetching = true;

    final FlightSearchController controller = ref.read(
      flightSearchProvider.notifier,
    );
    final bool hasReturn = (returnDate?.isNotEmpty ?? false);

    try {
      debugPrint(
        '🧷 snapshot departureAirport=$departureAirport\n'
        'arrivalAirPort=$arrivalAirPort\n'
        'departureDate=$departureDate\n'
        'returnDate=$returnDate\n'
        'passengerCount=$passengerCount',
      );
      controller.clearProcessedFlights();

      final List<Future<(bool, String)> Function()> ops = controller
          .executeFlightSearch(hasReturn: hasReturn);

      for (final Future<(bool, String)> Function() op in ops) {
        final (bool ok, String msg) = await op();
        if (!ok) {
          if (mounted) {
            throw OpFailed(msg);
          }
          return;
        }
        debugPrint("🧷 onSearchChange msg : $msg");
      }
    } catch (e, st) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
      debugPrint('❌ $e\n$st');
    } finally {
      _rtFetching = false;
    }
  }

  // 🟢 NEW: extract the processing logic
  void _processFlightsAndUpdate(FlightSearchState next) {
    final List<Map<String, dynamic>> flights = next.processedFlights;
    if (!mounted || flights.isEmpty) return;

    final Set<String> layovers = <String>{};
    final Set<String> airlines = <String>{};

    for (final Map<String, dynamic> f in flights) {
      // airlines
      for (final String a in _asIter(f['airlines']).map((e) => e.toString())) {
        airlines.add(a.toUpperCase());
      }

      // layovers
      final Map<String, dynamic> locations = _asMap(f['locations']);
      final String path = (f['airportPath'] as String? ?? '');
      final List<String> parts = path
          .split('→')
          .map((String s) => s.trim())
          .toList();

      if (parts.length > 2) {
        for (final String iata in parts.sublist(1, parts.length - 1)) {
          final Map<String, dynamic> details = _asMap(locations[iata]);
          final String? cityCode = details['cityCode'] as String?;
          if (cityCode?.isNotEmpty ?? false) {
            layovers.add(cityCode!.toUpperCase());
          }
        }
      }
    }

    // outbound carriers
    // Map<String, dynamic> results = ref
    //     .read(flightSearchProvider)
    //     .flightResults
    //     .maybeWhen(
    //       data: (Map<String, dynamic> v) => v,
    //       orElse: () => const <String, dynamic>{},
    //     );
    // _makeCarrier(
    //   airlines: airlines,
    //   layovers: layovers,
    //   flights: flights,
    //   results: results,
    // );

    // inbound carriers
    // results = ref
    //     .read(flightSearchProvider)
    //     .inBoundFlightResults
    //     .maybeWhen(
    //       data: (Map<String, dynamic> v) => v,
    //       orElse: () => const <String, dynamic>{},
    //     );
    // _makeCarrier(
    //   airlines: airlines,
    //   layovers: layovers,
    //   flights: flights,
    //   results: results,
    // );
  }

  // 🟢 ADD: fields (top of State class)
  Timer? _searchDebounce; // 🟢 coalesce rapid UI updates
  String? _lastParamsSig; // 🟢 dedupe identical param sets
  bool _filtersBootstrapped = false; // 🟢 avoid setState during first build
  // 🟢 ADD: helpers (anywhere in State class)
  String _normStr(String? s) => (s == null || s.isEmpty) ? '' : s; // 🟢

  String _buildSig(
    FlightSearchState s,
  ) => // 🟢 stable signature for change detection
      '${s.departureAirportCode}|'
      '${s.arrivalAirportCode}|'
      '${_normStr(s.departDate)}|'
      '${_normStr(s.returnDate)}|'
      '${s.passengerCount}|'
      '${s.cabinClass}';

  bool _paramsReady(FlightSearchState s) {
    // 🟢 treat null/"" return as one-way
    final bool hasDep = s.departureAirportCode.isNotEmpty;
    final bool hasArr = s.arrivalAirportCode.isNotEmpty;
    final bool hasOut = _normStr(s.departDate).isNotEmpty;
    final bool hasRet = _normStr(s.returnDate).isNotEmpty;
    final bool isOneWay = !hasRet;
    return hasDep && hasArr && hasOut && (isOneWay || hasRet);
  }

  // 🟢 ADD: debounce that reads the LATEST provider state at fire time
  void _scheduleSearchLatest() {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 150), () {
      if (!mounted) return;

      final FlightSearchState s = ref.read(
        flightSearchProvider,
      ); // 🟢 read fresh state
      if (!_paramsReady(s)) return;

      // 🟢 recompute signature at fire time and dedupe here
      final String sigNow = _buildSig(s);
      if (_lastParamsSig == sigNow) return;
      _lastParamsSig = sigNow;

      final (String, String, String?, String?, int) next = (
        s.departureAirportCode,
        s.arrivalAirportCode,
        _normStr(s.departDate).isEmpty ? null : s.departDate,
        _normStr(s.returnDate).isEmpty ? null : s.returnDate,
        s.passengerCount,
      );
      _onSearchChange(next);
    });
  }

  @override
  void initState() {
    super.initState();

    _sub = ref.listenManual<FlightSearchState>(
      flightSearchProvider,
      (FlightSearchState? prev, FlightSearchState next) {
        // 🟢 first setState deferred to avoid “modify provider during build”
        if (!_filtersBootstrapped && prev == null) {
          _filtersBootstrapped = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _processFlightsAndUpdate(next);
          });
        } else {
          _processFlightsAndUpdate(next);
        }

        // 🟢 detect any param change (dep/arr/out/ret/pax) and debounce
        final String sig = _buildSig(next);
        if (_lastParamsSig == sig) return; // same values → ignore
        // ⚠️ do NOT set _lastParamsSig here; set it inside _scheduleSearchLatest()
        _scheduleSearchLatest();
      },
      fireImmediately:
          true, // 🟢 ensures initial processing; search will run after debounce
    );
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _sub.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final FlightSearchState flightState = ref.watch(flightSearchProvider);
    final Scaffold page = Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90), // required!
        child: Container(
          color: Theme.of(context).colorScheme.primary,
          child: const SizedBox(height: 30),
        ),
      ),
      body: _pageBody(context, flightState),
    );
    return Platform.isIOS ? CupertinoScaffold(body: page) : page;
  }
}
