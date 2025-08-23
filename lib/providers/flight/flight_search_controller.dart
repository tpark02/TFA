import 'package:TFA/models/flight_search_int.dart';
import 'package:TFA/models/flight_search_out.dart';
import 'package:TFA/providers/iata_country_provider.dart';
import 'package:TFA/providers/recent_search.dart';
import 'package:TFA/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'flight_search_state.dart';
import 'package:TFA/services/recent_search_service.dart';
import 'package:TFA/services/flight_service.dart';
import 'package:TFA/types/typedefs.dart';

class FlightSearchController extends StateNotifier<FlightSearchState> {
  FlightSearchController(this.ref) : super(FlightSearchState());
  final Ref ref;

  Future<FlightSearchResult> searchHiddenFlights({
    required String origin,
    required String destination,
    required String departureDate,
    required String? returnDate,
    required bool isInboundFlight,
    required PricingMode mode,
    required List<String> candidates,
    int adults = 1,
    int children = 0,
    int infants = 0,
    String travelClass = 'ECONOMY',
    // required int searchId,
    int maxResults = 20,
  }) async {
    state = state.copyWith(isLoading: true);
    debugPrint("🫣 search hidden flight");
    debugPrint("1 depart date : $departureDate");
    debugPrint("2 return date : $returnDate");

    try {
      final FlightService api = ref.read(flightApiServiceProvider);

      final FlightSearchIn payload = FlightSearchIn(
        origin: origin,
        exitVia: destination,
        departDate: departureDate,
        adults: adults,
        travelClass: travelClass,
        candidateDests: candidates,
        children: children,
        infants: infants,
      );

      final List<FlightSearchOut> result = await api.fetchHiddenCity(
        payload: payload,
      );

      // if (searchId != state.searchNonce) return (false, 'stale search ignored');

      // Collect all processed flights first
      final List allProcessed = result
          .expand(
            (FlightSearchOut r) => processFlights(
              r,
              mode,
              isInboundFlight,
              isHiddenCityFlight: true,
            ),
          )
          .toList();

      // Then update state once
      state = state.copyWith(
        processedFlights: <Map<String, dynamic>>[
          ...state.processedFlights,
          ...allProcessed,
        ],
      );

      // you can also update state here if you want
      return (
        true,
        "✅ Hidden-city search completed, items added : ${allProcessed.length}",
      );
    } catch (e) {
      // if (searchId != state.searchNonce) return (false, 'stale error ignored');
      debugPrint("❌ Hidden-city search failed: $e");
      return (false, "❌ Hidden-city search failed: $e");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void setSearchNonce(int id) => state = state.copyWith(searchNonce: id);
  void setLoadingAndClear() => state = state.copyWith(
    isLoading: true,
    processedFlights: <Map<String, dynamic>>[],
    // optionally set flightResults = const AsyncLoading()
  );

  Future<FlightSearchResult> searchFlights({
    required String origin,
    required String destination,
    required String departureDate,
    required String? returnDate,
    required bool isInboundFlight,
    required PricingMode mode,
    int adults = 1,
    int children = 0,
    int infants = 0,
    String travelClass = 'ECONOMY',
    int maxResults = 20,
  }) async {
    state = state.copyWith(isLoading: true);
    debugPrint("✈️ search flight");

    debugPrint("1 depart date : $departureDate");
    debugPrint("2 return date : $returnDate");

    try {
      final FlightService api = ref.read(flightApiServiceProvider);

      final FlightSearchOut result = await api.fetchFlights(
        origin: origin,
        destination: destination,
        departureDate: departureDate,
        returnDate: returnDate,
        adults: adults,
        children: children,
        infants: infants,
        travelClass: travelClass,
        maxResults: maxResults,
      );

      // if (searchId != state.searchNonce) return (false, 'stale search ignored');

      final List<Map<String, dynamic>> res = processFlights(
        result,
        mode,
        isInboundFlight,
        isHiddenCityFlight: false,
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
      // if (searchId != state.searchNonce) return (false, 'stale error ignored');

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

  // 🟢 Helpers for an Amadeus flight-offer Map<String, dynamic>
  int totalTravelers(Map<String, dynamic> offer) {
    final List tp =
        offer['travelerPricings'] as List<dynamic>? ?? const <dynamic>[];
    return tp.length;
  }

  int seatOccupyingPax(Map<String, dynamic> offer) {
    final List tp =
        (offer['travelerPricings'] as List<dynamic>? ?? const <dynamic>[]);
    return tp.where((e) => e['travelerType'] != 'HELD_INFANT').length;
  }

  Map<String, int> paxBreakdown(Map<String, dynamic> offer) {
    final List tp =
        (offer['travelerPricings'] as List<dynamic>? ?? const <dynamic>[]);
    int adults = 0, children = 0, heldInfants = 0, seatedInfants = 0;
    for (final e in tp) {
      switch (e['travelerType'] as String) {
        case 'ADULT':
          adults++;
          break;
        case 'CHILD':
          children++;
          break;
        case 'HELD_INFANT':
          heldInfants++;
          break;
        case 'SEATED_INFANT':
          seatedInfants++;
          break;
      }
    }
    return <String, int>{
      'adults': adults,
      'children': children,
      'heldInfants': heldInfants,
      'seatedInfants': seatedInfants,
      'total': tp.length,
      'seatPax': adults + children + seatedInfants, // excludes HELD_INFANT
    };
  }

  List<Map<String, dynamic>> processFlights(
    FlightSearchOut latestFlights,
    PricingMode mode,
    bool isInBoundFlight, {
    required bool isHiddenCityFlight,
  }) {
    final List<Map<String, dynamic>> results = <Map<String, dynamic>>[];

    // Typed access
    final List<FlightOffer> offers = latestFlights.data!;
    final Dictionaries dict = latestFlights.dictionaries!;

    // Normalize carriers dict to UPPERCASE keys for easy lookup
    final Map<String, String> carriers = <String, String>{
      for (final MapEntry<String, String> e in dict.carriers!.entries)
        e.key.toUpperCase(): e.value.toUpperCase(),
    };

    // Useful lookups
    final Map<String, String> aircraftDict = dict.aircraft!;
    final Set<String> departFlightNumbers = <String>{};
    String parentFlightNumber = "";

    for (final FlightOffer offer in offers) {
      final List<Itinerary> itineraries = offer.itineraries ?? <Itinerary>[];
      if (itineraries.isEmpty) continue;
      // Validating airline
      final List<String> validatingCodes =
          (offer.validatingAirlineCodes ?? <String>[])
              .map((String e) => e.toUpperCase())
              .toList();
      final String? validatingCode = validatingCodes.isNotEmpty
          ? validatingCodes.first
          : null;
      final String? validatingName = validatingCode != null
          ? _codeToName(validatingCode, carriers)
          : null;

      // Price
      final Price? price = offer.price;
      final String currency = price?.currency ?? 'EUR';
      final String? totalStr = price?.grandTotal ?? price?.total;
      final String formattedPrice = totalStr == null
          ? NumberFormat.simpleCurrency(name: currency).format(0)
          : NumberFormat.simpleCurrency(
              name: currency,
            ).format(double.tryParse(totalStr) ?? 0);

      // Build segment-level lookups from travelerPricings (first traveler is typical)
      final Map<String, String?> segCabin = <String, String?>{};
      final Map<String, String?> segBookingClass = <String, String?>{};
      final Map<String, dynamic> segCheckedBags = <String, dynamic>{};
      final Map<String, dynamic> segCabinBags = <String, dynamic>{};

      final List<TravelerPricing> tps =
          offer.travelerPricings ?? <TravelerPricing>[];
      if (tps.isNotEmpty) {
        final TravelerPricing tp = tps.first;
        for (final FareDetailsBySegment fd
            in tp.fareDetailsBySegment ?? <FareDetailsBySegment>[]) {
          final String id = (fd.segmentId ?? '').toString();
          if (id.isEmpty) continue;
          segCabin[id] = fd.cabin;
          segBookingClass[id] = fd.class_;
          if (fd.includedCheckedBags != null) {
            segCheckedBags[id] = <String, Object?>{
              'quantity': fd.includedCheckedBags?.quantity,
              'weight': fd.includedCheckedBags?.weight,
              'weightUnit': fd.includedCheckedBags?.weightUnit,
            };
          }
          if (fd.includedCabinBags != null) {
            segCabinBags[id] = <String, Object?>{
              'quantity': fd.includedCabinBags?.quantity,
              'weight': fd.includedCabinBags?.weight,
              'weightUnit': fd.includedCabinBags?.weightUnit,
            };
          }
        }
      }
      // 🟢 FIX: derive passenger counts from travelerPricings (seat vs total + breakdown)
      int paxAdults = 0,
          paxChildren = 0,
          paxHeldInfants = 0,
          paxSeatedInfants = 0;
      for (final TravelerPricing tp in tps) {
        switch ((tp.travelerType ?? '').toUpperCase()) {
          case 'ADULT':
            paxAdults++;
            break;
          case 'CHILD':
            paxChildren++;
            break;
          case 'HELD_INFANT':
            paxHeldInfants++;
            break;
          case 'SEATED_INFANT':
            paxSeatedInfants++;
            break;
        }
      }
      final int passengerSeatCnt =
          paxAdults + paxChildren + paxSeatedInfants; // excludes lap infants
      final int passengerTotalCnt = tps.length; // includes lap infants

      final int passengerCnt = passengerSeatCnt;

      // Iterate itineraries
      for (int i = 0; i < itineraries.length; i++) {
        // Set<String> airlinesCnt = <String>{};

        final Itinerary it = itineraries[i];
        final List<Segment> segments = it.segments ?? <Segment>[];

        if (segments.isEmpty) continue;

        // final String legKey = itineraryKey(segments); // uses all segments
        // if (!seenLegKeys.add(legKey)) continue; // ⬅️ skip duplicates

        String myFlightNumber = "";
        final n = (segments[0].number ?? "");
        final f = segments[0].carrierCode ?? "";

        if (n != "" && f != "") myFlightNumber = f + n;

        if (i == 0) {
          if (departFlightNumbers.contains(myFlightNumber)) continue;
          departFlightNumbers.add(myFlightNumber);
          parentFlightNumber = myFlightNumber;
        }

        // if (!seenLegKeys.add(parentFlightNumber)) continue;

        // Primary marketing info (first segment)
        final Segment firstSeg = segments.first;
        final Segment lastSeg = segments.last;

        final String? depRaw = firstSeg.departure?.at;
        final String? arrRaw = lastSeg.arrival?.at;
        if (depRaw == null || arrRaw == null) continue;

        final String depAirport = firstSeg.departure?.iataCode ?? '';
        final String arrAirport = lastSeg.arrival?.iataCode ?? '';
        if (depAirport.isEmpty || arrAirport.isEmpty) continue;

        final String primaryMarketingCode = (firstSeg.carrierCode ?? '')
            .toUpperCase();
        final String primaryMarketingName = _codeToName(
          primaryMarketingCode,
          carriers,
        );
        final String primaryMarketNumber = firstSeg.number ?? '';

        // Times / day shift
        final String depTime = formatTime(depRaw);
        final String arrTime = formatTime(arrRaw);
        final int dayDiff = DateTime.parse(
          arrRaw,
        ).difference(DateTime.parse(depRaw)).inDays;
        final String plusDay = dayDiff > 0 ? '+$dayDiff' : '';

        // Stops / layovers between segments
        final List<String> stopAirports = <String>[];
        int totalLayoverMin = 0;
        final List<Map<String, dynamic>> connections = <Map<String, dynamic>>[];

        for (int j = 0; j < segments.length - 1; j++) {
          final Segment cur = segments[j];
          final Segment nxt = segments[j + 1];

          final String? curArrAt = cur.arrival?.at;
          final String? nxtDepAt = nxt.departure?.at;
          if (curArrAt != null && nxtDepAt != null) {
            final int gapMin = DateTime.parse(
              nxtDepAt,
            ).difference(DateTime.parse(curArrAt)).inMinutes;
            if (gapMin > 0) totalLayoverMin += gapMin;

            final String? connCode = cur.arrival?.iataCode;
            if (connCode != null && connCode.isNotEmpty) {
              stopAirports.add(connCode);
            }

            connections.add(<String, dynamic>{
              'airport': connCode,
              'durationMin': gapMin < 0 ? 0 : gapMin,
              'duration': fmtHM(gapMin),
              'arrAt': curArrAt,
              'depAt': nxtDepAt,
              'terminalArr': cur.arrival?.terminal,
              'terminalDep': nxt.departure?.terminal,
            });
          }
        }

        final String airportPath = stopAirports.isNotEmpty
            ? '$depAirport → ${stopAirports.join(" → ")} → $arrAirport'
            : '$depAirport → $arrAirport';

        final int stopCount = stopAirports.length;
        final String stopLabel = stopCount == 0
            ? 'nonstop'
            : '$stopCount ${stopCount == 1 ? "stop" : "stops"}';

        // Durations
        final int durationMin = parseIsoDurMin(it.duration);
        final int airMin = (durationMin - totalLayoverMin);
        final String durationFmt = fmtHM(durationMin);
        final String airFmt = fmtHM(airMin);

        // Segment details (typed → map)
        final List<Map<String, dynamic>> segmentDetails = segments.map((
          Segment s,
        ) {
          final String segId = (s.id ?? '').toString();
          final String? acCode = s.aircraft?.code;
          final String? operatingCode = s.operating?.carrierCode;
          final String flightNumber =
              '${s.carrierCode ?? ''} ${s.number ?? ''}';

          // if (s.carrierCode != null) {
          //   debugPrint("✈️ carrier code : ${s.carrierCode}");
          //   airlinesCnt.add(s.carrierCode!);
          // }

          return <String, dynamic>{
            'segId': segId,
            'marketingCarrier': s.carrierCode,
            'operatingCarrier': operatingCode,
            'flightNumber': s.number,
            'marketingFlight': flightNumber,
            'aircraftCode': acCode,
            'aircraftName': acCode != null ? aircraftDict[acCode] : null,
            'duration': s.duration,
            'dep': <String, String?>{
              'code': s.departure?.iataCode,
              'terminal': s.departure?.terminal,
              'at': s.departure?.at,
            },
            'arr': <String, String?>{
              'code': s.arrival?.iataCode,
              'terminal': s.arrival?.terminal,
              'at': s.arrival?.at,
            },
            'cabin': segCabin[segId],
            'bookingClass': segBookingClass[segId],
            'includedCheckedBags': segCheckedBags[segId],
            'includedCabinBags': segCabinBags[segId],
          };
        }).toList();

        // For display like "UA 1665 / UA 2610"
        final String flightNumbers = segments
            .map(
              (Segment s) => '${s.carrierCode ?? ''} ${s.number ?? ''}'.trim(),
            )
            .join(' / ');

        final String pricingMode = mode == PricingMode.combined
            ? 'combined'
            : 'perleg';

        debugPrint("‼️ itinerry len : ${itineraries.length}");
        debugPrint("‼️ $i");
        debugPrint("‼️ my flight number : $myFlightNumber");
        debugPrint("‼️ parent flight number : $parentFlightNumber");
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
          'duration': durationFmt,
          'airMin': airMin < 0 ? 0 : airMin,
          'air': airFmt,

          // layovers
          'layoverMin': totalLayoverMin,
          'layover': fmtHM(totalLayoverMin),
          'stops': stopLabel,
          'stopAirports': stopAirports,
          'connections': connections,

          // airline labels
          'airline': primaryMarketingName,
          'primaryAirlineCode': primaryMarketingCode,
          'primaryMarketNumber': primaryMarketNumber,
          'flightNumbers': flightNumbers,

          // ticketing
          'ticketingCarrierCode': validatingCode,
          'ticketingCarrierName': validatingName,

          // price/meta
          'price': formattedPrice,
          'currency': currency,
          'isReturn': i == 1,
          'depRaw': depRaw,
          'arrRaw': arrRaw,

          // per-stop segment details (FULL)
          'segments': segmentDetails,
          // overall cabin for card (first segment’s cabin)
          'cabinClass': cabinMap[segCabin[(firstSeg.id ?? '').toString()]],
          'pricingMode': pricingMode,
          'isInBoundFlight': isInBoundFlight,
          'isHiddenCityFlight': isHiddenCityFlight,
          "passengerCnt": passengerCnt,
          "passengerTotal": passengerTotalCnt, // optional: includes HELD_INFANT
          "pax": <String, int>{
            "adults": paxAdults,
            "children": paxChildren,
            "infantsHeld": paxHeldInfants,
            "infantsSeated": paxSeatedInfants,
            "seatPax": passengerSeatCnt,
            "total": passengerTotalCnt,
          },
          'parentFlightNumber': parentFlightNumber,
          'myFlightNumber': myFlightNumber,
          // 'isSelfTransfer': airlinesCnt.length > 1 ? true : false,
        });
      }
    }

    return results;
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
        search.passengerCnt == 0) {
      debugPrint("⚠️ Skipped sending empty search to backend");
      return false;
    }

    // ✅ Send only valid searches
    return await RecentSearchApiService.sendRecentSearch(
      destination: search.destination,
      tripDateRange: search.tripDateRange,
      destinationCode: search.destinationCode,
      passengerCnt: search.passengerCnt,
      rooms: search.rooms,
      kind: search.kind,
      departCode: search.departCode,
      arrivalCode: search.arrivalCode,
      departDate: search.departDate,
      returnDate: search.returnDate,
      adult: search.adult,
      children: search.children,
      infantLap: search.infantLap,
      infantSeat: search.infantSeat,
      cabinIdx: search.cabinIdx,
      jwtToken: jwtToken,
    );
  }

  // void setClearReturnDate(bool b) {
  //   state = state.copyWith(clearReturnDate: b);
  // }

  void setTripDates({
    required DateTime departDate, // non-null
    DateTime? returnDate, // nullable for one-way
  }) {
    final DateFormat iso = DateFormat('yyyy-MM-dd');
    final DateFormat pretty = DateFormat('MMM d');

    final String dIso = iso.format(departDate);
    final String? rIso = (returnDate == null) ? null : iso.format(returnDate);

    final String display = (returnDate != null)
        ? '${pretty.format(departDate)} - ${pretty.format(returnDate)}'
        : pretty.format(departDate);

    if (state.departDate == dIso &&
        state.returnDate == rIso &&
        state.displayDate == display) {
      return;
    }

    state = state.copyWith(
      departDate: dIso,
      returnDate: rIso,
      displayDate: display,
      clearReturnDate: returnDate == null ? true : false,
    );
  }
  // void setDepartDate(DateTime? d) {
  // if (d == null) {
  //   state = state.copyWith(departDate: null);
  //   return;
  // }
  //   final String formatted = DateFormat('yyyy-MM-dd').format(d);
  //   state = state.copyWith(departDate: formatted);
  // }

  // void setReturnDate(DateTime? d) {
  // if (d == null) {
  //   state = state.copyWith(returnDate: null);
  //   return;
  // }
  //   final String formatted = DateFormat('yyyy-MM-dd').format(d);
  //   state = state.copyWith(returnDate: formatted);
  // }

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

  void clearHiddenAiportCodeList() {
    debugPrint("🔴 clear hidden airport code list flights");
    state = state.copyWith(hiddenAirporCodeList: <String>[]);
  }

  void setHiddenAirporCodeList(List<String> lst) {
    state = state.copyWith(hiddenAirporCodeList: lst);
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

  void setSearchConfirmed(bool b) {
    state = state.copyWith(isSearchConfirmed: b);
  }

  // void setHasReturnFlight(bool b) {
  //   state = state.copyWith(hasReturnFlight: b);
  // }

  void setPassengers({
    required int count,
    required int cabinIndex,
    required int adult,
    required int children,
    required int infantLap,
    required int infantSeat,
  }) {
    final String cabin = getCabinClassByIdx(cabinIndex: cabinIndex);
    state = state.copyWith(
      passengerCount: count,
      cabinClass: cabin,
      adultCnt: adult,
      childrenCnt: children,
      infantLapCnt: infantLap,
      infantSeatCnt: infantSeat,
      cabinIdx: cabinIndex,
    );
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
        // passenger cnt
        final int passengerCnt = r['passenger_cnt'] as int;
        final int adult = r['adult'] as int;
        final int children = r['children'] as int;
        final int infantLap = r['infant_lap'] as int;
        final int infantSeat = r['infant_seat'] as int;

        // cabin idx
        final int cabinIdx = r['cabin_idx'] as int;

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
              tripDateRange += (' - ${_formatHeaderDate(newEnd)}');
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
              Text(passengerCnt.toString()),
            ],
            destinationCode: r['destination_code'],
            passengerCnt: passengerCnt,
            rooms: 0,
            kind: 'flight',
            departCode: r['depart_code'],
            arrivalCode: r['arrival_code'],
            departDate: departureDate,
            returnDate: returnDate,
            adult: adult,
            children: children,
            infantLap: infantLap,
            infantSeat: infantSeat,
            cabinIdx: cabinIdx,
          ),
        );
      }

      debugPrint("✅ Fetched into state: ${results.length} items");
    } catch (e, st) {
      debugPrint("❌ Failed loading recent searches: $e\n$st");
    }
  }

  // void bumpSearchNonce() {
  //   final int before = state.searchNonce;
  //   state = state.copyWith(searchNonce: before + 1); // 🟢 must assign new state
  //   debugPrint('🔔 nonce $before -> ${state.searchNonce}');
  // }

  List<Future<(bool, String)> Function()> executeFlightSearch({
    required bool hasReturn,
  }) {
    clearProcessedFlights();

    if (hasReturn) {
      debugPrint("✈️ Round Trip");
      return <Future<(bool, String)> Function()>[
        () => searchFlights(
          origin: state.departureAirportCode,
          destination: state.arrivalAirportCode,
          departureDate: state.departDate,
          returnDate: state.returnDate,
          isInboundFlight: false,
          mode: PricingMode.combined,
          adults: state.adultCnt,
          children: state.childrenCnt,
          infants: state.infantLapCnt + state.infantSeatCnt,
          travelClass: getTravelClassByIdx(cabinIndex: state.cabinIdx),
        ),
        () => searchFlights(
          origin: state.departureAirportCode,
          destination: state.arrivalAirportCode,
          departureDate: state.departDate,
          returnDate: null,
          adults: state.passengerCount,
          isInboundFlight: false,
          mode: PricingMode.perLeg,
          children: state.childrenCnt,
          infants: state.infantLapCnt + state.infantSeatCnt,
          travelClass: getTravelClassByIdx(cabinIndex: state.cabinIdx),
        ),
        () => searchFlights(
          origin: state.arrivalAirportCode,
          destination: state.departureAirportCode,
          departureDate: state.returnDate!,
          returnDate: null,
          isInboundFlight: true,
          mode: PricingMode.perLeg,
          adults: state.adultCnt,
          children: state.childrenCnt,
          infants: state.infantLapCnt + state.infantSeatCnt,
          travelClass: getTravelClassByIdx(cabinIndex: state.cabinIdx),
        ),

        // () => searchHiddenFlights(
        //   origin: state.departureAirportCode,
        //   destination: state.arrivalAirportCode,
        //   departureDate: state.departDate,
        //   returnDate: null,
        //   isInboundFlight: false,
        //   mode: PricingMode.perLeg,
        //   candidates: state.hiddenAirporCodeList,
        //   adults: state.adultCnt,
        //   children: state.childrenCnt,
        //   infants: state.infantLapCnt + state.infantSeatCnt,
        //   travelClass: getTravelClassByIdx(cabinIndex: state.cabinIdx),
        // ),
        // () => searchHiddenFlights(
        //   origin: state.arrivalAirportCode,
        //   destination: state.departureAirportCode,
        //   departureDate: state.returnDate!,
        //   returnDate: null,
        //   isInboundFlight: true,
        //   mode: PricingMode.perLeg,
        //   candidates: state.hiddenAirporCodeList,
        //   adults: state.adultCnt,
        //   children: state.childrenCnt,
        //   infants: state.infantLapCnt + state.infantSeatCnt,
        //   travelClass: getTravelClassByIdx(cabinIndex: state.cabinIdx),
      ];
    } else {
      debugPrint("✈️ One-way");

      return <Future<(bool, String)> Function()>[
        () => searchFlights(
          origin: state.departureAirportCode,
          destination: state.arrivalAirportCode,
          departureDate: state.departDate,
          returnDate: null,
          isInboundFlight: false,
          mode: PricingMode.perLeg,
          adults: state.adultCnt,
          children: state.childrenCnt,
          infants: state.infantLapCnt + state.infantSeatCnt,
          travelClass: getTravelClassByIdx(cabinIndex: state.cabinIdx),
        ),
        // () => searchHiddenFlights(
        //   origin: state.departureAirportCode,
        //   destination: state.arrivalAirportCode,
        //   departureDate: state.departDate,
        //   returnDate: null,
        //   isInboundFlight: false,
        //   mode: PricingMode.perLeg,
        //   candidates: state.hiddenAirporCodeList,
        //   adults: state.adultCnt,
        //   children: state.childrenCnt,
        //   infants: state.infantLapCnt + state.infantSeatCnt,
        //   travelClass: getTravelClassByIdx(cabinIndex: state.cabinIdx),
        // ),
      ];
    }
  }

  int get cabinIdx => state.cabinIdx;
  int get adultCnt => state.adultCnt;
  int get childrenCnt => state.childrenCnt;
  int get infantLapCnt => state.infantLapCnt;
  int get infantSeatCnt => state.infantSeatCnt;

  String? get departDate => state.departDate;
  String? get returnDate => state.returnDate;
  List<String> get hiddenCandidates => state.hiddenAirporCodeList;

  void setOneWayDate(DateTime departDate) =>
      setTripDates(departDate: departDate, returnDate: null);

  void setRoundTripDates(DateTime departDate, DateTime returnDate) =>
      setTripDates(departDate: departDate, returnDate: returnDate);
}

final StateNotifierProvider<FlightSearchController, FlightSearchState>
flightSearchProvider =
    StateNotifierProvider<FlightSearchController, FlightSearchState>(
      (
        StateNotifierProviderRef<FlightSearchController, FlightSearchState> ref,
      ) => FlightSearchController(ref),
    );
