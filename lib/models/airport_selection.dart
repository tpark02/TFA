class AirportSelection {
  final String name;
  final String code;
  final String city;

  const AirportSelection({
    required this.name,
    required this.code,
    required this.city,
  });

  @override
  String toString() =>
      'AirportSelection(name: $name, code: $code,  city: $city)';
}
