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
    required int passengerCnt,
    required int rooms,
    required String kind,
    required String departCode,
    required String arrivalCode,
    required String departDate, // "yyyy-MM-dd"
    required String? returnDate, // "yyyy-MM-dd"
    int cabinIdx = 0,
    int adult = 1,
    int children = 0,
    int infantLap = 0,
    int infantSeat = 0,
    required String jwtToken,
  }) async {
    final Uri url = Uri.parse("$baseUrl/api/v1/recent-searches/");

    try {
      final http.Response response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(<String, Object?>{
          'destination': destination,
          'trip_date_range': tripDateRange,
          'destination_code': destinationCode,
          'passenger_cnt': passengerCnt,
          'adult': adult,
          'children': children,
          'infant_lap': infantLap,
          'infant_seat': infantSeat,
          'cabin_idx': cabinIdx,
          'rooms': rooms,
          'kind': kind,
          'depart_code': departCode,
          'arrival_code': arrivalCode,
          'depart_date': departDate,
          'return_date': returnDate,
        }),
      );

      if (response.statusCode == 200) {
        print("✅ Sent: ${response.body}");
        return true;
      } else if (response.statusCode == 422) {
        print(
          "422 detail: ${response.body}",
        ); // <-- shows the exact field failing
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

  static Future<List<Map<String, dynamic>>> fetchRecentSearches(
    String kind,
  ) async {
    final User? user = FirebaseAuth.instance.currentUser;
    final String? idToken = await user?.getIdToken();

    if (idToken == null) {
      throw Exception("User not authenticated.");
    }

    final Uri url = Uri.parse("$baseUrl/api/v1/recent-searches/$kind");

    final http.Response response = await http.get(
      url,
      headers: <String, String>{
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
