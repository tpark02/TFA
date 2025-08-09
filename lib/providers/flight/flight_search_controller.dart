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

  List<Map<String, dynamic>> processFlights(
    Map<String, dynamic> latestFlights,
  ) {
    final results = <Map<String, dynamic>>[];

    final data = latestFlights['data'] as List<dynamic>? ?? [];
    final dictionaries =
        latestFlights['dictionaries'] as Map<String, dynamic>? ?? {};
    final carriers = dictionaries['carriers'] as Map<String, dynamic>? ?? {};

    for (final offer in data) {
      if (offer == null) continue;

      final itineraries = offer['itineraries'] as List;

      final airlineCodes = offer['validatingAirlineCodes'] as List;
      final airline = carriers[airlineCodes.first] ?? airlineCodes.first;

      final price = offer['price']['grandTotal'];
      final currency = offer['price']['currency'];
      final formattedPrice = NumberFormat.currency(
        locale: 'ko_KR',
        symbol: '₩',
        decimalDigits: 0,
      ).format(double.tryParse(price) ?? 0);

      for (int i = 0; i < itineraries.length; i++) {
        final itinerary = itineraries[i];
        final segments = itinerary['segments'] as List;

        final firstSegment = segments.first;
        final lastSegment = segments.last;

        final depRaw = firstSegment['departure']['at'];
        final arrRaw = lastSegment['arrival']['at'];
        final depTime = formatTime(depRaw);
        final arrTime = formatTime(arrRaw);
        final dayDiff = DateTime.parse(
          arrRaw,
        ).difference(DateTime.parse(depRaw)).inDays;
        final plusDay = dayDiff > 0 ? '+$dayDiff' : '';

        final stops = <String>[];
        for (int j = 0; j < segments.length - 1; j++) {
          stops.add(segments[j]['arrival']['iataCode']);
        }

        final depAirport = firstSegment['departure']['iataCode'];
        final arrAirport = lastSegment['arrival']['iataCode'];
        final airportPath = stops.isNotEmpty
            ? '$depAirport → ${stops.join(" → ")} → $arrAirport'
            : '$depAirport →  $arrAirport';

        final durationStr = itinerary['duration'] as String;
        final match = RegExp(
          r'PT(?:(\d+)H)?(?:(\d+)M)?',
        ).firstMatch(durationStr);
        int h = 0, m = 0;
        if (match != null) {
          h = int.tryParse(match.group(1) ?? '0') ?? 0;
          m = int.tryParse(match.group(2) ?? '0') ?? 0;
        }

        final stopCount = stops.length;
        final stopLabel = '$stopCount ${stopCount == 1 ? "stop" : "stops"}';

        results.add({
          'depAirport': depAirport,
          'arrAirport': arrAirport,
          'depTime': depTime,
          'arrTime': arrTime,
          'plusDay': plusDay,
          'airportPath': airportPath,
          'duration': '${h}h ${m}m',
          'stops': stopLabel,
          'airline': airline,
          'price': formattedPrice,
          'currency': currency,
          'isReturn': i == 1, // ✅ flag: false = outbound, true = return
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

  void setDepartureName(String name) {
    state = state.copyWith(departureAirportName: name);
  }

  void setArrivalCode(String code) {
    state = state.copyWith(arrivalAirportCode: code);
  }

  void setArrivalName(String name) {
    state = state.copyWith(arrivalAirportName: name);
  }

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
          ),
        );
      }

      debugPrint("✅ Fetched into state: $results");
    } catch (e) {
      debugPrint("❌ Failed loading recent searches: $e");
    }
  }

  String? get departDate => state.departDate;
}

final flightSearchProvider =
    StateNotifierProvider<FlightSearchController, FlightSearchState>(
      (ref) => FlightSearchController(),
    );
