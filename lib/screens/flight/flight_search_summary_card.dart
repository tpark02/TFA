import 'package:TFA/l10n/app_localizations.dart';
import 'package:TFA/providers/airport/airport_selection.dart';
import 'package:TFA/providers/flight/flight_search_controller.dart';
import 'package:TFA/providers/flight/flight_search_state.dart';
import 'package:TFA/screens/flight/anywhere_list_page.dart';
import 'package:TFA/screens/shared/calendar_sheet.dart';
import 'package:TFA/screens/shared/search_airport_sheet.dart';
import 'package:TFA/screens/shared/traveler_selector_sheet.dart';
import 'package:TFA/utils/platform_modal_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlightSearchSummaryCard extends ConsumerWidget {
  final String from;
  final String to;
  final String dateRange;
  final String passengerCount;
  final String cabinClass;

  const FlightSearchSummaryCard({
    super.key,
    required this.from,
    required this.to,
    required this.dateRange,
    required this.passengerCount,
    required this.cabinClass,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;
    final FlightSearchController controller = ref.read(flightSearchProvider.notifier);
    final FlightSearchState flightState = ref.watch(flightSearchProvider);
    final AppLocalizations text = AppLocalizations.of(context)!;
    final Color fg = cs.onPrimary;
    final Color fgMuted = cs.onPrimary.withValues(alpha: .85);

    return Container(
      decoration: BoxDecoration(
        color: cs.onPrimaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Flexible(
                child: InkWell(
                  onTap: () async {
                    final AirportSelection? result =
                        await showPlatformModalSheet<AirportSelection>(
                          context: context,
                          builder: (_) => SearchAirportSheet(
                            title: text.origin,
                            isDeparture: true,
                          ),
                        );
                    if (result != null) {
                      if (result.code == flightState.arrivalAirportCode) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: cs.errorContainer,
                              content: Text(
                                "❌ ${text.origin} cannot be the same as ${text.destination}.",
                                style: tt.bodyMedium?.copyWith(
                                  color: cs.onErrorContainer,
                                ),
                              ),
                            ),
                          );
                        });
                        return;
                      }
                      controller.setDepartureCode(result.code, result.city);
                    }
                  },
                  child: Text(
                    from,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: tt.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: fg,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              controller.returnDate == null
                  ? Icon(
                      Icons.arrow_right_alt,
                      color: fg,
                      size: tt.bodyMedium?.fontSize,
                    )
                  : InkWell(
                      onTap: () {
                        final String d = flightState.departureAirportCode;
                        final String a = flightState.arrivalAirportCode;
                        final String dcity = flightState.departureCity;
                        final String acity = flightState.arrivalCity;
                        controller.setDepartureCode(a, acity);
                        controller.setArrivalCode(d, dcity);
                      },
                      child: Icon(
                        Icons.compare_arrows,
                        color: fg,
                        size: tt.bodyMedium?.fontSize,
                      ),
                    ),
              const SizedBox(width: 10),
              Flexible(
                child: InkWell(
                  onTap: () async {
                    final AirportSelection? result =
                        await showPlatformModalSheet<AirportSelection>(
                          context: context,
                          builder: (_) => SearchAirportSheet(
                            title: text.destination,
                            isDeparture: false,
                          ),
                        );
                    if (result != null) {
                      if (result.code == flightState.departureAirportCode) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: cs.errorContainer,
                              content: Text(
                                "❌ ${text.destination} cannot be the same as ${text.origin}.",
                                style: tt.bodyMedium?.copyWith(
                                  color: cs.onErrorContainer,
                                ),
                              ),
                            ),
                          );
                        });
                        return;
                      }
                      if (result.code.toLowerCase() == 'anywhere') {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const AnywhereListPage(),
                            ),
                          );
                        });
                        return;
                      }
                      controller.setArrivalCode(result.code, result.city);
                    }
                  },
                  child: Text(
                    to,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: tt.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: fg,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextButton(
                onPressed: () async {
                  final Map<String, DateTime?>? result =
                      await Navigator.of(
                        context,
                        rootNavigator: true,
                      ).push<Map<String, DateTime?>>(
                        MaterialPageRoute<Map<String, DateTime?>>(
                          builder: (_) => CalendarSheet(
                            key: UniqueKey(),
                            firstTitle: text.one_way,
                            secondTitle: text.round_trip,
                            isOnlyTab: false,
                            isRange: false,
                            startDays: 0,
                            endDays: 0,
                          ),
                        ),
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
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  foregroundColor: fg,
                ),
                child: Text(
                  dateRange,
                  style: tt.bodyMedium?.copyWith(color: fg),
                ),
              ),
              Flexible(
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (BuildContext ctx) =>
                          TravelerSelectorSheet(cabinIdx: flightState.cabinIdx),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(width: 5),
                      Text("|", style: tt.bodyMedium?.copyWith(color: fgMuted)),
                      const SizedBox(width: 5),
                      Icon(Icons.person, color: fg, size: 16),
                      const SizedBox(width: 5),
                      Text(
                        passengerCount,
                        style: tt.bodyMedium?.copyWith(color: fg),
                      ),
                      const SizedBox(width: 5),
                      Text("|", style: tt.bodyMedium?.copyWith(color: fgMuted)),
                      const SizedBox(width: 5),
                      Icon(
                        Icons.airline_seat_recline_normal,
                        color: fg,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          cabinClass,
                          overflow: TextOverflow.ellipsis,
                          style: tt.bodyMedium?.copyWith(color: fg),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
