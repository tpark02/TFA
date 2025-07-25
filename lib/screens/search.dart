import 'package:chat_app/screens/search_flight.dart';
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
            child: _selectedIndex == 0
                ? SearchFlight()
                : _selectedIndex == 1
                    ? SearchFlight()
                    : SearchFlight(),
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
