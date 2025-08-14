import 'package:flutter/material.dart';

class TravelHackBottomSheet extends StatelessWidget {
  const TravelHackBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Travel Hacks',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 20),
          const Row(
            children: <Widget>[
              // const Icon(Icons.directions_walk, size: 20),
              // const SizedBox(width: 8),
              Text(
                'Self - Transfer',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              // const SizedBox(width: 6),
              Icon(Icons.info_outline, size: 16, color: Colors.grey),
              Spacer(),
              Icon(Icons.check, color: Colors.blue),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Passengers independently link two separate flights\nwithout airline aid.',
            style: TextStyle(color: Colors.black87),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Done',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
