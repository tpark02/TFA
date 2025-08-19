import 'package:TFA/providers/recent_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlightSearchState {
  final AsyncValue<Map<String, dynamic>> flightResults, inBoundFlightResults;
  final List<RecentSearch> recentSearches;
  final List<Map<String, dynamic>> processedFlights;
  final List<Map<String, dynamic>>? processedInBoundFlights;
  final List<String> hiddenAirporCodeList;
  // final String departureAirportName;
  final String departureAirportCode;
  final String departureCity;

  // final String arrivalAirportName;
  final String arrivalAirportCode;
  final String arrivalCity;

  final String? displayDate;
  final String cabinClass;
  final int passengerCount;

  final String departDate;
  final String? returnDate;
  final bool isLoading;
  final int searchNonce;

  static const List<RecentSearch> _defaultRecentSearches = <RecentSearch>[
    RecentSearch(
      destination: '',
      tripDateRange: '',
      icons: <Widget>[],
      destinationCode: '',
      guests: 0,
      rooms: 0,
      kind: 'flight',
      departCode: '',
      arrivalCode: '',
      departDate: '',
      returnDate: '',
    ),
    RecentSearch(
      destination: '',
      tripDateRange: '',
      icons: <Widget>[],
      destinationCode: '',
      guests: 0,
      rooms: 0,
      kind: 'flight',
      departCode: '',
      arrivalCode: '',
      departDate: '',
      returnDate: '',
    ),
    RecentSearch(
      destination: '',
      tripDateRange: '',
      icons: <Widget>[],
      destinationCode: '',
      guests: 0,
      rooms: 0,
      kind: 'flight',
      departCode: '',
      arrivalCode: '',
      departDate: '',
      returnDate: '',
    ),
    RecentSearch(
      destination: '',
      tripDateRange: '',
      icons: <Widget>[],
      destinationCode: '',
      guests: 0,
      rooms: 0,
      kind: 'flight',
      departCode: '',
      arrivalCode: '',
      departDate: '',
      returnDate: '',
    ),
    RecentSearch(
      destination: '',
      tripDateRange: '',
      icons: <Widget>[],
      destinationCode: '',
      guests: 0,
      rooms: 0,
      kind: 'flight',
      departCode: '',
      arrivalCode: '',
      departDate: '',
      returnDate: '',
    ),
  ];

  FlightSearchState({
    this.isLoading = false,
    this.recentSearches = _defaultRecentSearches,
    // this.departureAirportName = '',
    this.departureAirportCode = '',
    this.departureCity = '',
    // this.arrivalAirportName = '',
    this.arrivalAirportCode = '',
    this.arrivalCity = '',
    this.displayDate = '',
    this.departDate = '',
    this.returnDate = '',
    this.cabinClass = 'Economy',
    this.passengerCount = 1,
    this.flightResults = const AsyncValue.data(<String, dynamic>{}),
    this.inBoundFlightResults = const AsyncValue.data(<String, dynamic>{}),

    this.processedFlights = const <Map<String, dynamic>>[],
    this.processedInBoundFlights = const <Map<String, dynamic>>[],
    this.searchNonce = 0,
    this.hiddenAirporCodeList = const <String>[],
  });

  // 👇 Full and correct copyWith
  FlightSearchState copyWith({
    bool? isLoading,
    // AsyncValue<Map<String, dynamic>>? flightResults,
    // AsyncValue<Map<String, dynamic>>? inBoundFlightResults,
    List<RecentSearch>? recentSearches,
    List<Map<String, dynamic>>? processedFlights,
    List<String>? hiddenAirporCodeList,
    // List<Map<String, dynamic>>? processedInBoundFlights,
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
    bool clearReturnDate = false,
    bool clearInboundFlights = false,
    int? searchNonce,
  }) {
    return FlightSearchState(
      // inBoundFlightResults: inBoundFlightResults ?? this.inBoundFlightResults,
      // flightResults: flightResults ?? this.flightResults,
      recentSearches: recentSearches ?? this.recentSearches,
      processedFlights: processedFlights ?? this.processedFlights,
      // departureAirportName: departureAirportName ?? this.departureAirportName,
      departureAirportCode: departureAirportCode ?? this.departureAirportCode,
      departureCity: departureCity ?? this.departureCity,
      // arrivalAirportName: arrivalAirportName ?? this.arrivalAirportName,
      arrivalAirportCode: arrivalAirportCode ?? this.arrivalAirportCode,
      arrivalCity: arrivalCity ?? this.arrivalCity,
      displayDate: displayDate ?? this.displayDate,
      cabinClass: cabinClass ?? this.cabinClass,
      passengerCount: passengerCount ?? this.passengerCount,
      departDate: departDate ?? this.departDate,
      returnDate: clearReturnDate ? null : returnDate ?? this.returnDate,
      isLoading: isLoading ?? this.isLoading,
      searchNonce: searchNonce ?? this.searchNonce,
      hiddenAirporCodeList: hiddenAirporCodeList ?? this.hiddenAirporCodeList,
    );
  }

  // 🔹 Specific mutators
  FlightSearchState copyWithRecentSearches(
    List<RecentSearch> updatedRecentSearches,
  ) {
    return copyWith(recentSearches: updatedRecentSearches);
  }

  // FlightSearchState copyWithFlightResults(
  //   AsyncValue<Map<String, dynamic>> newResults,
  // ) {
  //   return copyWith(flightResults: newResults);
  // }

  // FlightSearchState copyWithInBoundFlightResults(
  //   AsyncValue<Map<String, dynamic>> newResults,
  // ) {
  //   return copyWith(inBoundFlightResults: newResults);
  // }

  // FlightSearchState copyWithProcessedFlights(
  //   List<Map<String, dynamic>> flights,
  // ) {
  //   return copyWith(processedFlights: flights);
  // }

  // FlightSearchState copyWithProcessedInboundFlights(
  //   List<Map<String, dynamic>> flights,
  // ) {
  //   return copyWith(processedInBoundFlights: flights);
  // }

  @override
  String toString() {
    return 'FlightSearchState(recent: $recentSearches, '
        'dep: $departureCity-$departureAirportCode, '
        'arr: $arrivalCity-$arrivalAirportCode, '
        'date: $displayDate, class: $cabinClass, pax: $passengerCount, '
        'departDate: $departDate, returnDate: $returnDate)';
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

  // FlightSearchState copyWithLoading(bool isLoading) {
  //   return copyWith(
  //     flightResults: isLoading
  //         ? const AsyncLoading()
  //         : const AsyncData(<String, dynamic>{}),
  //     inBoundFlightResults: isLoading
  //         ? const AsyncLoading()
  //         : const AsyncData(<String, dynamic>{}),
  //   );
  // }
}
