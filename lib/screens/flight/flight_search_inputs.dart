import 'dart:math' as math;

import 'package:TFA/providers/flight/flight_search_state.dart';
import 'package:TFA/utils/platform_modal_sheet.dart';
import 'package:TFA/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:TFA/providers/airport/airport_selection.dart';
import 'package:TFA/providers/flight/flight_search_controller.dart';
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
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final FlightSearchController controller = ref.read(
      flightSearchProvider.notifier,
    );
    final FlightSearchState flightState = ref.watch(flightSearchProvider);

    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Material(
            color: cs.surfaceContainerHighest,
            elevation: 1,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextButton(
                      style: flatSegmentStyle(context),
                      onPressed: () async {
                        final AirportSelection? result =
                            await showAirportSelectionSheet(
                              context: context,
                              title: 'Origin',
                              isDeparture: true,
                            );
                        if (result != null) {
                          controller.setDepartureCode(result.code, result.city);
                        }
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.near_me, color: cs.onSurfaceVariant),
                          const SizedBox(width: 8),
                          isLoadingCity
                              ? SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    color: cs.primary,
                                  ),
                                )
                              : Text(
                                  flightState.departureAirportCode.isEmpty
                                      ? 'Departure'
                                      : flightState.departureAirportCode,
                                  style: tt.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: cs.onSurface,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                  Transform.rotate(
                    angle: math.pi / 2,
                    child: InkWell(
                      onTap: () {
                        final String d = flightState.departureAirportCode;
                        final String a = flightState.arrivalAirportCode;
                        final String dcity = flightState.departureCity;
                        final String acity = flightState.arrivalCity;

                        controller.setArrivalCode(d, dcity);
                        controller.setDepartureCode(a, acity);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 10,
                        ),
                        child: Icon(
                          Icons.swap_calls,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      style: flatSegmentStyle(context),
                      onPressed: () async {
                        final AirportSelection? result =
                            await showAirportSelectionSheet(
                              context: context,
                              title: 'Destination',
                              isDeparture: false,
                            );
                        if (result != null) {
                          controller.setArrivalCode(result.code, result.city);
                        }
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          flightState.arrivalAirportCode.isEmpty
                              ? 'Anywhere'
                              : flightState.arrivalAirportCode,
                          style: tt.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: cs.onSurface,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Material(
                  color: cs.surfaceContainerHighest,
                  elevation: 1,
                  borderRadius: BorderRadius.circular(12),
                  child: TextButton(
                    onPressed: () async {
                      final Map<String, DateTime?>? result = await showCalender(
                        context,
                        ref,
                        'One way',
                        'Round-Trip',
                        false,
                        false,
                        0,
                        0,
                      );
                      if (result != null) {
                        final DateTime? departDate = result['departDate'];
                        final DateTime? returnDate = result['returnDate'];
                        if (departDate != null) {
                          controller.setTripDates(
                            departDate: departDate,
                            returnDate: returnDate,
                          );
                        }
                      }
                    },
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      foregroundColor: cs.onSurface,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.calendar_month, color: cs.onSurfaceVariant),
                        const SizedBox(width: 8),
                        Text(
                          flightState.displayDate ?? 'Select',
                          style: tt.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: cs.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 5,
                child: Material(
                  color: cs.surfaceContainerHighest,
                  elevation: 1,
                  borderRadius: BorderRadius.circular(12),
                  child: TextButton(
                    onPressed: () async {
                      await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (BuildContext ctx) => TravelerSelectorSheet(
                          cabinIdx: flightState.cabinIdx,
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      foregroundColor: cs.onSurface,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.person, color: cs.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Text(
                          flightState.passengerCount.toString(),
                          style: tt.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: cs.onSurface,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text('|', style: TextStyle(color: cs.onSurfaceVariant)),
                        const SizedBox(width: 5),
                        Icon(
                          Icons.airline_seat_recline_normal,
                          color: cs.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            flightState.cabinClass,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: tt.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: cs.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
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
