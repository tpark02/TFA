import 'package:chat_app/screens/recent_search_panel.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/screens/calendar_sheet.dart';
import 'package:chat_app/screens/search_airport_sheet.dart';
import 'package:chat_app/screens/traveler_selector_sheet.dart';

class FlightSearchPanel extends StatefulWidget {
  const FlightSearchPanel({super.key});
  @override
  State<FlightSearchPanel> createState() => _FlightSearchPanelState();
}

class _FlightSearchPanelState extends State<FlightSearchPanel> {
  static const double _padding = 20.0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: _padding),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).colorScheme.primary, width: 1),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide.none, // Remove default border
                          foregroundColor:
                              Theme.of(context).colorScheme.primary,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20))),
                              builder: (ctx) =>
                                  const SearchAirportSheet(title: "Airport"));
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.near_me),
                            SizedBox(width: 8),
                            Text('Departure'),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide.none,
                          foregroundColor:
                              Theme.of(context).colorScheme.primary,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20))),
                              builder: (ctx) => const SearchAirportSheet(
                                  title: "Arrival Airport"));
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.swap_calls),
                            SizedBox(width: 8),
                            Text('Arrival'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: _padding),
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: OutlinedButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20))),
                          builder: (ctx) => CalendarSheet(
                                firstTitle: "One Way",
                                secondTitle: "Round Trip",
                                isOnlyTab: false,
                              ));
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero),
                    ),
                    child: const Row(children: [
                      Icon(Icons.calendar_month),
                      SizedBox(width: _padding),
                      Text('Search')
                    ]),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                    flex: 4,
                    child: OutlinedButton(
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20))),
                            builder: (ctx) => const TravelerSelectorSheet());
                      },
                      style: OutlinedButton.styleFrom(
                        // padding: EdgeInsets.only(
                        //     left: 10), // 🔥 Kill default horizontal padding
                        side: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1),
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero),
                      ),
                      child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.person),
                            SizedBox(width: 5),
                            Text('1'),
                            SizedBox(width: 5),
                            Text('|'),
                            SizedBox(width: 5),
                            Icon(Icons.airline_seat_recline_normal),
                            Text('Eco'),
                          ]),
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: _padding),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text('Search Flight')]),
                  ),
                )
              ],
            ),
          ),
          // Bottom box
          Padding(
            padding: const EdgeInsets.all(_padding),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 2),
              ),
              height: 1000,
              child: const Column(
                children: [
                  SizedBox(height: _padding),
                  RecentSearchPanel(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
