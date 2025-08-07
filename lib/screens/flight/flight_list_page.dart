import 'package:TFA/providers/flight/flight_search_controller.dart';
import 'package:TFA/screens/flight/flight_filter_page.dart';
import 'package:TFA/widgets/filter_button.dart';
import 'package:TFA/widgets/flight/flight_list_view.dart';
import 'package:TFA/widgets/search_summary_card.dart';
import 'package:TFA/widgets/search_summary_loading_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlightListPage extends ConsumerStatefulWidget {
  const FlightListPage({super.key});

  @override
  ConsumerState<FlightListPage> createState() => _FlightListPageState();
}

class _FlightListPageState extends ConsumerState<FlightListPage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        isLoading = true; // ✅ show loading before search
      });

      final controller = ref.read(flightSearchProvider.notifier);
      final flightState = ref.read(
        flightSearchProvider,
      ); // ✅ read only, no watch

      final (searchSuccess, searchMessage) = await controller.searchFlights(
        origin: flightState.departureAirportCode,
        destination: flightState.arrivalAirportCode,
        departureDate: flightState.departDate!,
        returnDate: flightState.returnDate,
        adults: flightState.passengerCount,
      );

      if (!searchSuccess && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(searchMessage)));
      }

      if (mounted) {
        setState(() {
          isLoading = false;

          final Map<String, dynamic> latestFlights = ref
              .read(flightSearchProvider)
              .flightResults
              .maybeWhen(data: (v) => v, orElse: () => {});
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final flightState = ref.watch(flightSearchProvider);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90), // required!
        child: Container(
          color: Theme.of(context).colorScheme.primary,
          child: SizedBox(height: 30),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).colorScheme.primary,
            padding: const EdgeInsets.fromLTRB(
              0,
              25,
              0,
              10,
            ), // status bar spacing
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SearchSummaryCard(
                    from: flightState.departureAirportCode,
                    to: flightState.arrivalAirportCode,
                    dateRange: flightState.displayDate ?? '',
                    passengerCount: flightState.passengerCount,
                    cabinClass: 'Economy',
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {},
                      icon: Icon(Icons.favorite_border, color: Colors.white),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {},
                      icon: Icon(Icons.share, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.all(10),
                        backgroundColor: Colors.white,
                        minimumSize: const Size(0, 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        side: BorderSide(color: Colors.grey[400]!, width: 1),
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) {
                            return DraggableScrollableSheet(
                              expand: true,
                              initialChildSize: 1.0,
                              minChildSize: 1.0,
                              maxChildSize: 1.0,
                              builder: (context, scrollController) {
                                return Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(16),
                                    ),
                                  ),
                                  child: FlightFilterPage(
                                    scrollController: scrollController,
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                      child: Icon(Icons.tune, size: 23),
                    ),
                  ),
                  FilterButton(label: "Sort: Cost"),
                  FilterButton(label: "Travel Hacks"),
                  FilterButton(label: "Stops"),
                  FilterButton(label: "Take Off"),
                  FilterButton(label: "Landing"),
                  FilterButton(label: "Flight Duration"),
                  FilterButton(label: "Layover Duration"),
                  FilterButton(label: "Airlines"),
                  FilterButton(label: "Arrival Airport"),
                  FilterButton(label: "Layover Cities"),
                ],
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? SearchSummaryLoadingCard(
                    routeText:
                        '${flightState.departureAirportCode} - ${flightState.arrivalAirportCode}',
                    dateText: flightState.displayDate!,
                  )
                : FlightListView(),
          ),
        ],
      ),
    );
  }
}
