import 'package:TFA/models/airport.dart';
import 'package:TFA/providers/airport/airport_selection.dart';
import 'package:TFA/providers/airport/airport_provider.dart';
import 'package:TFA/providers/flight/flight_search_controller.dart';
import 'package:TFA/services/airport_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer' as dev;
import 'dart:math';

class SearchAirportSheet extends ConsumerStatefulWidget {
  const SearchAirportSheet({
    super.key,
    required this.title,
    required this.isDeparture,
  });

  final String title;
  final bool isDeparture;

  @override
  ConsumerState<SearchAirportSheet> createState() => _AirportSheetState();
}

class _AirportSheetState extends ConsumerState<SearchAirportSheet> {
  final AirportService _airportSvc = AirportService();
  String? _selectedIataCode;

  bool _isFetchingHidden = false;
  Future<bool>? _inFlightHidden;

  Future<bool> fetchHiddenAirports({required String iata}) {
    _inFlightHidden ??= _doFetchHiddenAirports(iata: iata).whenComplete(() {
      _inFlightHidden = null;
    });
    return _inFlightHidden!;
  }

  Future<bool> _doFetchHiddenAirports({required String iata}) async {
    if (!mounted) return false;

    final FlightSearchController controller = ref.read(flightSearchProvider.notifier);

    final List<Map<String, dynamic>>? airports = await _airportSvc
        .searchHiddenAirports(iataCode: iata);

    if (airports != null) {
      final List<String> candidateDests = airports
          .map((Map<String, dynamic> a) => (a['iataCode'] as String?)?.toUpperCase())
          .where((String? c) => c != null && c.isNotEmpty && c != iata.toUpperCase())
          .cast<String>()
          .toSet()
          .take(12)
          .toList();
      logHcCandidates(
        exitViaIata: iata,
        candidateDests: candidateDests,
        nearbyRaw: airports,
      );
      controller.setHiddenAirporCodeList(candidateDests);
    }

    return true;
  }

  void logHcCandidates({
    required String? exitViaIata,
    required List<String> candidateDests,
    List<Map<String, dynamic>>? nearbyRaw,
  }) {
    final String exit = (exitViaIata ?? '???').toUpperCase();
    final int n = candidateDests.length;

    dev.log(
      '✈️  Hidden-City candidates ($n) for exitVia=📍$exit',
      name: 'hidden_city',
      time: DateTime.now(),
      sequenceNumber: n,
    );

    if (n == 0) {
      final List<String> nearbyCodes =
          (nearbyRaw ?? const <Map<String, dynamic>>[])
              .map((Map<String, dynamic> a) => (a['iataCode'] as String?)?.toUpperCase())
              .where((String? c) => c != null && c.isNotEmpty)
              .cast<String>()
              .toList();
      dev.log(
        '⚠️  No candidates built. Nearby returned: ${nearbyCodes.join(' · ')}',
        name: 'hidden_city',
      );
      return;
    }

    for (int i = 0; i < n; i += 10) {
      final String chunk = candidateDests
          .sublist(i, min(i + 10, n))
          .join(' • ');
      dev.log('🧩 [$i…${min(i + 9, n - 1)}] $chunk', name: 'hidden_city');
    }

    dev.log(
      '✅  Ready to search Y=📍$exit → Z=🎯($n codes)',
      name: 'hidden_city',
    );
  }

  Widget buildAirportListItems(List filteredAirports, int index) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

    final Airport airport = filteredAirports[index] as Airport;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: <Widget>[
          Icon(Icons.local_airport, color: cs.primary),
          const SizedBox(width: 8),
          Expanded(
            child: TextButton(
              onPressed: _isFetchingHidden
                  ? null
                  : () async {
                      setState(() {
                        _selectedIataCode = airport.iataCode;
                        _isFetchingHidden = true;
                      });

                      final String selected = airport.iataCode;
                      try {
                        bool ok = true;
                        if (!widget.isDeparture) {
                          ok = await fetchHiddenAirports(iata: selected);
                        }
                        if (!mounted) return;
                        if (widget.isDeparture || ok) {
                          Navigator.pop(
                            context,
                            AirportSelection(
                              name: airport.airportName,
                              code: selected,
                              city: airport.city,
                            ),
                          );
                        }
                      } finally {
                        if (mounted) {
                          setState(() {
                            _isFetchingHidden = false;
                            ref.invalidate(airportSearchQueryProvider);
                          });
                        }
                      }
                    },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
                foregroundColor: cs.onSurface,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Airport name
                        Text(
                          airport.airportName,
                          overflow: TextOverflow.ellipsis,
                          style: tt.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: cs.onSurface,
                          ),
                        ),
                        // City, Country
                        Text(
                          '${airport.city}, ${airport.country}',
                          overflow: TextOverflow.ellipsis,
                          style: tt.bodySmall?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      // IATA
                      Text(
                        airport.iataCode,
                        overflow: TextOverflow.ellipsis,
                        style: tt.bodyMedium?.copyWith(
                          color: cs.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (_isFetchingHidden &&
                          _selectedIataCode == airport.iataCode)
                        const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

    final double height = MediaQuery.of(context).size.height;
    final String query = ref.watch(airportSearchQueryProvider);
    final AsyncValue<List<Airport>> airportData = ref.watch(
      airportDataProvider,
    );

    final List filteredAirports = airportData.maybeWhen(
      data: (List<Airport> airports) {
        if (query.length < 2) return <dynamic>[];
        final String q = query.toLowerCase();
        return airports.where((Airport a) {
          return a.iataCode.toLowerCase().contains(q) ||
              a.airportName.toLowerCase().contains(q) ||
              a.city.toLowerCase().contains(q) ||
              a.country.toLowerCase().contains(q);
        }).toList();
      },
      orElse: () => <dynamic>[],
    );

    return Material(
      color: cs.surface,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Stack(
            children: <Widget>[
              AbsorbPointer(
                absorbing: _isFetchingHidden,
                child: Container(
                  constraints: BoxConstraints(maxHeight: height),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(0),
                    ),
                    color: cs.surface,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      // Header
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.close,
                                size: 24,
                                color: cs.onSurface,
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            Text(
                              widget.title,
                              style: tt.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: cs.onSurface,
                              ),
                            ),
                            const SizedBox(width: 48), // keeps title centered
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Search field
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              onChanged: (String value) =>
                                  ref
                                          .read(
                                            airportSearchQueryProvider.notifier,
                                          )
                                          .state =
                                      value,
                              decoration: InputDecoration(
                                hintText: widget.isDeparture ? "From" : "To",
                                hintStyle: tt.bodyMedium?.copyWith(
                                  color: cs.onSurfaceVariant,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: cs.primary,
                                ),
                                filled: true,
                                fillColor: cs.surfaceContainerHighest,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: cs.outlineVariant,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: cs.primary,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                              ),
                              style: tt.bodyMedium?.copyWith(
                                color: cs.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Results / Anywhere
                      Expanded(
                        child: ListView.builder(
                          itemCount: filteredAirports.isNotEmpty
                              ? filteredAirports.length
                              : !widget.isDeparture
                              ? 1
                              : 0,
                          itemBuilder: (BuildContext context, int index) {
                            if (filteredAirports.isEmpty) {
                              return const AnyWhereButton();
                            } else {
                              return buildAirportListItems(
                                filteredAirports,
                                index,
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_isFetchingHidden)
                const Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(minHeight: 2),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnyWhereButton extends ConsumerWidget {
  const AnyWhereButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

    final FlightSearchController controller = ref.read(flightSearchProvider.notifier);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () {
          controller.setArrivalAnyWhere = "anywhere";
          Navigator.pop(
            context,
            const AirportSelection(
              name: "anywhere",
              code: "anywhere",
              city: "anywhere",
            ),
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Icon(Icons.public, size: 32, color: cs.secondary),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Anywhere",
                  style: tt.bodyLarge?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "See the best deals from your departure",
                  style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ),
            const SizedBox(width: 30),
            Text(
              "ANY",
              style: tt.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
