class Car {
  final int index;
  final String tid;
  final String locName;
  final String locNumber;
  final String locType;
  final String address1;
  final String country;
  final String city;
  final String state;
  final String phone;
  final String postalCode;
  final String groupBranchNumber;
  final double? latitude;
  final double? longitude;
  final String updateTimestamp;
  final String runDate;
  final String insertUpdateTime;
  final String runId;
  final String brand;

  Car({
    required this.index,
    required this.tid,
    required this.locName,
    required this.locNumber,
    required this.locType,
    required this.address1,
    required this.country,
    required this.city,
    required this.state,
    required this.phone,
    required this.postalCode,
    required this.groupBranchNumber,
    this.latitude,
    this.longitude,
    required this.updateTimestamp,
    required this.runDate,
    required this.insertUpdateTime,
    required this.runId,
    required this.brand,
  });

  factory Car.fromCsvRow(List<dynamic> row) {
    String getStr(int i) => i < row.length ? row[i].toString().trim() : '';
    double? getDouble(int i) =>
        double.tryParse(row.length > i ? row[i].toString().trim() : '');

    return Car(
      index: int.tryParse(getStr(0)) ?? 0,
      tid: getStr(1),
      locName: getStr(2),
      locNumber: getStr(3),
      locType: getStr(4),
      address1: getStr(5),
      country: getStr(6),
      city: getStr(7),
      state: getStr(8),
      phone: getStr(9),
      postalCode: getStr(10),
      groupBranchNumber: getStr(11),
      latitude: getDouble(12),
      longitude: getDouble(13),
      updateTimestamp: getStr(14),
      runDate: getStr(15),
      insertUpdateTime: getStr(16),
      runId: getStr(17),
      brand: getStr(18),
    );
  }

  @override
  String toString() {
    return '$locName, $city, $country';
  }
}
