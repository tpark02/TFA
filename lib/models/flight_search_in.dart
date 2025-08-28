class FlightSearchIn {
  final String origin;
  final String exitVia;
  final String departDate;
  final List<String> candidateDests;
  int adults = 1;
  int children = 0;
  int infants = 0;
  String travelClass = 'ECONOMY';
  FlightSearchIn({
    required this.origin,
    required this.exitVia,
    required this.departDate,
    required this.candidateDests,
    required this.adults,
    required this.children,
    required this.infants,
    required this.travelClass,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
    "origin": origin,
    "exit_via": exitVia,
    "depart_date": departDate,
    "candidate_dests": candidateDests,
    "adults": adults,
    "children": children,
    "infants": infants,
    "travelClass": travelClass,
  };
}
