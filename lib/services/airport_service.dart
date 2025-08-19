import 'dart:convert';
import 'package:TFA/utils/api_config.dart';
import 'package:flutter/foundation.dart';
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
      },
    );

    final http.Response res = await http.get(
      uri,
      headers: <String, String>{'Accept': 'application/json'},
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final Map<String, dynamic> body =
          json.decode(res.body) as Map<String, dynamic>;
      final List data = (body['data'] as List?) ?? <dynamic>[];
      return data.cast<Map<String, dynamic>>();
    }
    throw Exception('Nearby airports failed: ${res.statusCode} ${res.body}');
  }

  Future<List<Map<String, dynamic>>?> searchHiddenAirports({
    required String iataCode,
    double? latitude,
    double? longitude,
  }) async {
    final Uri primaryUri = Uri.parse(
      '$baseUrl/api/v1/airports/location/$iataCode',
    );

    try {
      final http.Response res = await http.get(
        primaryUri,
        headers: const <String, String>{'Accept': 'application/json'},
      );

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final Map<String, dynamic> body =
            json.decode(res.body) as Map<String, dynamic>;
        final List data = (body['data'] as List?) ?? <dynamic>[];
        return data.cast<Map<String, dynamic>>();
      }

      // 🟠 if 404, trigger fallback
      if (res.statusCode == 404 && latitude != null && longitude != null) {
        debugPrint(
          "⚠️ No airports found by IATA, falling back to nearby search...",
        );
        return await _fallbackNearbyAirports(latitude, longitude);
      }

      throw Exception(
        'search hidden airports failed: ${res.statusCode} ${res.body}',
      );
    } catch (e) {
      debugPrint("❌ Error in searchHiddenAirports: $e");
      return null;
    }
  }

  /// fallback: call /api/v1/airports/nearby
  Future<List<Map<String, dynamic>>> _fallbackNearbyAirports(
    double latitude,
    double longitude,
  ) async {
    final Uri uri = Uri.parse(
      '$baseUrl/api/v1/airports/nearby?latitude=$latitude&longitude=$longitude',
    );
    final http.Response res = await http.get(
      uri,
      headers: const <String, String>{'Accept': 'application/json'},
    );

    if (res.statusCode >= 200 && res.statusCode < 300) {
      final Map<String, dynamic> body =
          json.decode(res.body) as Map<String, dynamic>;
      final List data = (body['data'] as List?) ?? <dynamic>[];
      return data.cast<Map<String, dynamic>>();
    }

    throw Exception(
      'fallback nearby airports failed: ${res.statusCode} ${res.body}',
    );
  }
}
