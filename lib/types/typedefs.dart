typedef FlightSearchResult = (bool success, String message);
typedef FlightSearchParams = (
  String departureAirport,
  String arrivalAirport,
  String? departureDate,
  String? returnDate,
  int passengerCnt,
);
