import 'dart:convert';
import 'dart:io'; // for SocketException
import 'package:http/http.dart' as http;
import 'package:TFA/utils/api_config.dart';

class RecentSearchApiService {
  static Future<void> sendRecentSearch({
    required String destination,
    required String tripDateRange,
    required String destinationCode,
    required String jwtToken,
  }) async {
    final url = Uri.parse("$baseUrl/api/v1/recent-searches/");

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode({
          'destination': destination,
          'trip_date_range': tripDateRange,
          'destination_code': destinationCode,
        }),
      );

      if (response.statusCode == 200) {
        print("✅ Sent: ${response.body}");
      } else {
        print("❌ Failed: ${response.statusCode} ${response.body}");
      }
    } on SocketException catch (e) {
      print("🌐 Network error: $e");
    } on HttpException catch (e) {
      print("📡 HTTP error: $e");
    } on FormatException catch (e) {
      print("🧨 Bad response format: $e");
    } catch (e) {
      print("🔥 Unexpected error: $e");
    }
  }
}
