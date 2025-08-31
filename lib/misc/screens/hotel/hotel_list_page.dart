import 'dart:async';
import 'dart:io';

import 'package:TFA/misc/providers/hotel/hotel_search_controller.dart';
import 'package:TFA/misc/providers/hotel/hotel_search_state.dart';
import 'package:TFA/providers/sort_tab_provider.dart';
import 'package:TFA/misc/screens/hotel/hotel_filter_screen.dart';
import 'package:TFA/misc/screens/hotel/hotel_search_summary_card.dart';
import 'package:TFA/utils/utils.dart';
import 'package:TFA/widgets/filter_button.dart';
import 'package:TFA/misc/widgets/hotel/hotel_card.dart';
import 'package:TFA/misc/widgets/hotel/hotel_card_animated.dart';
import 'package:TFA/widgets/search_summary_loading_card.dart';
import 'package:TFA/widgets/range_picker_sheet.dart';
import 'package:TFA/widgets/selection_bottom_sheet.dart';
import 'package:TFA/widgets/sort_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class HotelListPage extends ConsumerStatefulWidget {
  const HotelListPage({super.key});
  @override
  ConsumerState<HotelListPage> createState() => _HotelListPageState();
}

class _HotelListPageState extends ConsumerState<HotelListPage> {
  String selectedSort = 'Cost';
  int _minStars = 1;
  bool isLoading = true;
  Timer? _t;
  RangeValues priceRange = const RangeValues(0, 800000);
  RangeValues userRatingRange = const RangeValues(5, 10);
  // RangeValues flightDurationRange = const RangeValues(0, 1440);
  // RangeValues layOverDurationRange = const RangeValues(0, 1470);
  // Set<String> selectedAirlines = <String>{};
  // Set<String> selectedLayovers = <String>{};
  // List<String> kAirlines = <String>[];
  Set<String> selectedAmenities = <String>{};

  List<String> hotelAmenities = <String>[
    'Airport shuttle',
    'Babysitting',
    'Business center',
    'Children’s activities',
    'Fitness center',
    'Free internet',
    'Free parking',
    'Handicap accessible',
    'Hot tub',
    'Kitchen(ette)',
    'Laundry services',
    'Pets allowed',
    'Pool',
    'Room service',
    'Safe',
  ];

  late final ProviderSubscription<HotelSearchState> _stateSub;

  // int flightDurationSt = 0;
  // int flightDurationEnd = 0;
  // int layOverDurationSt = 0;
  // int layOverDurationEnd = 0;
  Widget _pageBody(BuildContext context, HotelSearchState hotelState) {
    final int guestCnt =
        (int.tryParse(hotelState.adultCnt) ?? 0) +
        (int.tryParse(hotelState.childCnt) ?? 0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
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
                child: HotelSearchSummaryCard(
                  city: hotelState.city,
                  dateRange: hotelState.displayDate ?? '',
                  guestsCnt: guestCnt.toString(),
                  roomCnt: hotelState.roomCnt,
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),

                child: InkWell(
                  onTap: () {},
                  child: const Icon(Icons.map_outlined, color: Colors.white),
                ),
              ),
              // Container(
              //   padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),

              //   child: InkWell(
              //     onTap: () {},
              //     child: Platform.isIOS
              //         ? const Icon(Icons.ios_share, color: Colors.white)
              //         : const Icon(Icons.share, color: Colors.white),
              //   ),
              // ),
            ],
          ),
        ),
        Container(
          color: Colors.grey[200],
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
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
                              builder: (_) => const HotelFilterScreen(),
                            ),
                          );

                      // if (result != null) {
                      //   setState(() {
                      //     selectedAirlines =
                      //         result['airlines']?.toSet() ?? selectedAirlines;
                      //     selectedLayovers =
                      //         result['layovers']?.toSet() ?? selectedLayovers;
                      //   });
                      // }
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
                      sortType: SortTab.hotelSort,
                      onSortSelected: (String value) {
                        setState(() => selectedSort = value);
                      },
                    );
                  },
                ),
                // FilterButton(
                //   label: "Travel Hacks",
                //   func: () {
                //     showModalBottomSheet(
                //       context: context,
                //       useRootNavigator: true,
                //       isScrollControlled: true,
                //       shape: const RoundedRectangleBorder(
                //         borderRadius: BorderRadius.vertical(
                //           top: Radius.circular(16),
                //         ),
                //       ),
                //       builder: (BuildContext context) =>
                //           const TravelHackBottomSheet(),
                //     );
                //   },
                // ),
                // FilterButton(
                //   label: "Stops: $selectedStops",
                //   func: () {
                //     showSortBottomSheet(
                //       title: "Stops",
                //       context: context,
                //       selectedSort: selectedStops,
                //       sortType: SortTab.stops,
                //       onSortSelected: (String value) {
                //         setState(
                //           () => selectedStops = value,
                //         ); // update parent state
                //       },
                //     );
                //   },
                // ),
                FilterButton(
                  label: "Price / Night",
                  func: () async {
                    await showRangePickerSheet(
                      context: context,
                      sheet: RangePickerSheet(
                        title: 'Price / Night',
                        min: 0,
                        max: 800000,
                        divisions: 800,
                        initial: priceRange, // ✅ use the current value
                        label: (int v) => formatCurrency(
                          v,
                          currencySymbol: '₩',
                          addPlusForMax: true,
                          maxValue: 800000,
                        ),
                        onConfirmed: (RangeValues range) {
                          setState(() => priceRange = range);
                        },
                      ),
                    );
                  },
                ),
                FilterButton(
                  label: "User Rating",
                  func: () async {
                    await showRangePickerSheet(
                      context: context,
                      sheet: RangePickerSheet(
                        title: 'User Rating',
                        min: 5,
                        max: 10,
                        divisions: ((10.0 - 5.0) / 0.1).round(),
                        initial: userRatingRange,
                        label: (int v) => v.toString(),
                        onConfirmed: (RangeValues range) {
                          setState(() => userRatingRange = range);
                        },
                      ),
                    );
                  },
                ),
                // FilterButton(
                //   label: "Flight Duration",
                //   func: () async {
                //     final int dMin = flightDurationRange.start.floor();
                //     final int dMax = flightDurationRange.end.ceil();
                //     final int divs = (dMax - dMin).clamp(1, 100000);

                //     await showRangePickerSheet(
                //       context: context,
                //       sheet: RangePickerSheet(
                //         title: 'Flight Duration',
                //         min: flightDurationSt.toDouble(),
                //         max: flightDurationEnd.toDouble(),
                //         divisions: divs,
                //         initial: RangeValues(dMin.toDouble(), dMax.toDouble()),
                //         label: formatDurationFromMinutes,
                //         onConfirmed: (RangeValues range) =>
                //             setState(() => flightDurationRange = range),
                //       ),
                //     );
                //   },
                // ),
                // FilterButton(
                //   label: "Layover Duration",
                //   func: () async {
                //     final int lMin = layOverDurationRange.start.floor();
                //     final int lMax = layOverDurationRange.end.ceil();
                //     final int divs = (lMax - lMin).clamp(1, 100000);

                //     await showRangePickerSheet(
                //       context: context,
                //       sheet: RangePickerSheet(
                //         title: 'Layover Duration',
                //         min: layOverDurationSt.toDouble(),
                //         max: layOverDurationEnd.toDouble(),
                //         divisions: divs,
                //         initial: RangeValues(lMin.toDouble(), lMax.toDouble()),
                //         label: formatDurationFromMinutes,
                //         onConfirmed: (RangeValues range) =>
                //             setState(() => layOverDurationRange = range),
                //       ),
                //     );
                //   },
                // ),
                FilterButton(
                  label: "Stars",
                  func: () {
                    showSelectionBottomSheet<int>(
                      context: context,
                      title: 'Stars',
                      items: <int>[5, 4, 3, 2, 1],
                      selected: <int>{_minStars},
                      labelOf: (int s) => s == 5 ? '5 stars' : '$s+ stars',
                      showOnlyAction: false, // no "only" button
                      trailingOf: (int s) => Row(
                        // 🔵 right-side star icons like your mock
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          s,
                          (_) => const Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                      onDone: (Set<int> set) {
                        if (set.isNotEmpty) {
                          setState(() => _minStars = set.first);
                        }
                      },
                    );
                  },
                ),
                FilterButton(
                  label: "Amenities",
                  func: () {
                    showSelectionBottomSheet<String>(
                      context: context,
                      title: 'Amenities',
                      items: hotelAmenities, // ← full list
                      selected: selectedAmenities,
                      labelOf: (String s) => s,
                      onDone: (Set<String> s) => setState(() {
                        selectedAmenities = s;
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
                  routeText: '${hotelState.city} ',
                  dateText: hotelState.displayDate ?? '',
                )
              : ListView.builder(
                  itemCount: 15,
                  padding: const EdgeInsets.only(bottom: 16),
                  itemBuilder: (context, index) {
                    return AnimatedHotelCard(
                      delay: Duration(milliseconds: 100 * index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ), // 🟢 ADD THIS
                        child: HotelCard(
                          imageUrl:
                              'https://images.unsplash.com/photo-1560347876-aeef00ee58a1?auto=format&fit=crop&w=800&q=80',
                          hotelName: 'Hotel ${index + 1}',
                          pricePerNight:
                              '₩${(148000 + index * 1000).toString()}',
                          totalPrice: '${(148000 + index * 1000) * 2}',
                          ratingValue: 8.0 + (index % 3) * 0.4,
                          ratingText: 'Very Good',
                          isSkiplagged: index % 4 == 0,
                          discountPercent: (index % 3 == 0) ? 25 : 0,
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _stateSub = ref.listenManual<HotelSearchState>(
      hotelSearchProvider,
      (HotelSearchState? prev, HotelSearchState next) async {
        // identical object → ignore
        if (prev == next) return;
        // only run when NEW state is ready (don’t gate on prev)
        // if (!_stateReady(next)) return;
        debugPrint('🎯 listenManual fired → running search…');
        // await _runSearchFrom(next);
      },
      fireImmediately: false, // first run will wait until a change arrives
    );

    isLoading = true;
    _t = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _stateSub.close();
    _t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final HotelSearchState hotelState = ref.watch(hotelSearchProvider);
    final Scaffold page = Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.primary,
        child: SafeArea(
          child: Container(
            color: Colors.grey.shade200,
            child: _pageBody(context, hotelState),
          ),
        ),
      ),
    );
    return Platform.isIOS ? CupertinoScaffold(body: page) : page;
  }
}
