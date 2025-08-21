import 'dart:io';

import 'package:TFA/providers/flight/flight_search_controller.dart';
import 'package:TFA/providers/flight/flight_search_state.dart';
import 'package:TFA/screens/flight/flight_trip_details_page.dart';
import 'package:TFA/utils/flight_list_view_util.dart';
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

      final int? indexToScroll = selectedDepartureIndex;
      setState(() {
        selectedDepartureIndex = null;
        isLoading = true;
      });

      await Future.delayed(const Duration(milliseconds: 50));

      if (indexToScroll != null) {
        final double offset = indexToScroll * 100.0;
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
    final FlightSearchController controller = ref.read(
      flightSearchProvider.notifier,
    );
    final FlightSearchState flightState = ref.watch(flightSearchProvider);
    final List<Map<String, dynamic>> allFlights = ref
        .watch(flightSearchProvider)
        .processedFlights;
    // final List<Map<String, dynamic>>? allInBoundFlights = ref
    //     .watch(flightSearchProvider)
    //     .processedInBoundFlights;
    int maxStops = maxStopsFor(widget.sortType);

    for (final String s in widget.selectedAirlines) {
      debugPrint('selected Airlines - $s');
    }
    debugPrint("🟣 all flights count : ${allFlights.length}");

    final List<Map<String, dynamic>> filteredFlights = allFlights.where((
      Map<String, dynamic> f,
    ) {
      debugPrint("🧳 all flights - pricing mode : ${f['pricingMode']}");
      // airlines filter
      if (!passesAirlineFilter(f, widget.selectedAirlines)) return false;

      // layover city filter (by cityCode like "TYO", "SEL")
      if (!passesLayoverCityFilter(f, widget.selectedLayovers)) return false;

      final int stops =
          int.tryParse(f['stops'].toString().split(' ').first) ?? 0;
      if (stops > maxStops) return false;

      // --- flight duration ---
      final durMin = f['durationMin'] ?? 0;
      final int dStart = widget.flightDuration.start.round();
      final int dEnd = widget.flightDuration.end.round();
      if (durMin < dStart || durMin > dEnd) return false;

      // layover duration
      final layOverMin = f['layoverMin'] ?? 0;
      final int lStart = widget.layOverDuration.start.round();
      final int lEnd = widget.layOverDuration.end.round();
      if (layOverMin < lStart || layOverMin > lEnd) return false;

      // time windows...
      if (f['isReturn'] == false) {
        final int mins = depMinutesOfDay(f['depRaw']);
        if (mins >= 0) {
          final int start = widget.takeoff.start.round();
          final int end = widget.takeoff.end.round();
          if (mins < start || mins > end) return false;
        }
        final int arrMin = depMinutesOfDay(f['arrRaw']);
        if (arrMin >= 0) {
          final int start = widget.landing.start.round();
          final int end = widget.landing.end.round();
          if (arrMin < start || arrMin > end) return false;
        }
      } else {
        final int depMin = depMinutesOfDay(f['depRaw']);
        if (depMin >= 0) {
          final int start = widget.takeoff.start.round();
          final int end = widget.takeoff.end.round();
          if (depMin < start || depMin > end) return false;
        }
        final int arrMin = depMinutesOfDay(f['arrRaw']);
        if (arrMin >= 0) {
          final int start = widget.landing.start.round();
          final int end = widget.landing.end.round();
          if (arrMin < start || arrMin > end) return false;
        }
      }
      return true;
    }).toList();

    final String sortKey = widget.sortType;
    final List<Map<String, dynamic>> sortedAllFlights =
        <Map<String, dynamic>>[...filteredFlights]..sort((Map a, Map b) {
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
        });

    final List<Map<String, dynamic>> departureFlights = sortedAllFlights
        .where(
          (Map<String, dynamic> f) =>
              f['isReturn'] == false && f['isInBoundFlight'] == false,
        )
        .toList();
    // final List<Map<String, dynamic>> returnFlights =
    //     allInBoundFlights == null || allInBoundFlights.isEmpty
    //     ? sortedAllFlights
    //           .where((Map<String, dynamic> f) => f['isReturn'] == true)
    //           .toList()
    //     : allInBoundFlights
    //           .where((Map<String, dynamic> f) => f['isReturn'] == false)
    //           .toList();
    final List<Map<String, dynamic>> returnFlights = sortedAllFlights
        .where(
          (Map<String, dynamic> f) =>
              (f['pricingMode'] == 'combined' && f['isReturn'] == true) ||
              (f['pricingMode'] == 'perleg' && f['isInBoundFlight'] == true),
        )
        .toList();

    // if (allInBoundFlights != null && allInBoundFlights.isNotEmpty) {
    //   final allInbounds = allInBoundFlights!
    //       .where((Map<String, dynamic> f) => f['isReturn'] == false)
    //       .toList();

    //   allInbounds.map((f) => returnFlights.add(f));
    // }
    final bool hasReturnFlights = returnFlights.isNotEmpty ? true : false;
    final int? activeIndex =
        (selectedDepartureIndex != null &&
            selectedDepartureIndex! >= 0 &&
            selectedDepartureIndex! < departureFlights.length)
        ? selectedDepartureIndex
        : null;

    final List<FlightListViewItem> returnFlightWidgets =
        List<FlightListViewItem>.generate(
          returnFlights.length,
          (int i) => FlightListViewItem(
            onClick: () async {
              debugPrint("👍 returnFlightWidgets clicked");
              _returnData = returnFlights[i];
              openTripDetails(context: context, isReturnPage: true);
            },
            index: i,
            flight: returnFlights[i],
            hasReturnFlights: hasReturnFlights,
          ),
        );

    // if (allInBoundFlights != null && allInBoundFlights.isNotEmpty) {
    //   debugPrint("🔴 all inbound flight empty ? ${allInBoundFlights.length}");
    // }
    debugPrint("🟠 return flight empty ? ${returnFlights.length}");

    final List<Widget> departureFlightWidgets =
        List<FlightListViewItem>.generate(
          departureFlights.length,
          (int i) => FlightListViewItem(
            onClick: returnFlightWidgets.isNotEmpty
                ? () {
                    debugPrint(
                      '☑️ departureFlightWidgets - round trip flight clicked'
                      ' -> must choose return flight',
                    );
                    _departData = departureFlights[i];
                    onDepartureClicked(i);
                  }
                : () {
                    debugPrint(
                      '☑️ departureFlightWidgets - one way flight clicked'
                      ' -> go to detail page',
                    );
                    _departData = departureFlights[i];
                    openTripDetails(context: context, isReturnPage: false);
                  },
            index: i,
            flight: departureFlights[i],
            hasReturnFlights: hasReturnFlights,
          ),
        );

    return Column(
      children: <Widget>[
        // Departure flight row (static)
        if (activeIndex != null)
          departureFlightWidgets[activeIndex]
        else
          Expanded(
            child: ListView(
              controller: _returnScrollController,
              // padding: const EdgeInsets.all(16),
              children: <Widget>[
                // ✅ Banner at the top of the scrollable list
                Container(
                  color: Colors.amber[50],
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.fontSize,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            children: const <InlineSpan>[
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
                    children: <Widget>[
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
        if (activeIndex != null && returnFlightWidgets.isNotEmpty) ...<Widget>[
          Flexible(
            child: SizedBox.expand(
              child: SlideTransition(
                position: _returnSlideAnimation,
                child: Column(
                  key: const ValueKey('return-list'),
                  children: <Widget>[
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
                        children: <Widget>[
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
                                children: returnFlightWidgets
                                    .where(
                                      (FlightListViewItem f) =>
                                          f.flight['pricingMode'] ==
                                          _departData['pricingMode'],
                                    )
                                    .toList(),
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
