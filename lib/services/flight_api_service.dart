import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:TFA/utils/api_config.dart';

class FlightApiService {
  static Future<Map<String, dynamic>> fetchFlights({
    required String origin,
    required String destination,
    required String departureDate,
    required String? returnDate,
    int adults = 1,
    int maxResults = 5,
  }) async {
    final Uri uri = Uri.http(
      baseUrl.replaceFirst('http://', ''),
      '/api/v1/flights/search',
      <String, dynamic>{
        'origin': origin,
        'destination': destination,
        'departure_date': departureDate,
        if (returnDate != null) 'return_date': returnDate,
        'adults': adults.toString(),
        'max_results': maxResults.toString(),
      },
    );

    debugPrint("📤 Flight API Request URI: $uri");
    debugPrint(
      "🔍 Params: origin=$origin, destination=$destination, departure=$departureDate, return=$returnDate, adults=$adults, max=$maxResults",
    );

    final http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return decoded
          as Map<
            String,
            dynamic
          >; // ✅ Return full object (data + dictionaries + meta)
    } else {
      throw Exception('Failed to fetch flights: ${response.body}');
    }
  }
}
