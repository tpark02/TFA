import 'package:chat_app/screens/recent_search_panel.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/screens/calendar_sheet.dart';
import 'package:chat_app/screens/search_airport_sheet.dart';
import 'package:chat_app/screens/traveler_selector_sheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class FlightSearchPanel extends ConsumerStatefulWidget {
  const FlightSearchPanel({super.key});
  @override
  ConsumerState<FlightSearchPanel> createState() => _FlightSearchPanelState();
}

class _FlightSearchPanelState extends ConsumerState<FlightSearchPanel> {
  static const double _padding = 20.0;
  var _departureAirport = "";
  var _arrivalAirport = "";
  String? _displayDate;
  String _cabinClass = 'Economy';
  int _passengerCount = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // const SizedBox(height: _padding),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: _padding),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide.none, // Remove default border
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      onPressed: () async {
                        final result = await showModalBottomSheet<String>(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (ctx) => const SearchAirportSheet(
                            title: "Airport",
                            isDeparture: true,
                          ),
                        );

                        if (result != null) {
                          setState(() {
                            _departureAirport = result;
                          });
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.near_me),
                          const SizedBox(width: 8),
                          Text(
                            _departureAirport.isEmpty
                                ? 'Departure'
                                : _departureAirport,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide.none,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      onPressed: () async {
                        final result = await showModalBottomSheet<String>(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (ctx) => const SearchAirportSheet(
                            title: "Arrival Airport",
                            isDeparture: false,
                          ),
                        );
                        if (result != null) {
                          setState(() {
                            _arrivalAirport = result;
                          });
                        }
                      },
                      child: Row(
                        children: [
                          Icon(Icons.swap_calls),
                          SizedBox(width: 8),
                          Text(
                            _arrivalAirport.isEmpty
                                ? 'Arrival'
                                : _arrivalAirport,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: _padding),
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: OutlinedButton(
                    onPressed: () async {
                      final result = await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (ctx) => CalendarSheet(
                          firstTitle: "One Way",
                          secondTitle: "Round Trip",
                          isOnlyTab: false,
                        ),
                      );

                      if (result != null) {
                        debugPrint('showModalBottomSheet');
                        final selectedDate =
                            result['selectedDate'] as DateTime?;
                        final selectedRange =
                            result['selectedRange'] as PickerDateRange?;
                        debugPrint('selected date :$selectedDate');
                        debugPrint('selected Range : $selectedRange');
                        if (result != null) {
                          setState(() {
                            _displayDate = result['displayDate'];
                          });
                        }
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1,
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_month),
                        const SizedBox(width: _padding),
                        Text(_displayDate ?? 'Select'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 4,
                  child: OutlinedButton(
                    onPressed: () async {
                      final result = await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(0),
                          ),
                        ),
                        builder: (ctx) => const TravelerSelectorSheet(),
                      );

                      if (result != null) {
                        setState(() {
                          final rawPassenger = result['passengerCount'];
                          final rawClassIdx = result['cabinClass'];

                          _passengerCount = rawPassenger is int
                              ? rawPassenger
                              : 1;
                          int cabinIdx = rawClassIdx is int ? rawClassIdx : 0;
                          if (cabinIdx == 0) {
                            _cabinClass = 'Economy';
                          } else if (cabinIdx == 1)
                            _cabinClass = 'Premium Economy';
                          else if (cabinIdx == 2)
                            _cabinClass = 'Business';
                          else
                            _cabinClass = 'First';
                        });
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      // padding: EdgeInsets.only(
                      //     left: 10), // 🔥 Kill default horizontal padding
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1,
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.person),
                        SizedBox(width: 5),
                        Text(_passengerCount.toString()),
                        SizedBox(width: 5),
                        Text('|'),
                        SizedBox(width: 5),
                        Icon(Icons.airline_seat_recline_normal),
                        Flexible(
                          child: Text(
                            _cabinClass.toString(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: _padding),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.onPrimary,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text('Search Flight')],
                        ),
                      ),
                    ),
                  ],
                ),
                // Bottom box
                SizedBox(height: _padding),
                RecentSearchPanel(
                  destination: "Busan to New York City",
                  tripDateRange: "Aug 9 - Aug 11",
                  icons: [
                    const SizedBox(width: 10),
                    Icon(Icons.person, color: Colors.grey[500], size: 20.0),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
