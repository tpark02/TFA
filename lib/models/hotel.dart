class Hotel {
  final int rank;
  final String name;
  final String location;
  final String overview;
  final int totalRooms;
  final double startingRate;
  final String diningArea;
  final String drinkingArea;
  final List<String> amenities;
  final String address;
  final String phoneNumber;

  Hotel({
    required this.rank,
    required this.name,
    required this.location,
    required this.overview,
    required this.totalRooms,
    required this.startingRate,
    required this.diningArea,
    required this.drinkingArea,
    required this.amenities,
    required this.address,
    required this.phoneNumber,
  });

  factory Hotel.fromCsvRow(List<dynamic> row) {
    String getStr(int i) => (i < row.length ? row[i] : '').toString().trim();

    return Hotel(
      rank: int.tryParse(getStr(0)) ?? 0,
      name: getStr(1),
      location: getStr(2),
      overview: getStr(3),
      totalRooms: int.tryParse(getStr(4)) ?? 0,
      startingRate: double.tryParse(getStr(5)) ?? 0.0,
      diningArea: getStr(6),
      drinkingArea: getStr(7),
      amenities: getStr(8).split(',').map((e) => e.trim()).toList(),
      address: getStr(9),
      phoneNumber: getStr(10),
    );
  }
}
