import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:TFA/utils/api_config.dart';

class FlightApiService {
  static Future<List<dynamic>> fetchFlights({
    required String origin,
    required String destination,
    required String departureDate,
    String? returnDate,
    int adults = 1,
    int maxResults = 5,
  }) async {
    final uri =
        Uri.http(baseUrl.replaceFirst('http://', ''), '/flights/search', {
          'origin': origin,
          'destination': destination,
          'departure_date': departureDate,
          if (returnDate != null) 'return_date': returnDate,
          'adults': adults.toString(),
          'max_results': maxResults.toString(),
        });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch flights: ${response.body}');
    }
  }
}
