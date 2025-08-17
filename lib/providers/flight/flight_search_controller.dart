import 'dart:io';

import 'package:TFA/providers/iata_country_provider.dart';
import 'package:TFA/providers/recent_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'flight_search_state.dart';
import 'package:TFA/services/recent_search_service.dart';
import 'package:TFA/services/flight_api_service.dart';
import 'package:TFA/types/typedefs.dart';

class FlightSearchController extends StateNotifier<FlightSearchState> {
  FlightSearchController(this._ref) : super(FlightSearchState());
  final Ref _ref;
  int _parseIsoDurMin(String s) {
    final RegExpMatch? m = RegExp(
      r'P(?:(\d+)D)?T(?:(\d+)H)?(?:(\d+)M)?',
    ).firstMatch(s);
    final int d = int.tryParse(m?.group(1) ?? '0') ?? 0;
    final int h = int.tryParse(m?.group(2) ?? '0') ?? 0;
    final int mins = int.tryParse(m?.group(3) ?? '0') ?? 0;
    return d * 1440 + h * 60 + mins;
  }

  String _fmtHM(int mins) {
    final int h = mins ~/ 60;
    final int m = mins % 60;
    return '${h}h ${m}m';
  }

  Future<FlightSearchResult> searchFlights({
    required String origin,
    required String destination,
    required String departureDate,
    required String? returnDate,
    required int adults,
    int maxResults = 20,
    required bool isInboundFlight,
    required PricingMode mode,
  }) async {
    state = state.copyWith(isLoading: true);
    // state = state.copyWithFlightResults(const AsyncValue.loading());

    debugPrint("1 depart date : $departureDate");
    debugPrint("2 return date : $returnDate");

    try {
      final Map<String, dynamic> result = await FlightApiService.fetchFlights(
        origin: origin,
        destination: destination,
        departureDate: departureDate,
        returnDate: returnDate,
        adults: adults,
        maxResults: maxResults,
      );

      final List<Map<String, dynamic>> res = processFlights(
        result,
        mode,
        isInboundFlight,
      );

      state = state.copyWith(
        processedFlights: <Map<String, dynamic>>[
          ...state.processedFlights,
          ...res,
        ],
      );
      return (true, '✅ Flight search completed');
    } catch (e) {
      // state = state.copyWithFlightResults(AsyncValue.error(e, st));
      return (false, '❌ Flight search failed: $e');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  String _codeToName(String code, Map<String, dynamic> carriers) {
    final String up = code.toUpperCase();
    if (up == 'HR') return 'HAHN AIR';
    if (up == 'H1') return 'HAHN AIR SYSTEMS';
    return (carriers[up] as String?) ?? up; // fallback to code
  }

  // ✅ Add full per-stop details (dep/arr time/code/terminal, flight no, aircraft, cabin, booking class, bags)
  // ✅ Also add connection (layover) details between segments

  List<Map<String, dynamic>> processFlights(
    Map<String, dynamic> latestFlights,
    PricingMode mode,
    bool isInBoundFlight,
  ) {
    final List<Map<String, dynamic>> results = <Map<String, dynamic>>[];

    final List<Map<String, dynamic>> data =
        (latestFlights['data'] as List<dynamic>? ?? <dynamic>[])
            .cast<Map<String, dynamic>>();
    final Map<String, dynamic> dictionaries =
        (latestFlights['dictionaries'] as Map<String, dynamic>? ??
        <String, dynamic>{});
    final Map<String, String> carriers =
        ((dictionaries['carriers'] as Map<String, dynamic>? ??
                <String, dynamic>{}))
            .map(
              (String k, v) => MapEntry(
                k.toString().toUpperCase(),
                v.toString().toUpperCase(),
              ),
            );
    final Map<String, dynamic> locations =
        (dictionaries['locations'] as Map<String, dynamic>? ??
                const <String, dynamic>{})
            .cast<String, dynamic>();
    final Map<String, String> aircraftDict =
        (dictionaries['aircraft'] as Map<String, dynamic>? ??
                const <String, dynamic>{})
            .cast<String, String>();

    for (final Map<String, dynamic> offer in data) {
      if (offer.isEmpty) continue;

      final List<Map<String, dynamic>> itineraries =
          (offer['itineraries'] as List<dynamic>? ?? <dynamic>[])
              .cast<Map<String, dynamic>>();
      if (itineraries.isEmpty) continue;

      final List<String> validatingList =
          ((offer['validatingAirlineCodes'] as List<dynamic>? ?? <dynamic>[]))
              .map((e) => e.toString().toUpperCase())
              .toList();
      final String? validatingCode = validatingList.isNotEmpty
          ? validatingList.first
          : null;
      final String? validatingName = validatingCode != null
          ? _codeToName(validatingCode, carriers)
          : null;

      final Map<String, dynamic> priceMap =
          (offer['price'] as Map<String, dynamic>? ??
          const <String, dynamic>{});
      final price = priceMap['grandTotal'];
      final String currency = (priceMap['currency'] ?? 'EUR').toString();
      final String formattedPrice = NumberFormat.simpleCurrency(
        name: currency,
      ).format(double.tryParse(price.toString()) ?? 0);

      // 🔎 traveler/cabin details (used per segment)
      final List<Map<String, dynamic>> travelerPricings =
          (offer['travelerPricings'] as List<dynamic>? ?? <dynamic>[])
              .cast<Map<String, dynamic>>();
      if (travelerPricings.isEmpty) continue;

      // we use first traveler as representative (common pattern)
      final Map<String, dynamic> firstTraveler = travelerPricings.first;
      final List<Map<String, dynamic>> fareDetailsBySegment =
          (firstTraveler['fareDetailsBySegment'] as List<dynamic>? ??
                  <dynamic>[])
              .cast<Map<String, dynamic>>();

      // 🟢 Build quick lookups by segmentId -> cabin / bookingClass / bags
      final Map<String, String?> segCabin = <String, String?>{};
      final Map<String, String?> segBookingClass = <String, String?>{};
      final Map<String, dynamic> segCheckedBags = <String, dynamic>{};
      final Map<String, dynamic> segCabinBags = <String, dynamic>{};
      for (final Map<String, dynamic> fd in fareDetailsBySegment) {
        final String id = (fd['segmentId'] ?? '').toString();
        segCabin[id] = fd['cabin'] as String?;
        segBookingClass[id] = fd['class'] as String?;
        if (fd['includedCheckedBags'] != null) {
          segCheckedBags[id] = fd['includedCheckedBags'];
        }
        if (fd['includedCabinBags'] != null) {
          segCabinBags[id] = fd['includedCabinBags'];
        }
      }

      for (int i = 0; i < itineraries.length; i++) {
        final Map<String, dynamic> itinerary = itineraries[i];
        final List<Map<String, dynamic>> segments =
            (itinerary['segments'] as List<dynamic>? ?? <dynamic>[])
                .cast<Map<String, dynamic>>();
        if (segments.isEmpty) continue;

        // Primary marketing
        final String primaryMarketingCode =
            (segments.first['carrierCode'] as String).toUpperCase();
        final String primaryMarketNumber = (segments.first['number'] as String);
        final String primaryMarketingName = _codeToName(
          primaryMarketingCode,
          carriers,
        );

        final Set<String> marketingCodes = <String>{
          for (final Map<String, dynamic> s in segments)
            (s['carrierCode'] as String).toUpperCase(),
        }..removeWhere((String c) => c == 'HR' || c == 'H1');
        final Set<String> marketingNames = marketingCodes
            .map((String c) => _codeToName(c, carriers))
            .toSet();

        // Times / day shift
        final Map<String, dynamic> firstSegment = segments.first;
        final Map<String, dynamic> lastSegment = segments.last;

        final Map depObj = (firstSegment['departure'] as Map);
        final Map arrObj = (lastSegment['arrival'] as Map);
        final String? depRaw = depObj['at'] as String?;
        final String? arrRaw = arrObj['at'] as String?;
        if (depRaw == null || arrRaw == null) continue;

        final String depTime = formatTime(depRaw);
        final String arrTime = formatTime(arrRaw);
        final int dayDiff = DateTime.parse(
          arrRaw,
        ).difference(DateTime.parse(depRaw)).inDays;
        final String plusDay = dayDiff > 0 ? '+$dayDiff' : '';

        // 🧭 Per-connection layovers + total
        final List<String> stopAirports = <String>[];
        int totalLayoverMin = 0;
        final List<Map<String, dynamic>> connections =
            <Map<String, dynamic>>[]; // each layover between segments

        for (int j = 0; j < segments.length; j++) {
          final Map<String, dynamic> seg = segments[j];

          // intra-segment tech stops (rare)
          final List segStops =
              (seg['stops'] as List<dynamic>? ?? const <dynamic>[]);
          for (final raw in segStops) {
            final Map<String, dynamic> s = (raw as Map).cast<String, dynamic>();
            final String? code = s['iataCode'] as String?;
            final String? d = s['duration'] as String?;
            if (code != null) stopAirports.add(code);
            if (d != null && d.isNotEmpty) {
              totalLayoverMin += _parseIsoDurMin(d);
            }
          }

          if (j < segments.length - 1) {
            final Map<String, dynamic> thisArr = (seg['arrival'] as Map)
                .cast<String, dynamic>();
            final Map<String, dynamic> nextDep =
                (segments[j + 1]['departure'] as Map).cast<String, dynamic>();

            final DateTime thisArrAt = DateTime.parse(thisArr['at'] as String);
            final DateTime nextDepAt = DateTime.parse(nextDep['at'] as String);
            final int gapMin = nextDepAt.difference(thisArrAt).inMinutes;
            if (gapMin > 0) totalLayoverMin += gapMin;

            final String? connCode = thisArr['iataCode'] as String?;
            if (connCode != null) stopAirports.add(connCode);

            connections.add(<String, dynamic>{
              'airport': connCode,
              'durationMin': gapMin.clamp(0, 1 << 31),
              'duration': _fmtHM(gapMin),
              'arrAt': thisArr['at'],
              'depAt': nextDep['at'],
              'terminalArr': thisArr['terminal'],
              'terminalDep': nextDep['terminal'],
            });
          }
        }

        final String? depAirport = depObj['iataCode'] as String?;
        final String? arrAirport = arrObj['iataCode'] as String?;
        if (depAirport == null || arrAirport == null) continue;

        final String airportPath = stopAirports.isNotEmpty
            ? '$depAirport → ${stopAirports.join(" → ")} → $arrAirport'
            : '$depAirport → $arrAirport';

        final int stopCount = stopAirports.length;
        final String stopLabel = stopCount == 0
            ? 'nonstop'
            : '$stopCount ${stopCount == 1 ? "stop" : "stops"}';

        final String durationStr = itinerary['duration'] as String;
        final int durationMin = _parseIsoDurMin(durationStr);
        final int airMin = (durationMin - totalLayoverMin)
            .clamp(0, 1 << 31)
            .toInt();

        // ✈️ Build full per-stop (per segment) details
        final List<Map<String, dynamic>> segmentDetails = segments.map((
          Map<String, dynamic> s,
        ) {
          final Map<String, dynamic> dep = (s['departure'] as Map)
              .cast<String, dynamic>();
          final Map<String, dynamic> arr = (s['arrival'] as Map)
              .cast<String, dynamic>();
          final String segId = (s['id'] ?? '').toString();
          final String? aircraftCode =
              (s['aircraft'] as Map?)?['code'] as String?;
          final String? operating =
              (s['operating'] as Map?)?['carrierCode'] as String?;

          return <String, dynamic>{
            'segId': segId,
            'marketingCarrier': s['carrierCode'],
            'operatingCarrier': operating, // may be same or codeshare
            'flightNumber': s['number'],
            'marketingFlight': '${s['carrierCode']} ${s['number']}',
            'aircraftCode': aircraftCode,
            'aircraftName': aircraftCode != null
                ? aircraftDict[aircraftCode]
                : null,
            'duration': s['duration'],
            'dep': <String, dynamic>{
              'code': dep['iataCode'],
              'terminal': dep['terminal'],
              'at': dep['at'],
            },
            'arr': <String, dynamic>{
              'code': arr['iataCode'],
              'terminal': arr['terminal'],
              'at': arr['at'],
            },
            // 🧳 Fare details joined by segmentId (from travelerPricings)
            'cabin': segCabin[segId],
            'bookingClass': segBookingClass[segId],
            'includedCheckedBags':
                segCheckedBags[segId], // may be {quantity:1} or {weight: 23, weightUnit:'KG'}
            'includedCabinBags':
                segCabinBags[segId], // may be {quantity:1} etc.
          };
        }).toList();

        // For display like "MF 878 / MF 849"
        final String flightNumbers = segments
            .map(
              (Map<String, dynamic> s) => '${s['carrierCode']} ${s['number']}',
            )
            .join(' / ');

        //pricing mode
        final String pricingMode = PricingMode.combined == mode
            ? 'combined'
            : 'perleg';

        results.add(<String, dynamic>{
          // summary
          'depAirport': depAirport,
          'arrAirport': arrAirport,
          'depTime': depTime,
          'arrTime': arrTime,
          'plusDay': plusDay,
          'airportPath': airportPath,

          // durations
          'durationMin': durationMin,
          'duration': _fmtHM(durationMin),
          'airMin': airMin,
          'air': _fmtHM(airMin),

          // layovers
          'layoverMin': totalLayoverMin,
          'layover': _fmtHM(totalLayoverMin),
          'stops': stopLabel,
          'stopAirports': stopAirports,
          'connections':
              connections, // 🆕 each layover with times/terminal/duration
          // airline labels
          'airline': primaryMarketingName,
          'primaryAirlineCode': primaryMarketingCode,
          'primaryMarketNumber': primaryMarketNumber,
          'flightNumbers': flightNumbers,

          // filtering
          'airlines': marketingNames,
          'airlineCodes': marketingCodes,

          // ticketing
          'ticketingCarrierCode': validatingCode,
          'ticketingCarrierName': validatingName,

          // price/meta
          'price': formattedPrice,
          'currency': currency,
          'isReturn': i == 1,
          'depRaw': depRaw,
          'arrRaw': arrRaw,
          'locations': locations,
          'carriersCode': carriers,
          'passengerCount': travelerPricings.length,

          // per-stop segment details (FULL)
          'segments': segmentDetails, // 🆕 list with dep/arr for EACH stop/leg
          // overall cabin for card (first segment’s cabin)
          'cabinClass': segCabin[(segments.first['id'] ?? '').toString()],
          'pricingMode': pricingMode,
          'isInBoundFlight': isInBoundFlight,
        });
      }
    }

    return results;
  }

  String formatTime(String iso) {
    final DateTime dt = DateTime.parse(iso).toLocal();
    final int hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final String minute = dt.minute.toString().padLeft(2, '0');
    final String suffix = dt.hour < 12 ? 'a' : 'p';
    return '$hour:$minute$suffix';
  }

  String formatDuration(String isoDuration) {
    final RegExp regex = RegExp(r'PT(?:(\d+)H)?(?:(\d+)M)?');
    final RegExpMatch? match = regex.firstMatch(isoDuration);
    if (match != null) {
      final int hours = int.tryParse(match.group(1) ?? '0') ?? 0;
      final int minutes = int.tryParse(match.group(2) ?? '0') ?? 0;
      return '${hours}h ${minutes}m';
    }
    return '';
  }

  Future<void> initRecentSearch(RecentSearch search) async {
    final List<RecentSearch> updated = <RecentSearch>[
      search,
      ...state.recentSearches,
    ];
    if (updated.length > 5) updated.removeLast();
    state = state.copyWithRecentSearches(updated);
  }

  Future<bool> addRecentSearch(RecentSearch search, String jwtToken) async {
    // ✅ Always update state, even for empty ones (to preserve visual 5-item layout)
    final List<RecentSearch> updated = <RecentSearch>[
      search,
      ...state.recentSearches,
    ];
    if (updated.length > 5) updated.removeLast();
    state = state.copyWithRecentSearches(updated);

    // ❌ Only send to backend if not placeholder
    if (search.destination.trim().isEmpty ||
        search.tripDateRange.trim().isEmpty ||
        search.destinationCode.trim().isEmpty ||
        search.guests == 0) {
      debugPrint("⚠️ Skipped sending empty search to backend");
      return false;
    }

    // ✅ Send only valid searches
    return await RecentSearchApiService.sendRecentSearch(
      destination: search.destination,
      tripDateRange: search.tripDateRange,
      destinationCode: search.destinationCode,
      guests: search.guests,
      rooms: search.rooms,
      kind: search.kind,
      departCode: search.departCode,
      arrivalCode: search.arrivalCode,
      departDate: search.departDate,
      returnDate: search.returnDate,
      jwtToken: jwtToken,
    );
  }

  void setClearReturnDate(bool b) {
    state = state.copyWith(clearReturnDate: b);
  }

  void setDepartDate(DateTime? d) {
    if (d == null) {
      state = state.copyWith(departDate: null);
      return;
    }
    final String formatted = DateFormat('yyyy-MM-dd').format(d);
    state = state.copyWith(departDate: formatted);
  }

  void setReturnDate(DateTime? d) {
    if (d == null) {
      state = state.copyWith(returnDate: null);
      return;
    }
    final String formatted = DateFormat('yyyy-MM-dd').format(d);
    state = state.copyWith(returnDate: formatted);
  }

  void setDepartureCity(String city) {
    state = state.copyWith(departureCity: city);
  }

  void setArrivalCity(String city) {
    state = state.copyWith(arrivalCity: city);
  }

  void setDepartureCode(String code) {
    state = state.copyWith(departureAirportCode: code);
  }

  void clearProcessedFlights() {
    debugPrint("🔴 clear processed flights");
    state = state.copyWith(processedFlights: <Map<String, dynamic>>[]);
  }
  // void setDepartureName(String name) {
  //   state = state.copyWith(departureAirportName: name);
  // }

  void setArrivalCode(String code) {
    state = state.copyWith(arrivalAirportCode: code);
  }

  // void setArrivalName(String name) {
  //   state = state.copyWith(arrivalAirportName: name);
  // }

  void setDisplayDate({required DateTime? startDate, DateTime? endDate}) {
    final String displayDate = endDate != null
        ? '${DateFormat('MMM d').format(startDate!)} - ${DateFormat('MMM d').format(endDate)}'
        : DateFormat('MMM d').format(startDate!);
    state = state.copyWith(displayDate: displayDate);
  }

  void setPassengers({required int count, required int cabinIndex}) {
    String cabin;
    switch (cabinIndex) {
      case 0:
        cabin = 'Economy';
        break;
      case 1:
        cabin = 'Premium Economy';
        break;
      case 2:
        cabin = 'Business';
        break;
      case 3:
        cabin = 'First';
        break;
      default:
        cabin = 'Economy';
    }

    state = state.copyWith(passengerCount: count, cabinClass: cabin);
  }

  void clearRecentSearches() {
    state = state.copyWithRecentSearches(<RecentSearch>[]);
  }

  String _fmt(DateTime d) => DateFormat('yyyy-MM-dd').format(d);
  DateTime _dOnly(DateTime d) => DateTime(d.year, d.month, d.day);
  // Header date: Tuesday, August 19
  String _formatHeaderDate(DateTime d) {
    return DateFormat('MMM d').format(d);
  }

  Future<void> loadRecentSearches() async {
    try {
      final List<Map<String, dynamic>> results =
          await RecentSearchApiService.fetchRecentSearches('flight');

      state = state.copyWithRecentSearches(<RecentSearch>[]);

      final DateTime today = _dOnly(DateTime.now());

      for (final Map<String, dynamic> r in results) {
        // guests
        final gv = r['guests'];
        final int guests = gv is int ? gv : int.tryParse(gv.toString()) ?? 1;

        // parse strings
        final String? depStr = r['depart_date']?.toString();
        final String? retStr = r['return_date']?.toString();

        debugPrint('📅 departure date : $depStr, return date : $retStr');
        debugPrint('📅 today : ${_fmt(DateTime.now())}');

        // parse DateTimes
        final DateTime? stDt = depStr != null
            ? DateTime.tryParse(depStr)
            : null;
        final DateTime? edDt = retStr != null
            ? DateTime.tryParse(retStr)
            : null;

        // outputs (non-null strings)
        String departureDate;
        String returnDate;
        String tripDateRange = r['trip_date_range'];

        if (stDt != null) {
          final DateTime start = _dOnly(stDt.toLocal());

          if (start.isBefore(today)) {
            // 🟢 FIX: shift trip forward keeping same length
            final DateTime newStart = today.add(const Duration(days: 2));
            departureDate = _fmt(newStart);
            tripDateRange = _formatHeaderDate(newStart);

            if (edDt != null) {
              final DateTime end = _dOnly(edDt.toLocal());
              int days = end.difference(start).inDays; // exclusive diff
              if (days < 0) days = 0; // 🟢 FIX: guard bad data
              final DateTime newEnd = newStart.add(Duration(days: days));
              returnDate = _fmt(newEnd);
              tripDateRange += (' - ' + _formatHeaderDate(newEnd));
            } else {
              returnDate = ''; // one-way
            }
          } else {
            departureDate = depStr!;
            returnDate = retStr ?? '';
          }
        } else {
          final DateTime newStart = today.add(const Duration(days: 2));
          departureDate = _fmt(newStart);
          returnDate = '';
        }

        initRecentSearch(
          RecentSearch(
            destination: r['destination'],
            tripDateRange: tripDateRange,
            icons: <Widget>[
              const SizedBox(width: 10),
              Icon(Icons.person, color: Colors.grey[500], size: 20.0),
              Text(guests.toString()),
            ],
            destinationCode: r['destination_code'],
            guests: guests,
            rooms: 0,
            kind: 'flight',
            departCode: r['depart_code'],
            arrivalCode: r['arrival_code'],
            departDate: departureDate, // 🟢 no '!' needed
            returnDate: returnDate, // 🟢 no '!' needed
          ),
        );
      }

      debugPrint("✅ Fetched into state: ${results.length} items");
    } catch (e, st) {
      debugPrint("❌ Failed loading recent searches: $e\n$st");
    }
  }

  void bumpSearchNonce() {
    final before = state.searchNonce;
    state = state.copyWith(searchNonce: before + 1); // 🟢 must assign new state
    debugPrint('🔔 nonce ${before} -> ${state.searchNonce}');
  }

  String? get departDate => state.departDate;
  String? get returnDate => state.returnDate;
}

final StateNotifierProvider<FlightSearchController, FlightSearchState>
flightSearchProvider =
    StateNotifierProvider<FlightSearchController, FlightSearchState>(
      (
        StateNotifierProviderRef<FlightSearchController, FlightSearchState> ref,
      ) => FlightSearchController(ref),
    );
