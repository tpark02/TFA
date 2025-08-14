import 'package:TFA/providers/flight/flight_search_controller.dart';
import 'package:TFA/screens/car/car_search_panel.dart';
import 'package:TFA/screens/flight/flight_search_panel.dart';
import 'package:TFA/screens/hotel/hotel_search_panel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// This is the wrapper with nested navigator
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) =>
          MaterialPageRoute(builder: (_) => const _SearchContent()),
    );
  }
}

class _SearchContent extends ConsumerStatefulWidget {
  const _SearchContent();

  @override
  ConsumerState<_SearchContent> createState() => _SearchContentState();
}

class _SearchContentState extends ConsumerState<_SearchContent> {
  static const double _padding = 20.0;
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        title: const Text('Search'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              ref.read(flightSearchProvider.notifier).clearRecentSearches();
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.exit_to_app, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: _padding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildTabIcon(context, 0, Icons.flight_takeoff, "Flight"),
              _buildTabIcon(context, 1, Icons.hotel, "Hotel"),
              _buildTabIcon(context, 2, Icons.directions_car_filled, "Cars"),
            ],
          ),
          SizedBox(height: _selectedIndex != 2 ? _padding * 2 : _padding),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) => FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 0.1),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              ),
              child: _selectedIndex == 0
                  ? const FlightSearchPanel(key: ValueKey(0))
                  : _selectedIndex == 1
                  ? const HotelSearchPanel(key: ValueKey(1))
                  : const CarSearchPanel(key: ValueKey(2)),
            ),
          ),
          const SizedBox(height: 50), // dummy bottom spacing
        ],
      ),
    );
  }

  Widget _buildTabIcon(
    BuildContext context,
    int index,
    IconData icon,
    String label,
  ) {
    final bool isSelected = _selectedIndex == index;

    return Column(
      children: <Widget>[
        IconButton(
          onPressed: () => setState(() => _selectedIndex = index),
          icon: Icon(icon),
          iconSize: 50,
          style: IconButton.styleFrom(
            shape: const CircleBorder(),
            backgroundColor: Colors.grey[200],
            foregroundColor: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey[500]!,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
