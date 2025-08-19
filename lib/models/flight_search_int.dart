class FlightSearchIn {
  final String origin;
  final String exitVia;
  final String departDate;
  final int adults;
  final String cabin;
  final List<String> candidateDests;

  FlightSearchIn({
    required this.origin,
    required this.exitVia,
    required this.departDate,
    required this.adults,
    required this.cabin,
    required this.candidateDests,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
    "origin": origin,
    "exit_via": exitVia,
    "depart_date": departDate,
    "adults": adults,
    "cabin": cabin,
    "candidate_dests": candidateDests,
  };
}
