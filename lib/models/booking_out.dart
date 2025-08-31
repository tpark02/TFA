import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_out.freezed.dart';
part 'booking_out.g.dart';

@freezed
class BookingOut with _$BookingOut {
  const factory BookingOut({
    @JsonKey(name: 'user_id') required int userId,

    required String destination,
    @JsonKey(name: 'trip_date_range') required String tripDateRange,
    @JsonKey(name: 'destination_code') required String destinationCode,

    @JsonKey(name: 'passenger_cnt') required int passengerCnt,
    required int adult,
    required int children,
    @JsonKey(name: 'infant_lap') required int infantLap,
    @JsonKey(name: 'infant_seat') required int infantSeat,

    @JsonKey(name: 'cabin_idx') required int cabinIdx,
    required int rooms,
    required String kind,

    @JsonKey(name: 'depart_code') required String departCode,
    @JsonKey(name: 'arrival_code') required String arrivalCode,

    @JsonKey(name: 'depart_date') required String departDate,
    @JsonKey(name: 'return_date') String? returnDate,

    /// Server returns an int (total price in minor units or currency’s base)
    @JsonKey(name: 'prices') required String prices,

    /// ISO8601 -> DateTime
    // @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _BookingOut;

  factory BookingOut.fromJson(Map<String, dynamic> json) =>
      _$BookingOutFromJson(json);
}
