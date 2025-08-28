import 'package:TFA/models/booking_in.dart';
import 'package:TFA/providers/flight/flight_search_controller.dart';
import 'package:TFA/screens/flight/flight_book_complete_page.dart';
import 'package:TFA/screens/flight/flight_trip_details_item.dart';
import 'package:TFA/utils/utils.dart';
import 'package:TFA/widgets/dotted_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:TFA/constants/colors.dart';
import 'package:intl/intl.dart';

class FlightTripDetailsPage extends ConsumerStatefulWidget {
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
  ConsumerState<FlightTripDetailsPage> createState() =>
      _FlightTripDetailPageState();
}

class _FlightTripDetailPageState extends ConsumerState<FlightTripDetailsPage> {
  late final FlightSearchController controller;
  late Map<String, dynamic> _departData;
  late Map<String, dynamic>? _returnData;
  late bool _isReturnPage;

  @override
  void initState() {
    super.initState();
    _departData = widget.departData;
    _returnData = widget.returnData;
    _isReturnPage = widget.isReturnPage;
    controller = ref.read(flightSearchProvider.notifier);
  }

  @override
  Widget build(BuildContext context) {
    final flightState = ref.watch(flightSearchProvider);
    final Color primary = Theme.of(context).colorScheme.primary;
    final Color onPrimary = Theme.of(context).colorScheme.onPrimary;
    final double? textSize = Theme.of(context).textTheme.displaySmall?.fontSize;

    final int adults = _departData['pax']['adults'] as int;
    final int children = _departData['pax']['children'] as int;
    final int infantsHeld = _departData['pax']['infantsHeld'] as int;
    final int infantsSeated = _departData['pax']['infantsSeated'] as int;
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

    final pricingMode = _departData['pricingMode'];

    final String currency = (_departData['price'] as String).substring(0, 1);

    final double dtp = parseCurrencyString(
      _departData['price'],
      currencySymbol: currency,
    );
    final num rtp = _returnData != null
        ? parseCurrencyString(_departData!['price'], currencySymbol: currency)
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
        itemCount: _isReturnPage ? 2 : 1,
        separatorBuilder: (_, __) => const Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
          child: DottedDivider(thickness: 2, dashLength: 2, dashGap: 6),
        ),
        itemBuilder: (_, int i) {
          if (i == 0) {
            return FlightTripDetailsItem(
              flightData: _departData,
              isReturnPage: _isReturnPage,
            );
          } else {
            return FlightTripDetailsItem(
              flightData: _returnData!,
              isReturnPage: _isReturnPage,
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
                  if (!_isReturnPage || pricingMode == 'combined') ...<Widget>[
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
                          final BookingIn bookingIn = BookingIn(
                            destination: flightState.arrivalCity,
                            tripDateRange: flightState.displayDate ?? '',
                            destinationCode: flightState.arrivalAirportCode,
                            passengerCnt: flightState.passengerCount,
                            adult: flightState.adultCnt,
                            children: flightState.childrenCnt,
                            infantLap: flightState.infantLapCnt,
                            infantSeat: flightState.infantSeatCnt,
                            cabinIdx: flightState.cabinIdx,
                            rooms: 0,
                            kind: 'flight',
                            departCode: flightState.departureAirportCode,
                            arrivalCode: flightState.arrivalAirportCode,
                            departDate: flightState.departDate ?? '',
                            returnDate: flightState.returnDate,
                            prices: ticketTotalPrice,
                          );

                          controller.createBooking(bIn: bookingIn);

                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
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
