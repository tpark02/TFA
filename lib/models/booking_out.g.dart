// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_out.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingOutImpl _$$BookingOutImplFromJson(Map<String, dynamic> json) =>
    _$BookingOutImpl(
      userId: (json['user_id'] as num).toInt(),
      destination: json['destination'] as String,
      tripDateRange: json['trip_date_range'] as String,
      destinationCode: json['destination_code'] as String,
      passengerCnt: (json['passenger_cnt'] as num).toInt(),
      adult: (json['adult'] as num).toInt(),
      children: (json['children'] as num).toInt(),
      infantLap: (json['infant_lap'] as num).toInt(),
      infantSeat: (json['infant_seat'] as num).toInt(),
      cabinIdx: (json['cabin_idx'] as num).toInt(),
      rooms: (json['rooms'] as num).toInt(),
      kind: json['kind'] as String,
      departCode: json['depart_code'] as String,
      arrivalCode: json['arrival_code'] as String,
      departDate: json['depart_date'] as String,
      returnDate: json['return_date'] as String?,
      prices: json['prices'] as String,
    );

Map<String, dynamic> _$$BookingOutImplToJson(_$BookingOutImpl instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'destination': instance.destination,
      'trip_date_range': instance.tripDateRange,
      'destination_code': instance.destinationCode,
      'passenger_cnt': instance.passengerCnt,
      'adult': instance.adult,
      'children': instance.children,
      'infant_lap': instance.infantLap,
      'infant_seat': instance.infantSeat,
      'cabin_idx': instance.cabinIdx,
      'rooms': instance.rooms,
      'kind': instance.kind,
      'depart_code': instance.departCode,
      'arrival_code': instance.arrivalCode,
      'depart_date': instance.departDate,
      'return_date': instance.returnDate,
      'prices': instance.prices,
    };
