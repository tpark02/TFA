// lib/screens/flight/widgets/search_inputs.dart

import 'dart:math' as math;

import 'package:TFA/providers/flight/flight_search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:TFA/providers/airport/airport_selection.dart';
import 'package:TFA/providers/flight/flight_search_controller.dart';
import 'package:TFA/screens/shared/search_airport_sheet.dart';
import 'package:TFA/screens/shared/calendar_sheet.dart';
import 'package:TFA/screens/shared/traveler_selector_sheet.dart';
import 'package:TFA/theme/button_styles.dart';

class FlightSearchInputs extends ConsumerWidget {
  const FlightSearchInputs({
    super.key,
    required this.isLoadingCity,
    required this.padding,
  });

  final bool isLoadingCity;
  final double padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FlightSearchController controller = ref.read(
      flightSearchProvider.notifier,
    );
    final FlightSearchState flightState = ref.watch(flightSearchProvider);

    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 1,
              ),
            ),
            child: Row(
              children: <Widget>[
                // Departure
                Expanded(
                  child: TextButton(
                    style: flatSegmentStyle(context),
                    onPressed: () async {
                      final AirportSelection? result =
                          await showModalBottomSheet<AirportSelection>(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            builder: (BuildContext ctx) =>
                                const SearchAirportSheet(
                                  title: 'Airport',
                                  isDeparture: true,
                                ),
                          );

                      if (result != null) {
                        controller.setDepartureCode(result.code);
                        // controller.setDepartureName(result.name);
                        controller.setDepartureCity(result.city);
                      }
                    },
                    child: Row(
                      children: <Widget>[
                        const Icon(Icons.near_me),
                        const SizedBox(width: 8),
                        isLoadingCity
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                ),
                              )
                            : Text(
                                flightState.departureAirportCode.isEmpty
                                    ? 'Departure'
                                    : flightState.departureAirportCode,
                                style: boldBodyTextStyle(context),
                              ),
                      ],
                    ),
                  ),
                ),
                Transform.rotate(
                  angle: math.pi / 2, // 180 degrees
                  child: const Icon(Icons.swap_calls),
                ),
                const SizedBox(width: 8),
                // Arrival
                Expanded(
                  child: TextButton(
                    style: flatSegmentStyle(context),
                    onPressed: () async {
                      final AirportSelection? result =
                          await showModalBottomSheet<AirportSelection>(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            builder: (BuildContext ctx) =>
                                const SearchAirportSheet(
                                  title: 'Arrival Airport',
                                  isDeparture: false,
                                ),
                          );

                      if (result != null) {
                        controller.setArrivalCode(result.code);
                        // controller.setArrivalName(result.name);
                        controller.setArrivalCity(result.city);
                      }
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        flightState.arrivalAirportCode.isEmpty
                            ? 'Arrival'
                            : flightState.arrivalAirportCode,
                        style: boldBodyTextStyle(context),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Row(
            children: <Widget>[
              // Date picker
              Expanded(
                flex: 5,
                child: OutlinedButton(
                  onPressed: () async {
                    final result = await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (BuildContext ctx) => CalendarSheet(
                        key: UniqueKey(),
                        firstTitle: 'One Way',
                        secondTitle: 'Round Trip',
                        isOnlyTab: false,
                        isRange: false,
                        startDays: 0,
                        endDays: 0,
                      ),
                    );

                    if (result != null) {
                      final departDate = result['departDate'];
                      final returnDate = result['returnDate'];

                      controller.setTripDates(
                        departDate: departDate,
                        returnDate: returnDate,
                      );
                      debugPrint(
                        "📅 selected dates depart date : $departDate, end date : ${returnDate ?? "empty"}",
                      );
                    }
                  },
                  style: outlinedButtonStyle(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const Icon(Icons.calendar_month),
                      const SizedBox(width: 8),
                      Text(
                        flightState.displayDate ?? 'Select',
                        style: boldBodyTextStyle(context),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Travelers
              Expanded(
                flex: 5,
                child: OutlinedButton(
                  onPressed: () async {
                    final result = await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (BuildContext ctx) =>
                          const TravelerSelectorSheet(),
                    );

                    if (result != null) {
                      final pax = result['passengerCount'] ?? 1;
                      final cabin = result['cabinClass'] ?? 0;
                      controller.setPassengers(count: pax, cabinIndex: cabin);
                    }
                  },
                  style: outlinedButtonStyle(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const Icon(Icons.person),
                      Text(
                        flightState.passengerCount.toString(),
                        style: boldBodyTextStyle(context),
                      ),
                      const SizedBox(width: 5),
                      const Text('|'),
                      const SizedBox(width: 5),
                      const Icon(Icons.airline_seat_recline_normal),
                      Flexible(
                        child: Text(
                          flightState.cabinClass,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: boldBodyTextStyle(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
