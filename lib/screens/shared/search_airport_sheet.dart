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

    final FlightSearchController controller = ref.read(
      flightSearchProvider.notifier,
    );

    final List<Map<String, dynamic>>? airports = await _airportSvc
        .searchHiddenAirports(iataCode: iata);

    if (airports != null) {
      final List<String> candidateDests = airports
          .map(
            (Map<String, dynamic> a) =>
                (a['iataCode'] as String?)?.toUpperCase(),
          )
          .where(
            (String? c) => c != null && c.isNotEmpty && c != iata.toUpperCase(),
          )
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
              .map(
                (Map<String, dynamic> a) =>
                    (a['iataCode'] as String?)?.toUpperCase(),
              )
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

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height * 0.7;
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

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Stack(
          children: [
            AbsorbPointer(
              absorbing: _isFetchingHidden,
              child: Container(
                constraints: BoxConstraints(maxHeight: height),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  color: Colors.white,
                ),
                child: Column(
                  children: <Widget>[
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: Theme.of(
                          context,
                        ).textTheme.headlineMedium?.fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
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
                              hintStyle: const TextStyle(color: Colors.grey),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredAirports.length,
                        itemBuilder: (BuildContext context, int index) {
                          final airport = filteredAirports[index] as Airport;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: <Widget>[
                                const Icon(Icons.local_airport),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextButton(
                                    onPressed: _isFetchingHidden
                                        ? null
                                        : () async {
                                            debugPrint(
                                              "Selected: ${airport.iataCode}",
                                            );
                                            setState(() {
                                              _selectedIataCode =
                                                  airport.iataCode;
                                              _isFetchingHidden = true;
                                            });

                                            final String selected =
                                                airport.iataCode;

                                            try {
                                              bool ok = true;
                                              if (widget.isDeparture == false) {
                                                ok = await fetchHiddenAirports(
                                                  iata: selected,
                                                );
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
                                                });
                                              }
                                            }
                                          },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      alignment: Alignment.centerLeft,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                airport.airportName,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: Theme.of(context)
                                                      .textTheme
                                                      .headlineMedium
                                                      ?.fontSize,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                '${airport.city}, ${airport.country}',
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              airport.iataCode,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.fontSize,
                                                color: const Color.fromRGBO(
                                                  48,
                                                  48,
                                                  48,
                                                  1,
                                                ),
                                              ),
                                            ),
                                            if (_isFetchingHidden &&
                                                _selectedIataCode ==
                                                    airport.iataCode)
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                  left: 8,
                                                ),
                                                child: SizedBox(
                                                  width: 16,
                                                  height: 16,
                                                  child:
                                                      CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                      ),
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
    );
  }
}
