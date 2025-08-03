import 'package:TFA/models/hotel.dart';
import 'package:TFA/providers/recent_search.dart';
import 'package:TFA/services/recent_search_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'hotel_search_state.dart';

class HotelSearchController extends StateNotifier<HotelSearchState> {
  HotelSearchController() : super(const HotelSearchState());

  Future<void> initRecentSearch(RecentSearch search) async {
    final updated = [search, ...state.recentSearches];
    if (updated.length > 5) updated.removeLast();
    state = state.copyWith(recentSearches: updated);
  }

  Future<bool> addRecentSearch(RecentSearch search, String jwtToken) async {
    final updated = [search, ...state.recentSearches];
    if (updated.length > 5) updated.removeLast(); // optional: cap at 5 items
    state = state.copyWith(recentSearches: updated);
    // ❌ Only send to backend if not placeholder
    if (search.destination.trim().isEmpty ||
        search.tripDateRange.trim().isEmpty ||
        search.rooms <= 0 ||
        search.guests <= 0) {
      debugPrint("⚠️ Skipped sending empty search to backend");
      return false;
    }

    // ✅ Send only valid searches
    return await RecentSearchApiService.sendRecentSearch(
      destination: search.destination,
      tripDateRange: search.tripDateRange,
      destinationCode: search.destinationCode,
      guests: search.guests,
      rooms: search.rooms,
      kind: search.kind,
      jwtToken: jwtToken,
    );
  }

  void setRoomCnt(String cnt) {
    state = state.copyWith(roomCnt: cnt);
  }

  void setAdultCnt(String cnt) {
    state = state.copyWith(adultCnt: cnt);
  }

  void setChildCnt(String cnt) {
    state = state.copyWith(childCnt: cnt);
  }

  void setName(String name) {
    state = state.copyWith(name: name);
  }

  void setRating(String rating) {
    state = state.copyWith(rating: rating);
  }

  void setScore(String score) {
    state = state.copyWith(score: score);
  }

  void setNumberOfReviews(String reviews) {
    state = state.copyWith(numberOfReviews: reviews);
  }

  void setPrice(String price) {
    state = state.copyWith(price: price);
  }

  void setRoomType(String type) {
    state = state.copyWith(roomType: type);
  }

  void setCity(String city) {
    state = state.copyWith(city: city);
  }

  void setCountry(String country) {
    state = state.copyWith(country: country);
  }

  void setDisplayDate(String displayDate) {
    state = state.copyWith(displayDate: displayDate);
  }

  void setFromHotelModel(Hotel hotel) {
    state = HotelSearchState(
      name: hotel.name,
      rating: hotel.rating,
      score: hotel.score,
      numberOfReviews: hotel.numberOfReviews,
      price: hotel.price,
      roomType: hotel.roomType,
      city: hotel.city,
      country: hotel.country,
    );
  }

  void reset() {
    state = const HotelSearchState();
  }

  Future<void> loadRecentSearchesFromApi() async {
    try {
      final results = await RecentSearchApiService.fetchRecentSearches('hotel');
      state = state.copyWith(recentSearches: []);

      for (final r in results) {
        final guestsValue = r['guests'];
        final guests = guestsValue is int
            ? guestsValue
            : int.tryParse(guestsValue.toString()) ?? 1;

        final roomsValue = r['rooms'];
        final rooms = roomsValue is int
            ? roomsValue
            : int.tryParse(roomsValue.toString()) ?? 0;

        initRecentSearch(
          RecentSearch(
            destination: r['destination'],
            tripDateRange: r['trip_date_range'],
            icons: [
              const SizedBox(width: 10),
              Icon(Icons.bed, color: Colors.grey[500], size: 20.0),
              Text(rooms.toString()),
              const SizedBox(width: 10),
              Icon(Icons.person, color: Colors.grey[500], size: 20.0),
              Text(guests.toString()),
            ],
            destinationCode: r['destination_code'],
            guests: guests,
            rooms: rooms,
            kind: 'car',
          ),
        );
      }

      debugPrint("✅ Fetched into state: $results");
    } catch (e) {
      debugPrint("❌ Failed loading recent searches: $e");
    }
  }
}

final hotelSearchProvider =
    StateNotifierProvider<HotelSearchController, HotelSearchState>(
      (ref) => HotelSearchController(),
    );
