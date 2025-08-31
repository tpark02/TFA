import 'dart:convert';
import 'package:TFA/utils/api_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:TFA/models/booking_in.dart';
import 'package:TFA/models/booking_out.dart';

class BookingService {
  static Future<BookingOut> createBooking({required BookingIn booking}) async {
    final Uri url = Uri.parse("$baseUrl/api/v1/bookings/");
    final User? user = FirebaseAuth.instance.currentUser;
    final String? idToken = await user?.getIdToken();

    if (idToken == null) {
      throw Exception("User not authenticated.");
    }

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
      body: jsonEncode(booking.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return BookingOut.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        "Booking creation failed: ${response.statusCode} ${response.body}",
      );
    }
  }

  static Future<List<BookingOut>> getBooking(String kind) async {
    final Uri url = Uri.parse("$baseUrl/api/v1/bookings/$kind");
    final User? user = FirebaseAuth.instance.currentUser;
    final String? idToken = await user?.getIdToken();

    if (idToken == null) {
      throw Exception("User not authenticated.");
    }

    final http.Response res = await http.get(
      url,
      headers: <String, String>{
        'Authorization': 'Bearer $idToken',
        'Content-Type': 'application/json',
      },
    );

    if (res.statusCode == 200) {
      final dynamic body = jsonDecode(res.body);
      if (body is List) {
        return body
            .map<BookingOut>(
              (e) => BookingOut.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw Exception(
          'Unexpected response format (expected list): ${res.body}',
        );
      }
    } else if (res.statusCode == 204) {
      return <BookingOut>[];
    } else {
      throw Exception(
        'Failed to fetch bookings: ${res.statusCode} ${res.body}',
      );
    }
  }
}
