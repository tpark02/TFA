class Hotel {
  final String name;
  final String rating;
  final String score;
  final String numberOfReviews;
  final String price;
  final String roomType;
  final String city;
  final String country;

  const Hotel({
    required this.name,
    required this.rating,
    required this.score,
    required this.numberOfReviews,
    required this.price,
    required this.roomType,
    required this.city,
    required this.country,
  });

  factory Hotel.fromCsvRow(List<dynamic> row) {
    String getStr(int i) => (i < row.length ? row[i] : '').toString().trim();

    return Hotel(
      name: getStr(0),
      rating: getStr(1),
      score: getStr(2),
      numberOfReviews: getStr(3),
      price: getStr(4),
      roomType: getStr(5),
      city: getStr(6),
      country: getStr(7),
    );
  }

  @override
  String toString() {
    return '$name ($city, $country) - $roomType | $price USD | $score ★';
  }
}
