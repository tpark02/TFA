import 'package:TFA/providers/flight/flight_search_controller.dart';
import 'package:TFA/widgets/flight_list_view_item.dart';
import 'package:TFA/widgets/search_summary_loading_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlightListView extends ConsumerStatefulWidget {
  const FlightListView({super.key});

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
  Widget build(BuildContext context) {
    final flightState = ref.watch(flightSearchProvider);

    final allFlights = ref.watch(flightSearchProvider).processedFlights;
    final departureFlights = allFlights
        .where((f) => f['isReturn'] == false)
        .toList();
    final returnFlights = allFlights
        .where((f) => f['isReturn'] == true)
        .toList();

    final departureFlightWidgets = List.generate(
      departureFlights.length,
      (i) => FlightListViewItem(
        onClick: () => onDepartureClicked(i),
        index: i,
        flight: departureFlights[i],
      ),
    );

    List<Widget> returnFlightWidgets = List.generate(
      returnFlights.length,
      (i) => FlightListViewItem(
        onClick: () {},
        index: i,
        flight: returnFlights[i],
      ),
    );

    return Column(
      children: [
        // Departure flight row (static)
        if (selectedDepartureIndex != null)
          departureFlightWidgets[selectedDepartureIndex!]
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
                              ).textTheme.headlineMedium?.fontSize,
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
        if (selectedDepartureIndex != null &&
            returnFlightWidgets.isNotEmpty) ...[
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
                                    returnFlights[selectedDepartureIndex!]['airportPath'],
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
