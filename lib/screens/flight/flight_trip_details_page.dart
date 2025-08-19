import 'package:TFA/screens/flight/flight_trip_details_item.dart';
import 'package:TFA/widgets/dotted_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:TFA/constants/colors.dart';

class FlightTripDetailsPage extends ConsumerWidget {
  const FlightTripDetailsPage({
    super.key,
    required this.isReturnPage,
    required this.departData,
    required this.returnData,
  });
  final bool isReturnPage;
  final Map<String, dynamic> departData;
  final Map<String, dynamic>? returnData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color primary = Theme.of(context).colorScheme.primary;
    final Color onPrimary = Theme.of(context).colorScheme.onPrimary;
    final double? textSize = Theme.of(context).textTheme.displaySmall?.fontSize;
    final passengerCount = departData['passengerCount'] ?? 1;
    final String passengerCntStr = passengerCount > 1
        ? '$passengerCount Adults'
        : '$passengerCount Adult';
    final pricingMode = departData['pricingMode'];

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
          children: <Widget>[
            Text(
              'Trip Details',
              style: TextStyle(color: onPrimary, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.ios_share, color: onPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: isReturnPage ? 2 : 1,
        separatorBuilder: (_, __) => const Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
          child: DottedDivider(thickness: 2, dashLength: 2, dashGap: 6),
        ),
        itemBuilder: (_, int i) {
          if (i == 0) {
            return FlightTripDetailsItem(
              flightData: departData,
              isReturnPage: isReturnPage,
            );
          } else {
            return FlightTripDetailsItem(
              flightData: returnData!,
              isReturnPage: isReturnPage,
            );
          }
        },
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
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '${departData['price']}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: textSize,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    passengerCntStr,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  if (!isReturnPage || pricingMode == 'combined') ...<Widget>[
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
