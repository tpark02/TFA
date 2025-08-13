import 'package:TFA/providers/recent_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'flight_search_state.dart';
import 'package:TFA/services/recent_search_service.dart';
import 'package:TFA/services/flight_api_service.dart';
import 'package:TFA/types/typedefs.dart';

class FlightSearchController extends StateNotifier<FlightSearchState> {
  FlightSearchController() : super(FlightSearchState());

  int _parseIsoDurMin(String s) {
    final m = RegExp(r'P(?:(\d+)D)?T(?:(\d+)H)?(?:(\d+)M)?').firstMatch(s);
    final d = int.tryParse(m?.group(1) ?? '0') ?? 0;
    final h = int.tryParse(m?.group(2) ?? '0') ?? 0;
    final mins = int.tryParse(m?.group(3) ?? '0') ?? 0;
    return d * 1440 + h * 60 + mins;
  }

  String _fmtHM(int mins) {
    final h = mins ~/ 60;
    final m = mins % 60;
    return '${h}h ${m}m';
  }

  Future<FlightSearchResult> searchFlights({
    required String origin,
    required String destination,
    required String departureDate,
    required String? returnDate,
    required int adults,
    int maxResults = 20,
  }) async {
    state = state.copyWithFlightResults(const AsyncValue.loading());

    debugPrint("depart date : $departureDate");
    debugPrint("return date : $returnDate");

    try {
      final result = await FlightApiService.fetchFlights(
        origin: origin,
        destination: destination,
        departureDate: departureDate,
        returnDate: returnDate,
        adults: adults,
        maxResults: maxResults,
      );

      // ✅ Process flights before updating state
      final processed = processFlights(result);

      state = state.copyWithFlightResults(AsyncValue.data(result));
      state = state.copyWithProcessedFlights(processed);

      return (true, '✅ Flight search completed');
    } catch (e, st) {
      state = state.copyWithFlightResults(AsyncValue.error(e, st));
      return (false, '❌ Flight search failed: $e');
    }
  }

  String _codeToName(String code, Map<String, dynamic> carriers) {
    final up = code.toUpperCase();
    if (up == 'HR') return 'HAHN AIR';
    if (up == 'H1') return 'HAHN AIR SYSTEMS';
    return (carriers[up] as String?) ?? up; // fallback to code
  }

  // ✅ Add full per-stop details (dep/arr time/code/terminal, flight no, aircraft, cabin, booking class, bags)
  // ✅ Also add connection (layover) details between segments

  List<Map<String, dynamic>> processFlights(
    Map<String, dynamic> latestFlights,
  ) {
    final results = <Map<String, dynamic>>[];

    final data = (latestFlights['data'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();
    final dictionaries =
        (latestFlights['dictionaries'] as Map<String, dynamic>? ?? {});
    final carriers = ((dictionaries['carriers'] as Map<String, dynamic>? ?? {}))
        .map(
          (k, v) =>
              MapEntry(k.toString().toUpperCase(), v.toString().toUpperCase()),
        );
    final locations =
        (dictionaries['locations'] as Map<String, dynamic>? ?? const {})
            .cast<String, dynamic>();
    final aircraftDict =
        (dictionaries['aircraft'] as Map<String, dynamic>? ?? const {})
            .cast<String, String>();

    for (final offer in data) {
      if (offer.isEmpty) continue;

      final itineraries = (offer['itineraries'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>();
      if (itineraries.isEmpty) continue;

      final validatingList =
          ((offer['validatingAirlineCodes'] as List<dynamic>? ?? []))
              .map((e) => e.toString().toUpperCase())
              .toList();
      final validatingCode = validatingList.isNotEmpty
          ? validatingList.first
          : null;
      final validatingName = validatingCode != null
          ? _codeToName(validatingCode, carriers)
          : null;

      final priceMap = (offer['price'] as Map<String, dynamic>? ?? const {});
      final price = priceMap['grandTotal'];
      final currency = (priceMap['currency'] ?? 'EUR').toString();
      final formattedPrice = NumberFormat.simpleCurrency(
        name: currency,
      ).format(double.tryParse(price.toString()) ?? 0);

      // 🔎 traveler/cabin details (used per segment)
      final travelerPricings =
          (offer['travelerPricings'] as List<dynamic>? ?? [])
              .cast<Map<String, dynamic>>();
      if (travelerPricings.isEmpty) continue;

      // we use first traveler as representative (common pattern)
      final firstTraveler = travelerPricings.first;
      final fareDetailsBySegment =
          (firstTraveler['fareDetailsBySegment'] as List<dynamic>? ?? [])
              .cast<Map<String, dynamic>>();

      // 🟢 Build quick lookups by segmentId -> cabin / bookingClass / bags
      final segCabin = <String, String?>{};
      final segBookingClass = <String, String?>{};
      final segCheckedBags = <String, dynamic>{};
      final segCabinBags = <String, dynamic>{};
      for (final fd in fareDetailsBySegment) {
        final id = (fd['segmentId'] ?? '').toString();
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
        final itinerary = itineraries[i];
        final segments = (itinerary['segments'] as List<dynamic>? ?? [])
            .cast<Map<String, dynamic>>();
        if (segments.isEmpty) continue;

        // Primary marketing
        final primaryMarketingCode = (segments.first['carrierCode'] as String)
            .toUpperCase();
        final primaryMarketNumber = (segments.first['number'] as String);
        final primaryMarketingName = _codeToName(
          primaryMarketingCode,
          carriers,
        );

        final marketingCodes = <String>{
          for (final s in segments) (s['carrierCode'] as String).toUpperCase(),
        }..removeWhere((c) => c == 'HR' || c == 'H1');
        final marketingNames = marketingCodes
            .map((c) => _codeToName(c, carriers))
            .toSet();

        // Times / day shift
        final firstSegment = segments.first;
        final lastSegment = segments.last;

        final depObj = (firstSegment['departure'] as Map);
        final arrObj = (lastSegment['arrival'] as Map);
        final depRaw = depObj['at'] as String?;
        final arrRaw = arrObj['at'] as String?;
        if (depRaw == null || arrRaw == null) continue;

        final depTime = formatTime(depRaw);
        final arrTime = formatTime(arrRaw);
        final dayDiff = DateTime.parse(
          arrRaw,
        ).difference(DateTime.parse(depRaw)).inDays;
        final plusDay = dayDiff > 0 ? '+$dayDiff' : '';

        // 🧭 Per-connection layovers + total
        final stopAirports = <String>[];
        int totalLayoverMin = 0;
        final connections =
            <Map<String, dynamic>>[]; // each layover between segments

        for (int j = 0; j < segments.length; j++) {
          final seg = segments[j];

          // intra-segment tech stops (rare)
          final segStops = (seg['stops'] as List<dynamic>? ?? const []);
          for (final raw in segStops) {
            final s = (raw as Map).cast<String, dynamic>();
            final code = s['iataCode'] as String?;
            final d = s['duration'] as String?;
            if (code != null) stopAirports.add(code);
            if (d != null && d.isNotEmpty)
              totalLayoverMin += _parseIsoDurMin(d);
          }

          if (j < segments.length - 1) {
            final thisArr = (seg['arrival'] as Map).cast<String, dynamic>();
            final nextDep = (segments[j + 1]['departure'] as Map)
                .cast<String, dynamic>();

            final thisArrAt = DateTime.parse(thisArr['at'] as String);
            final nextDepAt = DateTime.parse(nextDep['at'] as String);
            final gapMin = nextDepAt.difference(thisArrAt).inMinutes;
            if (gapMin > 0) totalLayoverMin += gapMin;

            final connCode = thisArr['iataCode'] as String?;
            if (connCode != null) stopAirports.add(connCode);

            connections.add({
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

        final depAirport = depObj['iataCode'] as String?;
        final arrAirport = arrObj['iataCode'] as String?;
        if (depAirport == null || arrAirport == null) continue;

        final airportPath = stopAirports.isNotEmpty
            ? '$depAirport → ${stopAirports.join(" → ")} → $arrAirport'
            : '$depAirport → $arrAirport';

        final stopCount = stopAirports.length;
        final stopLabel = stopCount == 0
            ? 'nonstop'
            : '$stopCount ${stopCount == 1 ? "stop" : "stops"}';

        final durationStr = itinerary['duration'] as String;
        final durationMin = _parseIsoDurMin(durationStr);
        final airMin = (durationMin - totalLayoverMin)
            .clamp(0, 1 << 31)
            .toInt();

        // ✈️ Build full per-stop (per segment) details
        final segmentDetails = segments.map((s) {
          final dep = (s['departure'] as Map).cast<String, dynamic>();
          final arr = (s['arrival'] as Map).cast<String, dynamic>();
          final segId = (s['id'] ?? '').toString();
          final aircraftCode = (s['aircraft'] as Map?)?['code'] as String?;
          final operating = (s['operating'] as Map?)?['carrierCode'] as String?;

          return {
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
            'dep': {
              'code': dep['iataCode'],
              'terminal': dep['terminal'],
              'at': dep['at'],
            },
            'arr': {
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
        final flightNumbers = segments
            .map((s) => '${s['carrierCode']} ${s['number']}')
            .join(' / ');

        results.add({
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
        });
      }
    }

    return results;
  }

  String formatTime(String iso) {
    final dt = DateTime.parse(iso).toLocal();
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final suffix = dt.hour < 12 ? 'a' : 'p';
    return '$hour:$minute$suffix';
  }

  String formatDuration(String isoDuration) {
    final regex = RegExp(r'PT(?:(\d+)H)?(?:(\d+)M)?');
    final match = regex.firstMatch(isoDuration);
    if (match != null) {
      final hours = int.tryParse(match.group(1) ?? '0') ?? 0;
      final minutes = int.tryParse(match.group(2) ?? '0') ?? 0;
      return '${hours}h ${minutes}m';
    }
    return '';
  }

  Future<void> initRecentSearch(RecentSearch search) async {
    final updated = [search, ...state.recentSearches];
    if (updated.length > 5) updated.removeLast();
    state = state.copyWithRecentSearches(updated);
  }

  Future<bool> addRecentSearch(RecentSearch search, String jwtToken) async {
    // ✅ Always update state, even for empty ones (to preserve visual 5-item layout)
    final updated = [search, ...state.recentSearches];
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
    final displayDate = endDate != null
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
    state = state.copyWithRecentSearches([]);
  }

  Future<void> loadRecentSearchesFromApi() async {
    try {
      final results = await RecentSearchApiService.fetchRecentSearches(
        'flight',
      );
      state = state.copyWithRecentSearches([]);

      for (final r in results) {
        final guestsValue = r['guests'];
        final guests = guestsValue is int
            ? guestsValue
            : int.tryParse(guestsValue.toString()) ?? 1;

        initRecentSearch(
          RecentSearch(
            destination: r['destination'],
            tripDateRange: r['trip_date_range'],
            icons: [
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
            departDate: r['depart_date'],
            returnDate: r['return_date'],
          ),
        );
      }

      debugPrint("✅ Fetched into state: $results");
    } catch (e) {
      debugPrint("❌ Failed loading recent searches: $e");
    }
  }

  String? get departDate => state.departDate;
  String? get returnDate => state.returnDate;
}

final flightSearchProvider =
    StateNotifierProvider<FlightSearchController, FlightSearchState>(
      (ref) => FlightSearchController(),
    );
