import 'package:flutter/material.dart';

class SearchSummaryCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      color: Theme.of(context).colorScheme.secondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                from,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.compare_arrows, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Text(
                to,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
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
