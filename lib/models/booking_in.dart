import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_in.freezed.dart';
part 'booking_in.g.dart';

@freezed
class BookingIn with _$BookingIn {
  const factory BookingIn({
    // 🔥 Moved annotations above each parameter
    @JsonKey(name: 'trip_date_range') required String tripDateRange,

    @JsonKey(name: 'destination_code') required String destinationCode,

    @JsonKey(name: 'passenger_cnt') required int passengerCnt,

    @JsonKey(name: 'infant_lap') required int infantLap,

    @JsonKey(name: 'infant_seat') required int infantSeat,

    @JsonKey(name: 'cabin_idx') required int cabinIdx,

    @JsonKey(name: 'depart_code') required String departCode,

    @JsonKey(name: 'arrival_code') required String arrivalCode,

    @JsonKey(name: 'depart_date') required String departDate,

    @JsonKey(name: 'return_date') String? returnDate,
    @JsonKey(name: 'prices') required String? prices,

    required String destination,
    required int adult,
    required int children,
    required int rooms,
    required String kind,
  }) = _BookingIn;

  factory BookingIn.fromJson(Map<String, dynamic> json) =>
      _$BookingInFromJson(json);
}
