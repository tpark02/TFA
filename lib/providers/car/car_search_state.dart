import 'package:TFA/providers/recent_search.dart';
import 'package:flutter/src/widgets/framework.dart';

class CarSearchState {
  final String query;
  final String selectedCountry;
  final String selectedCity;
  // final String beginDate;
  // final String endDate;
  final String beginTime;
  final String endTime;
  // final String displayBeginDate;
  // final String displayEndDate;
  final List<RecentSearch> recentSearches;
  final String departDate;
  final String? returnDate;
  final String displayDepartDate;
  final String? displayReturnDate;

  const CarSearchState({
    this.recentSearches = _defaultRecentSearches,
    // this.beginDate = '',
    // this.endDate = '',
    this.beginTime = '',
    this.endTime = '',
    this.query = '',
    this.selectedCountry = '',
    this.selectedCity = '',
    // this.displayBeginDate = '',
    // this.displayEndDate = '',
    this.departDate = '',
    this.returnDate = '',
    this.displayDepartDate = '',
    this.displayReturnDate = '',
  });

  static const List<RecentSearch> _defaultRecentSearches = <RecentSearch>[
    RecentSearch(
      destination: '',
      tripDateRange: '',
      icons: <Widget>[],
      destinationCode: '',
      passengerCnt: 0,
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
      passengerCnt: 0,
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
      passengerCnt: 0,
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
      passengerCnt: 0,
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
      passengerCnt: 0,
      rooms: 0,
      kind: 'flight',
      departCode: '',
      arrivalCode: '',
      departDate: '',
      returnDate: '',
    ),
  ];

  CarSearchState copyWith({
    String? query,
    String? selectedCountry,
    String? selectedCity,
    // String? beginDate,
    // String? endDate,
    String? beginTime,
    String? endTime,
    // String? displayBeginDate,
    // String? displayEndDate,
    bool clearReturnDate = false,

    String? departDate,
    String? returnDate,
    List<RecentSearch>? recentSearches,
    String? displayDepartDate,
    String? displayReturnDate,
  }) {
    return CarSearchState(
      query: query ?? this.query,
      selectedCountry: selectedCountry ?? this.selectedCountry,
      selectedCity: selectedCity ?? this.selectedCity,
      recentSearches: recentSearches ?? this.recentSearches,
      departDate: departDate ?? this.departDate,
      returnDate: clearReturnDate ? null : returnDate ?? this.returnDate,
      displayDepartDate: displayDepartDate ?? this.displayDepartDate,
      displayReturnDate: displayReturnDate ?? this.displayReturnDate,

      // beginDate: beginDate ?? this.beginDate,
      // endDate: endDate ?? this.endDate,
      beginTime: beginTime ?? this.beginTime,
      endTime: endTime ?? this.endTime,
      // displayEndDate: displayEndDate ?? this.displayEndDate,
      // displayBeginDate: displayBeginDate ?? this.displayBeginDate,
    );
  }
}
