import 'package:chat_app/providers/recent_search.dart';

class CarSearchState {
  final String query;
  final String selectedCountry;
  final String selectedCity;
  final List<RecentSearch> recentSearches;

  const CarSearchState({
    this.recentSearches = _defaultRecentSearches,

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
    ),
    RecentSearch(
      destination: '',
      tripDateRange: '',
      icons: [],
      destinationCode: '',
    ),
    RecentSearch(
      destination: '',
      tripDateRange: '',
      icons: [],
      destinationCode: '',
    ),
    RecentSearch(
      destination: '',
      tripDateRange: '',
      icons: [],
      destinationCode: '',
    ),
    RecentSearch(
      destination: '',
      tripDateRange: '',
      icons: [],
      destinationCode: '',
    ),
  ];

  CarSearchState copyWith({
    String? query,
    String? selectedCountry,
    String? selectedCity,
    List<RecentSearch>? recentSearches,
  }) {
    return CarSearchState(
      query: query ?? this.query,
      selectedCountry: selectedCountry ?? this.selectedCountry,
      selectedCity: selectedCity ?? this.selectedCity,
      recentSearches: recentSearches ?? this.recentSearches,
    );
  }
}
