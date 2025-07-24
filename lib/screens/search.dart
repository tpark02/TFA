import 'package:chat_app/screens/calendar_sheet.dart';
import 'package:chat_app/screens/search_airport_sheet.dart';
import 'package:chat_app/screens/traveler_selector_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);
  static const double _padding = 20.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
            // border: Border.all(color: Colors.red, width: 2),
            ),
        child: SizedBox.expand(
          // ✅ Fill available space
          child: Column(
            children: [
              // Avatar Row
              Container(
                decoration: const BoxDecoration(
                    // border: Border.all(color: Colors.red, width: 2),
                    ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.flight_takeoff),
                        iconSize: 30,
                        style: IconButton.styleFrom(
                            shape: const CircleBorder(),
                            backgroundColor: Colors.grey[200],
                            foregroundColor:
                                Theme.of(context).colorScheme.primary)),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.hotel),
                        iconSize: 30,
                        style: IconButton.styleFrom(
                            shape: const CircleBorder(),
                            backgroundColor: Colors.grey[200],
                            foregroundColor:
                                Theme.of(context).colorScheme.primary)),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.car_rental),
                        iconSize: 30,
                        style: IconButton.styleFrom(
                            shape: const CircleBorder(),
                            backgroundColor: Colors.grey[200],
                            foregroundColor:
                                Theme.of(context).colorScheme.primary)),
                  ],
                ),
              ),
              const SizedBox(height: _padding),
              // Search area + button
              Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: _padding),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 1),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side:
                                      BorderSide.none, // Remove default border
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
                                          const SearchAirportSheet(
                                              title: "Departure Airport"));
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
                                      builder: (ctx) =>
                                          const SearchAirportSheet(
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
                          flex: 7,
                          child: OutlinedButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20))),
                                  builder: (ctx) => const CalendarSheet());
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
                            flex: 2,
                            child: OutlinedButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20))),
                                    builder: (ctx) =>
                                        const TravelerSelectorSheet());
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    width: 1),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero),
                              ),
                              child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.person),
                                    SizedBox(width: 5),
                                    Text('1')
                                  ]),
                            ))
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
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
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
                  )
                ],
              ),

              // Bottom box
              Container(
                decoration: const BoxDecoration(
                    // border: Border.all(color: Colors.green, width: 2),
                    ),
                height: 50,
                child: const Row(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
