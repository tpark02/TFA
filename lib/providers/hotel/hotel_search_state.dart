import 'package:TFA/providers/recent_search.dart';

class HotelSearchState {
  final List<RecentSearch> recentSearches;

  final String name;
  final String rating;
  final String score;
  final String numberOfReviews;
  final String price;
  final String roomType;
  final String city;
  final String country;
  final String? displayDate;
  final String roomCnt;
  final String adultCnt;
  final String childCnt;
  final String? startDate;
  final String? endDate;

  const HotelSearchState({
    this.recentSearches = _defaultRecentSearches,

    this.name = '',
    this.rating = '',
    this.score = '',
    this.numberOfReviews = '',
    this.price = '',
    this.roomType = '',
    this.city = '',
    this.country = '',
    this.displayDate,
    this.roomCnt = '',
    this.adultCnt = '',
    this.childCnt = '',
    this.startDate = '',
    this.endDate = '',
  });

  static const List<RecentSearch> _defaultRecentSearches = [
    RecentSearch(
      destination: '',
      tripDateRange: '',
      icons: [],
      destinationCode: '',
      guests: 0,
      rooms: 0,
      kind: 'hotel',
    ),
    RecentSearch(
      destination: '',
      tripDateRange: '',
      icons: [],
      destinationCode: '',
      guests: 0,
      rooms: 0,
      kind: 'hotel',
    ),
    RecentSearch(
      destination: '',
      tripDateRange: '',
      icons: [],
      destinationCode: '',
      guests: 0,
      rooms: 0,
      kind: 'hotel',
    ),
    RecentSearch(
      destination: '',
      tripDateRange: '',
      icons: [],
      destinationCode: '',
      guests: 0,
      rooms: 0,
      kind: 'hotel',
    ),
    RecentSearch(
      destination: '',
      tripDateRange: '',
      icons: [],
      destinationCode: '',
      guests: 0,
      rooms: 0,
      kind: 'hotel',
    ),
  ];

  HotelSearchState copyWith({
    List<RecentSearch>? recentSearches,
    String? name,
    String? rating,
    String? score,
    String? numberOfReviews,
    String? price,
    String? roomType,
    String? city,
    String? country,
    String? displayDate,
    String? roomCnt,
    String? adultCnt,
    String? childCnt,
    String? startDate,
    String? endDate,
  }) {
    return HotelSearchState(
      recentSearches: recentSearches ?? this.recentSearches,
      name: name ?? this.name,
      rating: rating ?? this.rating,
      score: score ?? this.score,
      numberOfReviews: numberOfReviews ?? this.numberOfReviews,
      price: price ?? this.price,
      roomType: roomType ?? this.roomType,
      city: city ?? this.city,
      country: country ?? this.country,
      displayDate: displayDate ?? this.displayDate,
      roomCnt: roomCnt ?? this.roomCnt,
      adultCnt: adultCnt ?? this.adultCnt,
      childCnt: childCnt ?? this.childCnt,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
