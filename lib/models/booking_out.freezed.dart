// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_out.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BookingOut _$BookingOutFromJson(Map<String, dynamic> json) {
  return _BookingOut.fromJson(json);
}

/// @nodoc
mixin _$BookingOut {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  int get userId => throw _privateConstructorUsedError;
  String get destination => throw _privateConstructorUsedError;
  @JsonKey(name: 'trip_date_range')
  String get tripDateRange => throw _privateConstructorUsedError;
  @JsonKey(name: 'destination_code')
  String get destinationCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'passenger_cnt')
  int get passengerCnt => throw _privateConstructorUsedError;
  int get adult => throw _privateConstructorUsedError;
  int get children => throw _privateConstructorUsedError;
  @JsonKey(name: 'infant_lap')
  int get infantLap => throw _privateConstructorUsedError;
  @JsonKey(name: 'infant_seat')
  int get infantSeat => throw _privateConstructorUsedError;
  @JsonKey(name: 'cabin_idx')
  int get cabinIdx => throw _privateConstructorUsedError;
  int get rooms => throw _privateConstructorUsedError;
  String get kind => throw _privateConstructorUsedError;
  @JsonKey(name: 'depart_code')
  String get departCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'arrival_code')
  String get arrivalCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'depart_date')
  String get departDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'return_date')
  String? get returnDate => throw _privateConstructorUsedError;

  /// Server returns an int (total price in minor units or currency’s base)
  int get prices => throw _privateConstructorUsedError;

  /// ISO8601 -> DateTime
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this BookingOut to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookingOut
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingOutCopyWith<BookingOut> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingOutCopyWith<$Res> {
  factory $BookingOutCopyWith(
    BookingOut value,
    $Res Function(BookingOut) then,
  ) = _$BookingOutCopyWithImpl<$Res, BookingOut>;
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'user_id') int userId,
    String destination,
    @JsonKey(name: 'trip_date_range') String tripDateRange,
    @JsonKey(name: 'destination_code') String destinationCode,
    @JsonKey(name: 'passenger_cnt') int passengerCnt,
    int adult,
    int children,
    @JsonKey(name: 'infant_lap') int infantLap,
    @JsonKey(name: 'infant_seat') int infantSeat,
    @JsonKey(name: 'cabin_idx') int cabinIdx,
    int rooms,
    String kind,
    @JsonKey(name: 'depart_code') String departCode,
    @JsonKey(name: 'arrival_code') String arrivalCode,
    @JsonKey(name: 'depart_date') String departDate,
    @JsonKey(name: 'return_date') String? returnDate,
    int prices,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });
}

/// @nodoc
class _$BookingOutCopyWithImpl<$Res, $Val extends BookingOut>
    implements $BookingOutCopyWith<$Res> {
  _$BookingOutCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingOut
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? destination = null,
    Object? tripDateRange = null,
    Object? destinationCode = null,
    Object? passengerCnt = null,
    Object? adult = null,
    Object? children = null,
    Object? infantLap = null,
    Object? infantSeat = null,
    Object? cabinIdx = null,
    Object? rooms = null,
    Object? kind = null,
    Object? departCode = null,
    Object? arrivalCode = null,
    Object? departDate = null,
    Object? returnDate = freezed,
    Object? prices = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as int,
            destination: null == destination
                ? _value.destination
                : destination // ignore: cast_nullable_to_non_nullable
                      as String,
            tripDateRange: null == tripDateRange
                ? _value.tripDateRange
                : tripDateRange // ignore: cast_nullable_to_non_nullable
                      as String,
            destinationCode: null == destinationCode
                ? _value.destinationCode
                : destinationCode // ignore: cast_nullable_to_non_nullable
                      as String,
            passengerCnt: null == passengerCnt
                ? _value.passengerCnt
                : passengerCnt // ignore: cast_nullable_to_non_nullable
                      as int,
            adult: null == adult
                ? _value.adult
                : adult // ignore: cast_nullable_to_non_nullable
                      as int,
            children: null == children
                ? _value.children
                : children // ignore: cast_nullable_to_non_nullable
                      as int,
            infantLap: null == infantLap
                ? _value.infantLap
                : infantLap // ignore: cast_nullable_to_non_nullable
                      as int,
            infantSeat: null == infantSeat
                ? _value.infantSeat
                : infantSeat // ignore: cast_nullable_to_non_nullable
                      as int,
            cabinIdx: null == cabinIdx
                ? _value.cabinIdx
                : cabinIdx // ignore: cast_nullable_to_non_nullable
                      as int,
            rooms: null == rooms
                ? _value.rooms
                : rooms // ignore: cast_nullable_to_non_nullable
                      as int,
            kind: null == kind
                ? _value.kind
                : kind // ignore: cast_nullable_to_non_nullable
                      as String,
            departCode: null == departCode
                ? _value.departCode
                : departCode // ignore: cast_nullable_to_non_nullable
                      as String,
            arrivalCode: null == arrivalCode
                ? _value.arrivalCode
                : arrivalCode // ignore: cast_nullable_to_non_nullable
                      as String,
            departDate: null == departDate
                ? _value.departDate
                : departDate // ignore: cast_nullable_to_non_nullable
                      as String,
            returnDate: freezed == returnDate
                ? _value.returnDate
                : returnDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            prices: null == prices
                ? _value.prices
                : prices // ignore: cast_nullable_to_non_nullable
                      as int,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BookingOutImplCopyWith<$Res>
    implements $BookingOutCopyWith<$Res> {
  factory _$$BookingOutImplCopyWith(
    _$BookingOutImpl value,
    $Res Function(_$BookingOutImpl) then,
  ) = __$$BookingOutImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'user_id') int userId,
    String destination,
    @JsonKey(name: 'trip_date_range') String tripDateRange,
    @JsonKey(name: 'destination_code') String destinationCode,
    @JsonKey(name: 'passenger_cnt') int passengerCnt,
    int adult,
    int children,
    @JsonKey(name: 'infant_lap') int infantLap,
    @JsonKey(name: 'infant_seat') int infantSeat,
    @JsonKey(name: 'cabin_idx') int cabinIdx,
    int rooms,
    String kind,
    @JsonKey(name: 'depart_code') String departCode,
    @JsonKey(name: 'arrival_code') String arrivalCode,
    @JsonKey(name: 'depart_date') String departDate,
    @JsonKey(name: 'return_date') String? returnDate,
    int prices,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });
}

/// @nodoc
class __$$BookingOutImplCopyWithImpl<$Res>
    extends _$BookingOutCopyWithImpl<$Res, _$BookingOutImpl>
    implements _$$BookingOutImplCopyWith<$Res> {
  __$$BookingOutImplCopyWithImpl(
    _$BookingOutImpl _value,
    $Res Function(_$BookingOutImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookingOut
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? destination = null,
    Object? tripDateRange = null,
    Object? destinationCode = null,
    Object? passengerCnt = null,
    Object? adult = null,
    Object? children = null,
    Object? infantLap = null,
    Object? infantSeat = null,
    Object? cabinIdx = null,
    Object? rooms = null,
    Object? kind = null,
    Object? departCode = null,
    Object? arrivalCode = null,
    Object? departDate = null,
    Object? returnDate = freezed,
    Object? prices = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$BookingOutImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as int,
        destination: null == destination
            ? _value.destination
            : destination // ignore: cast_nullable_to_non_nullable
                  as String,
        tripDateRange: null == tripDateRange
            ? _value.tripDateRange
            : tripDateRange // ignore: cast_nullable_to_non_nullable
                  as String,
        destinationCode: null == destinationCode
            ? _value.destinationCode
            : destinationCode // ignore: cast_nullable_to_non_nullable
                  as String,
        passengerCnt: null == passengerCnt
            ? _value.passengerCnt
            : passengerCnt // ignore: cast_nullable_to_non_nullable
                  as int,
        adult: null == adult
            ? _value.adult
            : adult // ignore: cast_nullable_to_non_nullable
                  as int,
        children: null == children
            ? _value.children
            : children // ignore: cast_nullable_to_non_nullable
                  as int,
        infantLap: null == infantLap
            ? _value.infantLap
            : infantLap // ignore: cast_nullable_to_non_nullable
                  as int,
        infantSeat: null == infantSeat
            ? _value.infantSeat
            : infantSeat // ignore: cast_nullable_to_non_nullable
                  as int,
        cabinIdx: null == cabinIdx
            ? _value.cabinIdx
            : cabinIdx // ignore: cast_nullable_to_non_nullable
                  as int,
        rooms: null == rooms
            ? _value.rooms
            : rooms // ignore: cast_nullable_to_non_nullable
                  as int,
        kind: null == kind
            ? _value.kind
            : kind // ignore: cast_nullable_to_non_nullable
                  as String,
        departCode: null == departCode
            ? _value.departCode
            : departCode // ignore: cast_nullable_to_non_nullable
                  as String,
        arrivalCode: null == arrivalCode
            ? _value.arrivalCode
            : arrivalCode // ignore: cast_nullable_to_non_nullable
                  as String,
        departDate: null == departDate
            ? _value.departDate
            : departDate // ignore: cast_nullable_to_non_nullable
                  as String,
        returnDate: freezed == returnDate
            ? _value.returnDate
            : returnDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        prices: null == prices
            ? _value.prices
            : prices // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingOutImpl implements _BookingOut {
  const _$BookingOutImpl({
    required this.id,
    @JsonKey(name: 'user_id') required this.userId,
    required this.destination,
    @JsonKey(name: 'trip_date_range') required this.tripDateRange,
    @JsonKey(name: 'destination_code') required this.destinationCode,
    @JsonKey(name: 'passenger_cnt') required this.passengerCnt,
    required this.adult,
    required this.children,
    @JsonKey(name: 'infant_lap') required this.infantLap,
    @JsonKey(name: 'infant_seat') required this.infantSeat,
    @JsonKey(name: 'cabin_idx') required this.cabinIdx,
    required this.rooms,
    required this.kind,
    @JsonKey(name: 'depart_code') required this.departCode,
    @JsonKey(name: 'arrival_code') required this.arrivalCode,
    @JsonKey(name: 'depart_date') required this.departDate,
    @JsonKey(name: 'return_date') this.returnDate,
    required this.prices,
    @JsonKey(name: 'created_at') required this.createdAt,
  });

  factory _$BookingOutImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingOutImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'user_id')
  final int userId;
  @override
  final String destination;
  @override
  @JsonKey(name: 'trip_date_range')
  final String tripDateRange;
  @override
  @JsonKey(name: 'destination_code')
  final String destinationCode;
  @override
  @JsonKey(name: 'passenger_cnt')
  final int passengerCnt;
  @override
  final int adult;
  @override
  final int children;
  @override
  @JsonKey(name: 'infant_lap')
  final int infantLap;
  @override
  @JsonKey(name: 'infant_seat')
  final int infantSeat;
  @override
  @JsonKey(name: 'cabin_idx')
  final int cabinIdx;
  @override
  final int rooms;
  @override
  final String kind;
  @override
  @JsonKey(name: 'depart_code')
  final String departCode;
  @override
  @JsonKey(name: 'arrival_code')
  final String arrivalCode;
  @override
  @JsonKey(name: 'depart_date')
  final String departDate;
  @override
  @JsonKey(name: 'return_date')
  final String? returnDate;

  /// Server returns an int (total price in minor units or currency’s base)
  @override
  final int prices;

  /// ISO8601 -> DateTime
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  String toString() {
    return 'BookingOut(id: $id, userId: $userId, destination: $destination, tripDateRange: $tripDateRange, destinationCode: $destinationCode, passengerCnt: $passengerCnt, adult: $adult, children: $children, infantLap: $infantLap, infantSeat: $infantSeat, cabinIdx: $cabinIdx, rooms: $rooms, kind: $kind, departCode: $departCode, arrivalCode: $arrivalCode, departDate: $departDate, returnDate: $returnDate, prices: $prices, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingOutImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.destination, destination) ||
                other.destination == destination) &&
            (identical(other.tripDateRange, tripDateRange) ||
                other.tripDateRange == tripDateRange) &&
            (identical(other.destinationCode, destinationCode) ||
                other.destinationCode == destinationCode) &&
            (identical(other.passengerCnt, passengerCnt) ||
                other.passengerCnt == passengerCnt) &&
            (identical(other.adult, adult) || other.adult == adult) &&
            (identical(other.children, children) ||
                other.children == children) &&
            (identical(other.infantLap, infantLap) ||
                other.infantLap == infantLap) &&
            (identical(other.infantSeat, infantSeat) ||
                other.infantSeat == infantSeat) &&
            (identical(other.cabinIdx, cabinIdx) ||
                other.cabinIdx == cabinIdx) &&
            (identical(other.rooms, rooms) || other.rooms == rooms) &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.departCode, departCode) ||
                other.departCode == departCode) &&
            (identical(other.arrivalCode, arrivalCode) ||
                other.arrivalCode == arrivalCode) &&
            (identical(other.departDate, departDate) ||
                other.departDate == departDate) &&
            (identical(other.returnDate, returnDate) ||
                other.returnDate == returnDate) &&
            (identical(other.prices, prices) || other.prices == prices) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    userId,
    destination,
    tripDateRange,
    destinationCode,
    passengerCnt,
    adult,
    children,
    infantLap,
    infantSeat,
    cabinIdx,
    rooms,
    kind,
    departCode,
    arrivalCode,
    departDate,
    returnDate,
    prices,
    createdAt,
  ]);

  /// Create a copy of BookingOut
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingOutImplCopyWith<_$BookingOutImpl> get copyWith =>
      __$$BookingOutImplCopyWithImpl<_$BookingOutImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingOutImplToJson(this);
  }
}

abstract class _BookingOut implements BookingOut {
  const factory _BookingOut({
    required final int id,
    @JsonKey(name: 'user_id') required final int userId,
    required final String destination,
    @JsonKey(name: 'trip_date_range') required final String tripDateRange,
    @JsonKey(name: 'destination_code') required final String destinationCode,
    @JsonKey(name: 'passenger_cnt') required final int passengerCnt,
    required final int adult,
    required final int children,
    @JsonKey(name: 'infant_lap') required final int infantLap,
    @JsonKey(name: 'infant_seat') required final int infantSeat,
    @JsonKey(name: 'cabin_idx') required final int cabinIdx,
    required final int rooms,
    required final String kind,
    @JsonKey(name: 'depart_code') required final String departCode,
    @JsonKey(name: 'arrival_code') required final String arrivalCode,
    @JsonKey(name: 'depart_date') required final String departDate,
    @JsonKey(name: 'return_date') final String? returnDate,
    required final int prices,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
  }) = _$BookingOutImpl;

  factory _BookingOut.fromJson(Map<String, dynamic> json) =
      _$BookingOutImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'user_id')
  int get userId;
  @override
  String get destination;
  @override
  @JsonKey(name: 'trip_date_range')
  String get tripDateRange;
  @override
  @JsonKey(name: 'destination_code')
  String get destinationCode;
  @override
  @JsonKey(name: 'passenger_cnt')
  int get passengerCnt;
  @override
  int get adult;
  @override
  int get children;
  @override
  @JsonKey(name: 'infant_lap')
  int get infantLap;
  @override
  @JsonKey(name: 'infant_seat')
  int get infantSeat;
  @override
  @JsonKey(name: 'cabin_idx')
  int get cabinIdx;
  @override
  int get rooms;
  @override
  String get kind;
  @override
  @JsonKey(name: 'depart_code')
  String get departCode;
  @override
  @JsonKey(name: 'arrival_code')
  String get arrivalCode;
  @override
  @JsonKey(name: 'depart_date')
  String get departDate;
  @override
  @JsonKey(name: 'return_date')
  String? get returnDate;

  /// Server returns an int (total price in minor units or currency’s base)
  @override
  int get prices;

  /// ISO8601 -> DateTime
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// Create a copy of BookingOut
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingOutImplCopyWith<_$BookingOutImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
