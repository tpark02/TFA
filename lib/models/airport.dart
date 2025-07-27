class Airport {
  final String icaoCode;
  final String iataCode;
  final String airportName;
  final String country;
  final String city;

  const Airport({
    required this.icaoCode,
    required this.iataCode,
    required this.airportName,
    required this.country,
    required this.city,
  });

  factory Airport.fromCsvRow(List<dynamic> row) {
    String getStr(int i) => (i < row.length ? row[i] : '').toString().trim();

    return Airport(
      iataCode: getStr(0),
      icaoCode: getStr(1),
      airportName: getStr(2),
      country: getStr(3),
      city: getStr(4),
    );
  }
}
