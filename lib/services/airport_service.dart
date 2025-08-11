import 'dart:convert';
import 'package:TFA/utils/api_config.dart';
import 'package:http/http.dart' as http;

class AirportService {
  Future<List<Map<String, dynamic>>> nearbyAirports({
    required double lat,
    required double lon,
    int radiusKm = 100,
    int limit = 10,
    int offset = 0,
  }) async {
    final uri = Uri.parse('$baseUrl/api/v1/airports/nearby').replace(
      queryParameters: {
        'latitude': lat.toStringAsFixed(6),
        'longitude': lon.toStringAsFixed(6),
        'radius_km': '$radiusKm',
        'sort': 'distance',
        'limit': '$limit',
        'offset': '$offset',
      },
    );

    final res = await http.get(uri, headers: {'Accept': 'application/json'});
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final body = json.decode(res.body) as Map<String, dynamic>;
      final data = (body['data'] as List?) ?? [];
      return data.cast<Map<String, dynamic>>();
    }
    throw Exception('Nearby airports failed: ${res.statusCode} ${res.body}');
  }
}
