import 'package:TFA/providers/recent_search.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlightSearchState {
  final AsyncValue<Map<String, dynamic>> flightResults;

  final List<RecentSearch> recentSearches;
  final List<Map<String, dynamic>> processedFlights;

  final String departureAirportName;
  final String departureAirportCode;
  final String departureCity;

  final String arrivalAirportName;
  final String arrivalAirportCode;
  final String arrivalCity;

  final String? displayDate;
  final String cabinClass;
  final int passengerCount;

  final String departDate;
  final String? returnDate;

  static const List<RecentSearch> _defaultRecentSearches = [
    RecentSearch(
      destination: '',
      tripDateRange: '',
      icons: [],
      destinationCode: '',
      guests: 0,
      rooms: 0,
      kind: 'flight',
    ),
    RecentSearch(
      destination: '',
      tripDateRange: '',
      icons: [],
      destinationCode: '',
      guests: 0,
      rooms: 0,
      kind: 'flight',
    ),
    RecentSearch(
      destination: '',
      tripDateRange: '',
      icons: [],
      destinationCode: '',
      guests: 0,
      rooms: 0,
      kind: 'flight',
    ),
    RecentSearch(
      destination: '',
      tripDateRange: '',
      icons: [],
      destinationCode: '',
      guests: 0,
      rooms: 0,
      kind: 'flight',
    ),
    RecentSearch(
      destination: '',
      tripDateRange: '',
      icons: [],
      destinationCode: '',
      guests: 0,
      rooms: 0,
      kind: 'flight',
    ),
  ];

  FlightSearchState({
    this.recentSearches = _defaultRecentSearches,
    this.departureAirportName = '',
    this.departureAirportCode = '',
    this.departureCity = '',
    this.arrivalAirportName = '',
    this.arrivalAirportCode = '',
    this.arrivalCity = '',
    this.displayDate = '',
    this.departDate = '',
    this.returnDate = '',
    this.cabinClass = 'Economy',
    this.passengerCount = 1,
    this.flightResults = const AsyncValue.data({}),
    this.processedFlights = const [],
  });

  FlightSearchState copyWith({
    AsyncValue<Map<String, dynamic>>? flightResults,
    List<RecentSearch>? recentSearches,
    String? departureAirportName,
    String? departureAirportCode,
    String? departureCity,
    String? arrivalAirportName,
    String? arrivalAirportCode,
    String? arrivalCity,
    String? displayDate,
    String? cabinClass,
    int? passengerCount,
    String? departDate,
    String? returnDate,
    List<Map<String, dynamic>>? processedFlights,
  }) {
    return FlightSearchState(
      recentSearches: recentSearches ?? this.recentSearches,
      departureAirportName: departureAirportName ?? this.departureAirportName,
      departureAirportCode: departureAirportCode ?? this.departureAirportCode,
      departureCity: departureCity ?? this.departureCity,
      arrivalAirportName: arrivalAirportName ?? this.arrivalAirportName,
      arrivalAirportCode: arrivalAirportCode ?? this.arrivalAirportCode,
      arrivalCity: arrivalCity ?? this.arrivalCity,
      displayDate: displayDate ?? this.displayDate,
      cabinClass: cabinClass ?? this.cabinClass,
      passengerCount: passengerCount ?? this.passengerCount,
      flightResults: flightResults ?? this.flightResults,
      departDate: departDate ?? this.departDate,
      returnDate: returnDate ?? this.returnDate,
      processedFlights: processedFlights ?? this.processedFlights,
    );
  }

  @override
  String toString() {
    return 'FlightSearchState(recent: $recentSearches, '
        'dep: $departureCity-$departureAirportCode, '
        'arr: $arrivalCity-$arrivalAirportCode, '
        'date: $displayDate,'
        'class: $cabinClass,'
        'pax: $passengerCount,'
        'departDate: $departDate,'
        'returnDate: $returnDate)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlightSearchState &&
          runtimeType == other.runtimeType &&
          recentSearches == other.recentSearches &&
          departureAirportCode == other.departureAirportCode &&
          departureCity == other.departureCity &&
          arrivalAirportCode == other.arrivalAirportCode &&
          arrivalCity == other.arrivalCity &&
          displayDate == other.displayDate &&
          departDate == other.departDate &&
          returnDate == other.returnDate &&
          cabinClass == other.cabinClass &&
          passengerCount == other.passengerCount;

  @override
  int get hashCode =>
      recentSearches.hashCode ^
      departureAirportCode.hashCode ^
      departureCity.hashCode ^
      arrivalAirportCode.hashCode ^
      arrivalCity.hashCode ^
      displayDate.hashCode ^
      departDate.hashCode ^
      returnDate.hashCode ^
      cabinClass.hashCode ^
      passengerCount.hashCode;
}
