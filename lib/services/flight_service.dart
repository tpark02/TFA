import 'dart:convert';
import 'package:TFA/models/flight_search_int.dart';
import 'package:TFA/models/flight_search_out.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:TFA/utils/api_config.dart';

class FlightService {
  void _checkNulls(Map<String, dynamic> map, [String path = ""]) {
    map.forEach((String key, value) {
      final String fullPath = path.isEmpty ? key : "$path.$key";
      if (value == null) {
        debugPrint("⚠️ NULL detected at $fullPath");
      } else if (value is Map<String, dynamic>) {
        _checkNulls(value, fullPath);
      } else if (value is List) {
        for (int i = 0; i < value.length; i++) {
          final item = value[i];
          if (item is Map<String, dynamic>) {
            _checkNulls(item, "$fullPath[$i]");
          }
        }
      }
    });
  }

  Future<FlightSearchOut> fetchFlights({
    required String origin,
    required String destination,
    required String departureDate,
    required String? returnDate,
    int adults = 1,
    int children = 0,
    int infants = 0,
    String travelClass = 'ECONOMY',
    int maxResults = 5,
  }) async {
    try {
      final Uri url = Uri.http(
        baseUrl.replaceFirst('http://', ''),
        '/api/v1/flights/search',
        <String, dynamic>{
          'origin': origin,
          'destination': destination,
          'departure_date': departureDate,
          if (returnDate != null) 'return_date': returnDate,
          'adults': adults.toString(),
          'children': children.toString(),
          'infants': infants.toString(),
          'travelClass': travelClass,
          'max_results': maxResults.toString(),
        },
      );

      debugPrint("📤 Flight API Request URI: $url");
      debugPrint(
        "🔍 Params: origin=$origin, \n"
        "destination=$destination, \n"
        "departure=$departureDate, \n"
        "return=$returnDate, \n"
        "adults=$adults, \n"
        "max=$maxResults",
      );

      final http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded is List) {
          for (int i = 0; i < decoded.length; i++) {
            if (decoded[i] is Map<String, dynamic>) {
              _checkNulls(decoded[i], "root[$i]");
            }
          }
        }
        return FlightSearchOut.fromJson(decoded);
      } else {
        throw Exception('Failed to fetch flights: ${response.body}');
      }
    } catch (e) {
      throw ("flight api service error : $e");
    }
  }

  Future<List<FlightSearchOut>> fetchHiddenCity({
    required FlightSearchIn payload,
  }) async {
    final Uri url = Uri.parse("$baseUrl/api/v1/hidden-city/search");
    final http.Response response = await http.post(
      url,
      headers: <String, String>{"Content-Type": "application/json"},
      body: jsonEncode(payload.toJson()),
    );

    debugPrint("📤 Flight API Request URI: $url");

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      // 🟢 Debug: print every field that's null
      void checkNulls(Map<String, dynamic> map, [String path = ""]) {
        map.forEach((String key, value) {
          final String fullPath = path.isEmpty ? key : "$path.$key";
          if (value == null) {
            debugPrint("⚠️ NULL detected at $fullPath");
          } else if (value is Map<String, dynamic>) {
            checkNulls(value, fullPath);
          } else if (value is List) {
            for (int i = 0; i < value.length; i++) {
              final item = value[i];
              if (item is Map<String, dynamic>) {
                checkNulls(item, "$fullPath[$i]");
              }
            }
          }
        });
      }

      if (decoded is List) {
        for (int i = 0; i < decoded.length; i++) {
          if (decoded[i] is Map<String, dynamic>) {
            checkNulls(decoded[i], "root[$i]");
          }
        }
      }

      // then continue parsing
      return (decoded as List)
          .map((e) => FlightSearchOut.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to fetch flights: ${response.body}');
    }
  }
}

final Provider<FlightService> flightApiServiceProvider =
    Provider<FlightService>((ProviderRef<FlightService> ref) {
      return FlightService();
    });
