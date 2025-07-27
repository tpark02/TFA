import 'package:chat_app/screens/car_search_panel.dart';
import 'package:chat_app/screens/flight_search_panel.dart';
import 'package:chat_app/screens/hotel_search_panel.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static const double _padding = 20.0;
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
      body: Column(
        children: [
          // Avatar Row
          Container(
            decoration: const BoxDecoration(
                // border: Border.all(color: Colors.red, width: 2),
                ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 0;
                          });
                        },
                        icon: const Icon(Icons.flight_takeoff),
                        iconSize: 30,
                        style: IconButton.styleFrom(
                            shape: const CircleBorder(),
                            backgroundColor: Colors.grey[200],
                            foregroundColor: _selectedIndex == 0
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey[500]!)),
                    SizedBox(height: 8),
                    const Text("Flight")
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 1;
                          });
                        },
                        icon: const Icon(Icons.hotel),
                        iconSize: 30,
                        style: IconButton.styleFrom(
                            shape: const CircleBorder(),
                            backgroundColor: Colors.grey[200],
                            foregroundColor: _selectedIndex == 1
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey[500]!)),
                    SizedBox(height: 8),
                    const Text("Hotel")
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 2;
                          });
                        },
                        icon: const Icon(Icons.car_rental),
                        iconSize: 30,
                        style: IconButton.styleFrom(
                            shape: const CircleBorder(),
                            backgroundColor: Colors.grey[200],
                            foregroundColor: _selectedIndex == 2
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey[500]!)),
                    SizedBox(height: 8),
                    const Text("Cars")
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: _padding),
          // Search area + button
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.0, 0.1), // slight vertical offset
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: _selectedIndex == 0
                  ? const FlightSearchPanel(key: ValueKey(0))
                  : _selectedIndex == 1
                      ? const HotelSearchPanel(key: ValueKey(1))
                      : const CarSearchPanel(key: ValueKey(2)),
            ),
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
    );
  }
}
