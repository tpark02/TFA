import 'package:chat_app/models/hotel.dart';
import 'package:chat_app/providers/recent_search.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'hotel_search_state.dart';

class HotelSearchController extends StateNotifier<HotelSearchState> {
  HotelSearchController() : super(const HotelSearchState());

  void addRecentSearch(RecentSearch search) {
    final updated = [search, ...state.recentSearches];
    if (updated.length > 5) updated.removeLast(); // optional: cap at 5 items
    state = state.copyWith(recentSearches: updated);
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
}

final hotelSearchProvider =
    StateNotifierProvider<HotelSearchController, HotelSearchState>(
      (ref) => HotelSearchController(),
    );
