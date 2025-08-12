import 'package:TFA/screens/flight/flight_trip_details_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:TFA/constants/colors.dart';

class FlightTripDetailsPage extends ConsumerWidget {
  const FlightTripDetailsPage({super.key, required this.isReturnPage});
  final bool isReturnPage;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primary = Theme.of(context).colorScheme.primary;
    final onPrimary = Theme.of(context).colorScheme.onPrimary;
    final textSize = Theme.of(context).textTheme.displaySmall?.fontSize;

    return Scaffold(
      backgroundColor: appBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primary,
        leading: IconButton(
          icon: Icon(Icons.close, color: onPrimary),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        centerTitle: true,
        title: Column(
          children: [
            Text(
              'Trip Details',
              style: TextStyle(color: onPrimary, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 2),
            Text(
              'ICN - JFK',
              style: TextStyle(
                color: onPrimary.withValues(alpha: 0.7),
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.ios_share, color: onPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(0)),
          border: BoxBorder.fromLTRB(
            left: BorderSide.none,
            top: BorderSide.none,
            right: BorderSide.none,
            bottom: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        child: ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: isReturnPage ? 2 : 1,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, i) => FlightTripDetailsItem(),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 20),
        decoration: BoxDecoration(
          color: primary,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(0)),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '₩1,228,361',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: textSize,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text('1 Adult', style: TextStyle(color: Colors.white70)),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primaryContainer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {},
                      child: Text(
                        'Book Now',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
