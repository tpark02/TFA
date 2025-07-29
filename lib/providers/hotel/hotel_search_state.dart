class HotelSearchState {
  final String name;
  final String rating;
  final String score;
  final String numberOfReviews;
  final String price;
  final String roomType;
  final String city;
  final String country;

  const HotelSearchState({
    this.name = '',
    this.rating = '',
    this.score = '',
    this.numberOfReviews = '',
    this.price = '',
    this.roomType = '',
    this.city = '',
    this.country = '',
  });

  HotelSearchState copyWith({
    String? name,
    String? rating,
    String? score,
    String? numberOfReviews,
    String? price,
    String? roomType,
    String? city,
    String? country,
  }) {
    return HotelSearchState(
      name: name ?? this.name,
      rating: rating ?? this.rating,
      score: score ?? this.score,
      numberOfReviews: numberOfReviews ?? this.numberOfReviews,
      price: price ?? this.price,
      roomType: roomType ?? this.roomType,
      city: city ?? this.city,
      country: country ?? this.country,
    );
  }
}
