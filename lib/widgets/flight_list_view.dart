import 'package:TFA/widgets/flight_list_view_item.dart';
import 'package:flutter/material.dart';

class FlightListView extends StatefulWidget {
  const FlightListView({super.key, required this.showModal});
  final void Function() showModal;

  @override
  State<FlightListView> createState() => _FlightListViewState();
}

class _FlightListViewState extends State<FlightListView>
    with TickerProviderStateMixin {
  final ScrollController _returnScrollController = ScrollController();
  int? selectedDepartureIndex;

  late AnimationController _returnAnimController;
  late Animation<Offset> _returnSlideAnimation;

  @override
  void initState() {
    super.initState();
    _returnAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
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
      });

      await Future.delayed(const Duration(milliseconds: 50));

      // Scroll back to where user clicked before
      if (indexToScroll != null) {
        final offset = indexToScroll * 100.0; // adjust height if needed
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
    });

    await Future.delayed(const Duration(milliseconds: 50));
    _returnAnimController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final departureFlightWidgets = List.generate(
      10,
      (i) => FlightListViewItem(onClick: () => onDepartureClicked(i), index: i),
    );
    final returnFlights = List.generate(
      10,
      (index) => FlightListViewItem(onClick: () {}, index: index),
    );
    return Column(
      children: [
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
                      TextSpan(text: 'Automatic protection on every flight. '),
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
                  backgroundColor: Theme.of(context).colorScheme.primary,
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
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey[100],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Choose Departing flight",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("Total Cost", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),

        // Departure flight row (static)
        if (selectedDepartureIndex != null)
          departureFlightWidgets[selectedDepartureIndex!]
        else
          Expanded(
            child: ListView.builder(
              controller: _returnScrollController,
              padding: const EdgeInsets.all(16),
              itemCount: departureFlightWidgets.length,
              itemBuilder: (_, i) => departureFlightWidgets[i],
            ),
          ),

        // Return flight list below
        if (selectedDepartureIndex != null) ...[
          Flexible(
            child: SlideTransition(
              position: _returnSlideAnimation,
              child: Column(
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
                    child: ListView.builder(
                      controller: _returnScrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: returnFlights.length,
                      itemBuilder: (_, i) => returnFlights[i],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
