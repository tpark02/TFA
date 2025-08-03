import 'package:TFA/providers/recent_search.dart';

class CarSearchState {
  final String query;
  final String selectedCountry;
  final String selectedCity;
  final String beginDate;
  final String endDate;
  final String beginTime;
  final String endTime;
  final List<RecentSearch> recentSearches;

  const CarSearchState({
    this.recentSearches = _defaultRecentSearches,
    this.beginDate = '',
    this.endDate = '',
    this.beginTime = '',
    this.endTime = '',
    this.query = '',
    this.selectedCountry = '',
    this.selectedCity = '',
  });

  static const List<RecentSearch> _defaultRecentSearches = [
    RecentSearch(
      destination: '',
      tripDateRange: '',
      icons: [],
      destinationCode: '',
      guests: 0,
      rooms: 0,
      kind: 'car',
    ),
    RecentSearch(
      destination: '',
      tripDateRange: '',
      icons: [],
      destinationCode: '',
      guests: 0,
      rooms: 0,
      kind: 'car',
    ),
    RecentSearch(
      destination: '',
      tripDateRange: '',
      icons: [],
      destinationCode: '',
      guests: 0,
      rooms: 0,
      kind: 'car',
    ),
    RecentSearch(
      destination: '',
      tripDateRange: '',
      icons: [],
      destinationCode: '',
      guests: 0,
      rooms: 0,
      kind: 'car',
    ),
    RecentSearch(
      destination: '',
      tripDateRange: '',
      icons: [],
      destinationCode: '',
      guests: 0,
      rooms: 0,
      kind: 'car',
    ),
  ];

  CarSearchState copyWith({
    String? query,
    String? selectedCountry,
    String? selectedCity,
    String? beginDate,
    String? endDate,
    String? beginTime,
    String? endTime,
    List<RecentSearch>? recentSearches,
  }) {
    return CarSearchState(
      query: query ?? this.query,
      selectedCountry: selectedCountry ?? this.selectedCountry,
      selectedCity: selectedCity ?? this.selectedCity,
      recentSearches: recentSearches ?? this.recentSearches,
      beginDate: beginDate ?? this.beginDate,
      endDate: endDate ?? this.endDate,
      beginTime: beginTime ?? this.beginTime,
      endTime: endTime ?? this.endTime,
    );
  }
}
