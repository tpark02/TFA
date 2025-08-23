import 'package:TFA/screens/flight/flight_book_complete_page.dart';
import 'package:TFA/screens/flight/flight_trip_details_item.dart';
import 'package:TFA/utils/utils.dart';
import 'package:TFA/widgets/dotted_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:TFA/constants/colors.dart';
import 'package:intl/intl.dart';

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
    final passengerCount = departData['pax']['passengerCount'] ?? 1;

    final int adults = departData['pax']['adults'] as int;
    final int children = departData['pax']['children'] as int;
    final int infantsHeld = departData['pax']['infantsHeld'] as int;
    final int infantsSeated = departData['pax']['infantsSeated'] as int;
    final List<String> lst = <String>[];

    if (adults > 0) lst.add('$adults ${pluralize('adult', adults)}');
    if (children > 0) {
      lst.add(
        '$children ${pluralize('child', children, irregularPlural: 'children')}',
      );
    }
    if (infantsHeld > 0) {
      lst.add('$infantsHeld ${pluralize('Infant', adults)} (Lap)');
    }
    if (infantsSeated > 0) {
      lst.add('$infantsSeated ${pluralize('adult', adults)} (Seated)');
    }

    String passengerLabel = "";
    for (final String s in lst) {
      passengerLabel += '$s | ';
    }

    final pricingMode = departData['pricingMode'];

    final String currency = (departData['price'] as String).substring(0, 1);

    final double dtp = parseCurrencyString(
      departData['price'],
      currencySymbol: currency,
    );
    final num rtp = returnData != null
        ? parseCurrencyString(returnData!['price'], currencySymbol: currency)
        : 0;

    final double p = dtp + rtp;

    final NumberFormat fmt = NumberFormat.currency(
      symbol: currency,
      decimalDigits: 2,
    );
    final String ticketTotalPrice = fmt.format(p); // "€238.04"

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
                    ticketTotalPrice,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: textSize,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    passengerLabel.substring(0, passengerLabel.length - 2),
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
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const FlightBookCompletePage(),
                            ),
                          );
                        },
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
