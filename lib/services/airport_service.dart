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
    final Uri uri = Uri.parse('$baseUrl/api/v1/airports/nearby').replace(
      queryParameters: <String, dynamic>{
        'latitude': lat.toStringAsFixed(6),
        'longitude': lon.toStringAsFixed(6),
        'radius_km': '$radiusKm',
        'sort': 'distance',
        'limit': '$limit',
        'offset': '$offset',
      },
    );

    final http.Response res = await http.get(uri, headers: <String, String>{'Accept': 'application/json'});
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final Map<String, dynamic> body = json.decode(res.body) as Map<String, dynamic>;
      final List data = (body['data'] as List?) ?? <dynamic>[];
      return data.cast<Map<String, dynamic>>();
    }
    throw Exception('Nearby airports failed: ${res.statusCode} ${res.body}');
  }
}
