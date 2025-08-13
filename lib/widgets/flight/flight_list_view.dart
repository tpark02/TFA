import 'dart:io';

import 'package:TFA/providers/flight/flight_search_controller.dart';
import 'package:TFA/screens/flight/flight_trip_details_page.dart';
import 'package:TFA/widgets/flight/flight_list_view_item.dart';
import 'package:TFA/widgets/search_summary_loading_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class FlightListView extends ConsumerStatefulWidget {
  const FlightListView({
    super.key,
    required this.sortType,
    required this.stopType,
    required this.takeoff,
    required this.landing,
    required this.flightDuration,
    required this.layOverDuration,
    required this.selectedAirlines,
    required this.selectedLayovers,
  });

  final RangeValues takeoff, landing, flightDuration, layOverDuration;
  final String sortType;
  final String stopType;
  final Set<String> selectedAirlines;
  final Set<String> selectedLayovers;
  @override
  ConsumerState<FlightListView> createState() => _FlightListViewState();
}

class _FlightListViewState extends ConsumerState<FlightListView>
    with TickerProviderStateMixin {
  final ScrollController _returnScrollController = ScrollController();
  int? selectedDepartureIndex;
  bool isLoading = true;

  late AnimationController _returnAnimController;
  late Animation<Offset> _returnSlideAnimation;
  late Map<String, dynamic> _departData;
  Map<String, dynamic>? _returnData;

  // Call this instead of Navigator.of(...).push(...)
  void openTripDetails({
    required BuildContext context,
    required bool isReturnPage,
  }) {
    if (Platform.isIOS) {
      // 🟢 iOS page sheet style
      CupertinoScaffold.showCupertinoModalBottomSheet(
        context: context,
        useRootNavigator: true,
        expand: false, // page sheet instead of full screen
        builder: (_) => FlightTripDetailsPage(
          isReturnPage: isReturnPage,
          departData: _departData,
          returnData: _returnData,
        ),
      );
    } else {
      // 🟢 Android normal full page
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (_) => FlightTripDetailsPage(
            isReturnPage: isReturnPage,
            departData: _departData,
            returnData: _returnData,
          ),
        ),
      );
    }
  }

  void onDepartureClicked(int index) async {
    if (selectedDepartureIndex == index) {
      await _returnAnimController.reverse();
      await Future.delayed(const Duration(milliseconds: 50));

      final indexToScroll = selectedDepartureIndex;
      setState(() {
        selectedDepartureIndex = null;
        isLoading = true;
      });

      await Future.delayed(const Duration(milliseconds: 50));

      if (indexToScroll != null) {
        final offset = indexToScroll * 100.0;
        _returnScrollController.animateTo(
          offset,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
      return;
    }

    setState(() {
      selectedDepartureIndex = index;
      isLoading = true;
    });

    // ✅ Trigger slide immediately while still loading
    await Future.delayed(const Duration(milliseconds: 10));
    _returnAnimController.forward(from: 0);

    // Simulate loading
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _returnAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _returnSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
          CurvedAnimation(parent: _returnAnimController, curve: Curves.easeOut),
        );
  }

  @override
  void dispose() {
    _returnScrollController.dispose();
    _returnAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final flightState = ref.watch(flightSearchProvider);
    final allFlights = ref.watch(flightSearchProvider).processedFlights;

    int depMinutesOfDay(dynamic depRaw) {
      if (depRaw == null) return -1;
      final dt = DateTime.tryParse(depRaw.toString());
      if (dt == null) return -1;
      return dt.hour * 60 + dt.minute; // 0..1439
    }

    // ---- helpers ----
    double parsePrice(dynamic v) {
      if (v is num) return v.toDouble();
      if (v is String) {
        final numeric = v.replaceAll(RegExp(r'[^0-9.]'), '');
        return double.tryParse(numeric) ?? double.infinity;
      }
      return double.infinity;
    }

    // Accepts "PT12H30M", "12h 30m", "12h30m", "750" (mins) etc.
    int parseDurationMins(dynamic v) {
      if (v == null) return 1 << 30;
      if (v is int) return v;
      if (v is num) return v.toInt();
      final s = v.toString().trim().toUpperCase();

      // ISO-8601 like PT12H30M
      final iso = RegExp(r'^PT(?:(\d+)H)?(?:(\d+)M)?$');
      final mIso = iso.firstMatch(s);
      if (mIso != null) {
        final h = int.tryParse(mIso.group(1) ?? '0') ?? 0;
        final m = int.tryParse(mIso.group(2) ?? '0') ?? 0;
        return h * 60 + m;
      }

      // "12H 30M" or "12H30M"
      final hm = RegExp(r'(?:(\d+)\s*H)?\s*(?:(\d+)\s*M)?');
      final mHm = hm.firstMatch(s);
      if (mHm != null && (mHm.group(1) != null || mHm.group(2) != null)) {
        final h = int.tryParse(mHm.group(1) ?? '0') ?? 0;
        final m = int.tryParse(mHm.group(2) ?? '0') ?? 0;
        return h * 60 + m;
      }

      // plain minutes string like "750"
      return int.tryParse(s) ?? (1 << 30);
    }

    // Lower is better: balances cheap + short (tweak weights if you want)
    double valueScore(Map f) {
      final p = parsePrice(f['price']);
      final d = parseDurationMins(f['duration']).toDouble();
      // weights: 0.7 price, 0.3 duration (per hour)
      final priceNorm = p; // already in currency units
      final durNorm = d / 60.0; // hours
      return 0.7 * priceNorm + 0.3 * durNorm;
    }

    // ---- sort ALL flights, then split ----
    final sortKey = widget.sortType.toLowerCase();

    int compare(Map a, Map b) {
      switch (sortKey) {
        case 'duration':
          return parseDurationMins(
            a['duration'],
          ).compareTo(parseDurationMins(b['duration']));
        case 'value':
          return valueScore(a).compareTo(valueScore(b));
        case 'cost':
        default:
          return parsePrice(a['price']).compareTo(parsePrice(b['price']));
      }
    }

    // Map label to max stops allowed
    int maxStopsFor(String stopsLabel) {
      switch (stopsLabel) {
        case 'Nonstop':
          return 0;
        case 'Up to 1 stop':
          return 1;
        case 'Up to 2 stops':
        default:
          return 2;
      }
    }

    final maxStops = maxStopsFor(widget.stopType); // or pass in a separate prop

    // --- helpers for filters ---
    Set<String> layoverCityCodesOf(Map f) {
      final path = (f['airportPath'] as String? ?? '');
      final parts = path.split('→').map((s) => s.trim()).toList();
      if (parts.length <= 2) return <String>{}; // nonstop

      final middleIATAs = parts.sublist(1, parts.length - 1);
      final locMap = (f['locations'] as Map?)?.cast<String, dynamic>() ?? {};

      final out = <String>{};
      for (final iata in middleIATAs) {
        final details = (locMap[iata] as Map?)?.cast<String, dynamic>();
        final city = details?['cityCode'] as String?;
        if (city != null && city.isNotEmpty) out.add(city);
      }
      return out;
    }

    bool passesAirlineFilter(Map f, Set<String> selected) {
      if (selected.isEmpty) return true; // or false, depending on your UX

      String norm(String s) => s.toUpperCase().trim();

      final flightAir = ((f['airlines'] as Iterable?) ?? const [])
          .map((e) => norm(e.toString()))
          .toSet();

      final selectedNorm = selected.map(norm).toSet();

      // ✅ Show only if EVERY carrier in the itinerary is selected
      return selectedNorm.containsAll(flightAir);
      // (equivalent: return flightAir.difference(selectedNorm).isEmpty;)
    }

    bool passesLayoverCityFilter(Map f, Set<String> selected) {
      if (selected.isEmpty) return true;
      final layoverCities = layoverCityCodesOf(f);
      return layoverCities.any(selected.contains);
    }

    for (final s in widget.selectedAirlines) {
      debugPrint('selected Airlines - $s');
    }
    final filteredFlights = allFlights.where((f) {
      // airlines filter
      if (!passesAirlineFilter(f, widget.selectedAirlines)) return false;

      // layover city filter (by cityCode like "TYO", "SEL")
      if (!passesLayoverCityFilter(f, widget.selectedLayovers)) return false;

      final stops = int.tryParse(f['stops'].toString().split(' ').first) ?? 0;
      if (stops > maxStops) return false;

      // --- flight duration ---
      final durMin = f['durationMin'] ?? 0;
      final dStart = widget.flightDuration.start.round();
      final dEnd = widget.flightDuration.end.round();
      if (durMin < dStart || durMin > dEnd) return false;

      // layover duration
      final layOverMin = f['layoverMin'] ?? 0;
      final lStart = widget.layOverDuration.start.round();
      final lEnd = widget.layOverDuration.end.round();
      if (layOverMin < lStart || layOverMin > lEnd) return false;

      // time windows...
      if (f['isReturn'] == false) {
        final mins = depMinutesOfDay(f['depRaw']);
        if (mins >= 0) {
          final start = widget.takeoff.start.round();
          final end = widget.takeoff.end.round();
          if (mins < start || mins > end) return false;
        }
        final arrMin = depMinutesOfDay(f['arrRaw']);
        if (arrMin >= 0) {
          final start = widget.landing.start.round();
          final end = widget.landing.end.round();
          if (arrMin < start || arrMin > end) return false;
        }
      } else {
        final depMin = depMinutesOfDay(f['depRaw']);
        if (depMin >= 0) {
          final start = widget.takeoff.start.round();
          final end = widget.takeoff.end.round();
          if (depMin < start || depMin > end) return false;
        }
        final arrMin = depMinutesOfDay(f['arrRaw']);
        if (arrMin >= 0) {
          final start = widget.landing.start.round();
          final end = widget.landing.end.round();
          if (arrMin < start || arrMin > end) return false;
        }
      }

      return true;
    }).toList();

    final sortedAllFlights = [...filteredFlights]..sort(compare);

    final departureFlights = sortedAllFlights
        .where((f) => f['isReturn'] == false)
        .toList();
    final returnFlights = sortedAllFlights
        .where((f) => f['isReturn'] == true)
        .toList();

    final activeIndex =
        (selectedDepartureIndex != null &&
            selectedDepartureIndex! >= 0 &&
            selectedDepartureIndex! < departureFlights.length)
        ? selectedDepartureIndex
        : null;

    final List<Widget> returnFlightWidgets = List.generate(
      returnFlights.length,
      (i) => FlightListViewItem(
        onClick: () async {
          _returnData = returnFlights[i];
          openTripDetails(context: context, isReturnPage: true);
        },
        index: i,
        flight: returnFlights[i],
      ),
    );

    final List<Widget> departureFlightWidgets = List.generate(
      departureFlights.length,
      (i) => FlightListViewItem(
        onClick: returnFlightWidgets.isNotEmpty
            ? () {
                _departData = departureFlights[i];
                onDepartureClicked(i);
              }
            : () {
                _departData = departureFlights[i];
                openTripDetails(context: context, isReturnPage: false);
              },
        index: i,
        flight: departureFlights[i],
      ),
    );

    return Column(
      children: [
        // Departure flight row (static)
        if (activeIndex != null)
          departureFlightWidgets[activeIndex]
        else
          Expanded(
            child: ListView(
              controller: _returnScrollController,
              // padding: const EdgeInsets.all(16),
              children: [
                // ✅ Banner at the top of the scrollable list
                Container(
                  color: Colors.amber[50],
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.fontSize,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            children: const [
                              TextSpan(
                                text: 'Automatic protection on every flight. ',
                              ),
                              TextSpan(
                                text: 'The Skiplagged Guarantee.',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          padding: const EdgeInsets.all(10.0),
                        ),
                        child: const Text("Learn More"),
                      ),
                    ],
                  ),
                ),

                // ✅ Optional: Departing flight header
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.grey[100],
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Choose Departing flight",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Total Cost",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                // ✅ Actual flight items
                ...departureFlightWidgets,
              ],
            ),
          ),

        // Return flight list below
        if (activeIndex != null && returnFlightWidgets.isNotEmpty) ...[
          Flexible(
            child: SizedBox.expand(
              child: SlideTransition(
                position: _returnSlideAnimation,
                child: Column(
                  key: const ValueKey('return-list'),
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[100]!,
                        border: Border(
                          top: BorderSide(color: Colors.grey[400]!, width: 1.0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Choose returning flight",
                            style: TextStyle(
                              fontSize: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.fontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: isLoading
                            ? SearchSummaryLoadingCard(
                                key: const ValueKey('shimmer'),
                                routeText:
                                    (activeIndex < departureFlights.length)
                                    ? (departureFlights[activeIndex]['airportPath']
                                              as String? ??
                                          '')
                                    : '',
                                dateText: flightState.displayDate!,
                              )
                            : ListView(
                                key: const ValueKey('return-list'),
                                controller: _returnScrollController,
                                children: returnFlightWidgets,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
