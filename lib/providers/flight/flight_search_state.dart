import 'package:TFA/providers/recent_search.dart';

class FlightSearchState {
  final List<RecentSearch> recentSearches;

  final String departureAirportName;
  final String departureAirportCode;
  final String departureCity;

  final String arrivalAirportName;
  final String arrivalAirportCode;
  final String arrivalCity;

  final String? displayDate;
  final String cabinClass;
  final int passengerCount;

  static const List<RecentSearch> _defaultRecentSearches = [
    RecentSearch(
      destination: '',
      tripDateRange: '',
      icons: [],
      destinationCode: '',
      guests: 0,
      kind: 'flight',
    ),
    RecentSearch(
      destination: '',
      tripDateRange: '',
      icons: [],
      destinationCode: '',
      guests: 0,
      kind: 'flight',
    ),
    RecentSearch(
      destination: '',
      tripDateRange: '',
      icons: [],
      destinationCode: '',
      guests: 0,
      kind: 'flight',
    ),
    RecentSearch(
      destination: '',
      tripDateRange: '',
      icons: [],
      destinationCode: '',
      guests: 0,
      kind: 'flight',
    ),
    RecentSearch(
      destination: '',
      tripDateRange: '',
      icons: [],
      destinationCode: '',
      guests: 0,
      kind: 'flight',
    ),
  ];

  const FlightSearchState({
    this.recentSearches = _defaultRecentSearches,
    this.departureAirportName = '',
    this.departureAirportCode = '',
    this.departureCity = '',
    this.arrivalAirportName = '',
    this.arrivalAirportCode = '',
    this.arrivalCity = '',
    this.displayDate,
    this.cabinClass = 'Economy',
    this.passengerCount = 0,
  });

  FlightSearchState copyWith({
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
    );
  }

  @override
  String toString() {
    return 'FlightSearchState(recent: $recentSearches, '
        'dep: $departureCity-$departureAirportCode, '
        'arr: $arrivalCity-$arrivalAirportCode, '
        'date: $displayDate, class: $cabinClass, pax: $passengerCount)';
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
      cabinClass.hashCode ^
      passengerCount.hashCode;
}
