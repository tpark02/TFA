import 'package:TFA/providers/airport/airport_selection.dart';
import 'package:TFA/providers/flight/flight_search_controller.dart';
import 'package:TFA/screens/shared/search_airport_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchSummaryCard extends ConsumerWidget {
  final String from;
  final String to;
  final String dateRange;
  final int passengerCount;
  final String cabinClass;

  const SearchSummaryCard({
    super.key,
    required this.from,
    required this.to,
    required this.dateRange,
    required this.passengerCount,
    required this.cabinClass,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(flightSearchProvider.notifier);

    return Container(
      padding: EdgeInsets.all(10),
      color: Theme.of(context).colorScheme.secondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () async {
                  final result = await showModalBottomSheet<AirportSelection>(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (ctx) => const SearchAirportSheet(
                      title: 'Airport',
                      isDeparture: true,
                    ),
                  );

                  if (result != null) {
                    controller.setDepartureCode(result.code);
                    controller.setDepartureName(result.name);
                    controller.setDepartureCity(result.city);
                  }
                },
                child: Text(
                  from,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  // handle arrow click
                },
                child: controller.returnDate == null
                    ? const Icon(
                        Icons.arrow_right_alt,
                        color: Colors.white,
                        size: 16,
                      )
                    : const Icon(
                        Icons.compare_arrows,
                        color: Colors.white,
                        size: 16,
                      ),
              ),
              const SizedBox(width: 8),
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () async {
                  final result = await showModalBottomSheet<AirportSelection>(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (ctx) => const SearchAirportSheet(
                      title: 'Arrival Airport',
                      isDeparture: false,
                    ),
                  );

                  if (result != null) {
                    controller.setArrivalCode(result.code);
                    controller.setArrivalName(result.name);
                    controller.setArrivalCity(result.city);
                  }
                },
                child: Text(
                  to,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(dateRange, style: const TextStyle(color: Colors.white)),
              const SizedBox(width: 5),
              Text("|", style: const TextStyle(color: Colors.white)),
              const SizedBox(width: 5),
              const Icon(Icons.person, color: Colors.white, size: 16),
              const SizedBox(width: 5),
              Text(
                passengerCount.toString(),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(width: 5),
              Text("|", style: const TextStyle(color: Colors.white)),
              const SizedBox(width: 5),
              const Icon(
                Icons.airline_seat_recline_normal,
                color: Colors.white,
                size: 16,
              ),
              Text(cabinClass, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }
}
