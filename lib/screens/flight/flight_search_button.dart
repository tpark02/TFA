import 'package:TFA/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:TFA/providers/flight/flight_search_controller.dart';
import 'package:TFA/providers/recent_search.dart';
import 'package:TFA/screens/flight/anywhere_list_page.dart';
import 'package:TFA/screens/shared/recent_search_list.dart';

class FlightSearchButton extends ConsumerStatefulWidget {
  const FlightSearchButton({
    super.key,
    required this.padding,
    required this.user,
  });

  final double padding;
  final User? user;

  @override
  ConsumerState<FlightSearchButton> createState() => _FlightSearchButtonState();
}

class _FlightSearchButtonState extends ConsumerState<FlightSearchButton> {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final controller = ref.read(flightSearchProvider.notifier);
    final flightState = ref.watch(flightSearchProvider);
    final text = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.padding),
      child: Column(
        children: <Widget>[
          // Full-width primary action button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final hasPassengers = flightState.passengerCount > 0;
                final hasAirports =
                    flightState.departureAirportCode.isNotEmpty &&
                    flightState.arrivalAirportCode.isNotEmpty;
                final hasDate = (flightState.displayDate ?? '').isNotEmpty;

                if (!hasPassengers || !hasDate) return;

                // “Anywhere” flow
                if (!hasAirports ||
                    flightState.arrivalAirportCode == 'anywhere') {
                  controller.setArrivalAnyWhere = 'anywhere';
                  controller.setLoading(true);
                  // push anywhere list
                  if (!mounted) return;
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const AnywhereListPage(),
                    ),
                  );
                  return;
                }

                // Save recent search (requires token)
                final idToken = await widget.user?.getIdToken();
                if (idToken == null) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '❌ Unable to retrieve user token',
                        style: tt.bodyMedium,
                      ),
                    ),
                  );
                  return;
                }

                final success = await controller.addRecentSearch(
                  RecentSearch(
                    destination:
                        '${flightState.departureCity} - ${flightState.arrivalCity}',
                    tripDateRange: flightState.displayDate ?? '',
                    icons: <Widget>[
                      const SizedBox(width: 10),
                      Icon(
                        Icons.person,
                        color: cs.onSurfaceVariant,
                        size: 20,
                      ), // theming ✅
                      Text(
                        flightState.passengerCount.toString(),
                        style: tt.bodyMedium,
                      ),
                    ],
                    destinationCode:
                        '${flightState.departureAirportCode} - ${flightState.arrivalAirportCode}',
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
                    departDate: flightState.departDate,
                    returnDate: flightState.returnDate ?? '',
                  ),
                  idToken,
                );

                if (!success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '❌ Failed to save flight recent search',
                        style: tt.bodyMedium,
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: cs.primary, // theming ✅
                foregroundColor: cs.onPrimary, // theming ✅
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                elevation: 3,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                text.search_flight,
                style: tt.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.onPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          const RecentSearchList(panelName: 'flight'),
        ],
      ),
    );
  }
}
