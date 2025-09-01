import 'package:TFA/l10n/app_localizations.dart';
import 'package:TFA/screens/flight/empty_screen.dart';
import 'package:TFA/screens/flight/my_trips_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:TFA/providers/flight/flight_search_controller.dart';
import 'package:TFA/providers/flight/flight_search_state.dart';
import 'package:TFA/utils/platform_modal_sheet.dart';
import 'package:TFA/utils/utils.dart';
import 'package:TFA/screens/flight/flight_list_view_item.dart';
import 'package:TFA/widgets/search_summary_loading_card.dart';

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
  List<FlightListViewItem> returnFlightWidgets = <FlightListViewItem>[];

  void openTripDetails({
    required BuildContext context,
    required bool isReturnPage,
  }) async {
    await showTripDetailsModal(
      context: context,
      isReturnPage: isReturnPage,
      departData: _departData,
      returnData: _returnData,
    );
  }

  void onDepartureClicked(int index) async {
    if (selectedDepartureIndex == index) {
      await _returnAnimController.reverse();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      final int? indexToScroll = selectedDepartureIndex;
      setState(() {
        selectedDepartureIndex = null;
        isLoading = true;
      });
      await Future<void>.delayed(const Duration(milliseconds: 50));
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

    await Future<void>.delayed(const Duration(milliseconds: 10));
    _returnAnimController.forward(from: 0);
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => isLoading = false);
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
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final text = AppLocalizations.of(context)!;

    final FlightSearchState flightState = ref.watch(flightSearchProvider);
    final List<Map<String, dynamic>> allFlights = flightState.processedFlights;

    final int maxStops = maxStopsFor(widget.stopType);

    final List<Map<String, dynamic>> filteredFlights = allFlights.where((f) {
      if (widget.selectedAirlines.isNotEmpty &&
          !widget.selectedAirlines.contains(f['airline'])) {
        return false;
      }

      for (final l in (f['layOverAirports'] as List<String>)) {
        if (widget.selectedLayovers.isNotEmpty &&
            !widget.selectedLayovers.contains(l)) {
          return false;
        }
      }

      final int stops =
          int.tryParse(f['stops'].toString().split(' ').first) ?? 0;
      if (stops > maxStops) return false;

      final int durMin = f['durationMin'] ?? 0;
      final int dStart = widget.flightDuration.start.round();
      final int dEnd = widget.flightDuration.end.round();
      if (durMin < dStart || durMin > dEnd) return false;

      final int layOverMin = f['layoverMin'] ?? 0;
      final int lStart = widget.layOverDuration.start.round();
      final int lEnd = widget.layOverDuration.end.round();
      if (layOverMin < lStart || layOverMin > lEnd) return false;

      if (f['isReturn'] == false) {
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
        <Map<String, dynamic>>[...filteredFlights]..sort((a, b) {
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

    final departureFlights = sortedAllFlights.where((f) {
      return (f['pricingMode'] == 'combined' && f['isReturn'] == false) ||
          (f['pricingMode'] == 'perleg' && f['isInBoundFlight'] == false);
    }).toList();

    final returnFlights = sortedAllFlights.where((f) {
      return (f['pricingMode'] == 'combined' && f['isReturn'] == true) ||
          (f['pricingMode'] == 'perleg' && f['isInBoundFlight'] == true);
    }).toList();

    final bool hasReturnFlights = returnFlights.isNotEmpty;
    final int? activeIndex =
        (selectedDepartureIndex != null &&
            selectedDepartureIndex! >= 0 &&
            selectedDepartureIndex! < departureFlights.length)
        ? selectedDepartureIndex
        : null;

    returnFlightWidgets = List<FlightListViewItem>.generate(
      returnFlights.length,
      (int i) => FlightListViewItem(
        onClick: () async {
          _returnData = returnFlights[i];
          openTripDetails(context: context, isReturnPage: true);
        },
        index: i,
        flight: returnFlights[i],
        hasReturnFlights: hasReturnFlights,
      ),
    );

    final departureFlightWidgets = List<FlightListViewItem>.generate(
      departureFlights.length,
      (int i) {
        return FlightListViewItem(
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
          hasReturnFlights: hasReturnFlights,
        );
      },
    );

    return departureFlightWidgets.isEmpty
        ? EmptyScreen(msg: "There are no flights", showButton: false)
        : Container(
            color: cs.surface,
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest,
                    border: Border(
                      top: BorderSide(color: cs.outlineVariant, width: 0.0),
                      bottom: BorderSide(color: cs.outlineVariant, width: 1.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        text.choose_departing_flight,
                        style: tt.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.onSurface,
                        ),
                      ),
                      Text(
                        text.total_cost,
                        style: tt.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (activeIndex != null)
                  departureFlightWidgets[activeIndex]
                else
                  Flexible(
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView(
                        controller: _returnScrollController,
                        children: <Widget>[...departureFlightWidgets],
                      ),
                    ),
                  ),
                if (activeIndex != null && returnFlightWidgets.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest,
                      border: Border(
                        top: BorderSide(color: cs.outlineVariant, width: 1.0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          text.choose_returning_flight,
                          style: tt.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: cs.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: SizedBox.expand(
                        child: SlideTransition(
                          position: _returnSlideAnimation,
                          child: Column(
                            key: const ValueKey<String>('return-list'),
                            children: <Widget>[
                              Expanded(
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  child: isLoading
                                      ? SearchSummaryLoadingCard(
                                          key: const ValueKey<String>(
                                            'shimmer',
                                          ),
                                          routeText:
                                              (activeIndex <
                                                  departureFlights.length)
                                              ? (departureFlights[activeIndex]['airportPath']
                                                        as String? ??
                                                    '')
                                              : '',
                                          dateText:
                                              flightState.displayDate ?? '',
                                        )
                                      : ListView(
                                          key: const ValueKey<String>(
                                            'return-list',
                                          ),
                                          controller: _returnScrollController,
                                          children: filterReturnFlightWidgets(),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
  }

  List<Widget> filterReturnFlightWidgets() {
    final String mode = _departData['pricingMode'] as String;
    if (mode == 'perleg') {
      return returnFlightWidgets
          .where((f) => f.flight['pricingMode'] == 'perleg')
          .toList();
    }
    return returnFlightWidgets
        .where(
          (f) =>
              (f.flight['pricingMode'] == 'combined') &&
              f.flight['parentFlightNumber'] == _departData['myFlightNumber'],
        )
        .toList();
  }
}
