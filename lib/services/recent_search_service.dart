import 'dart:convert';
import 'dart:io'; // for SocketException
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:TFA/utils/api_config.dart';

class RecentSearchApiService {
  static Future<bool> sendRecentSearch({
    required String destination,
    required String tripDateRange,
    required String destinationCode,
    required int guests,
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
          'guests': guests,
        }),
      );

      if (response.statusCode == 200) {
        print("✅ Sent: ${response.body}");
        return true;
      } else {
        print("❌ Failed: ${response.statusCode} ${response.body}");
        return false;
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
    return false;
  }

  static Future<List<Map<String, dynamic>>> fetchRecentSearches() async {
    final user = FirebaseAuth.instance.currentUser;
    final idToken = await user?.getIdToken();

    if (idToken == null) {
      throw Exception("User not authenticated.");
    }

    final url = Uri.parse("$baseUrl/api/v1/recent-searches/");

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $idToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.cast<Map<String, dynamic>>();
    } else {
      throw Exception("❌ Failed: ${response.statusCode} ${response.body}");
    }
  }
}
