// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_in.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BookingIn _$BookingInFromJson(Map<String, dynamic> json) {
  return _BookingIn.fromJson(json);
}

/// @nodoc
mixin _$BookingIn {
  // 🔥 Moved annotations above each parameter
  @JsonKey(name: 'trip_date_range')
  String get tripDateRange => throw _privateConstructorUsedError;
  @JsonKey(name: 'destination_code')
  String get destinationCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'passenger_cnt')
  int get passengerCnt => throw _privateConstructorUsedError;
  @JsonKey(name: 'infant_lap')
  int get infantLap => throw _privateConstructorUsedError;
  @JsonKey(name: 'infant_seat')
  int get infantSeat => throw _privateConstructorUsedError;
  @JsonKey(name: 'cabin_idx')
  int get cabinIdx => throw _privateConstructorUsedError;
  @JsonKey(name: 'depart_code')
  String get departCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'arrival_code')
  String get arrivalCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'depart_date')
  String get departDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'return_date')
  String? get returnDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'prices')
  String? get prices => throw _privateConstructorUsedError;
  String get destination => throw _privateConstructorUsedError;
  int get adult => throw _privateConstructorUsedError;
  int get children => throw _privateConstructorUsedError;
  int get rooms => throw _privateConstructorUsedError;
  String get kind => throw _privateConstructorUsedError;

  /// Serializes this BookingIn to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookingIn
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingInCopyWith<BookingIn> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingInCopyWith<$Res> {
  factory $BookingInCopyWith(BookingIn value, $Res Function(BookingIn) then) =
      _$BookingInCopyWithImpl<$Res, BookingIn>;
  @useResult
  $Res call({
    @JsonKey(name: 'trip_date_range') String tripDateRange,
    @JsonKey(name: 'destination_code') String destinationCode,
    @JsonKey(name: 'passenger_cnt') int passengerCnt,
    @JsonKey(name: 'infant_lap') int infantLap,
    @JsonKey(name: 'infant_seat') int infantSeat,
    @JsonKey(name: 'cabin_idx') int cabinIdx,
    @JsonKey(name: 'depart_code') String departCode,
    @JsonKey(name: 'arrival_code') String arrivalCode,
    @JsonKey(name: 'depart_date') String departDate,
    @JsonKey(name: 'return_date') String? returnDate,
    @JsonKey(name: 'prices') String? prices,
    String destination,
    int adult,
    int children,
    int rooms,
    String kind,
  });
}

/// @nodoc
class _$BookingInCopyWithImpl<$Res, $Val extends BookingIn>
    implements $BookingInCopyWith<$Res> {
  _$BookingInCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingIn
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tripDateRange = null,
    Object? destinationCode = null,
    Object? passengerCnt = null,
    Object? infantLap = null,
    Object? infantSeat = null,
    Object? cabinIdx = null,
    Object? departCode = null,
    Object? arrivalCode = null,
    Object? departDate = null,
    Object? returnDate = freezed,
    Object? prices = freezed,
    Object? destination = null,
    Object? adult = null,
    Object? children = null,
    Object? rooms = null,
    Object? kind = null,
  }) {
    return _then(
      _value.copyWith(
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
            prices: freezed == prices
                ? _value.prices
                : prices // ignore: cast_nullable_to_non_nullable
                      as String?,
            destination: null == destination
                ? _value.destination
                : destination // ignore: cast_nullable_to_non_nullable
                      as String,
            adult: null == adult
                ? _value.adult
                : adult // ignore: cast_nullable_to_non_nullable
                      as int,
            children: null == children
                ? _value.children
                : children // ignore: cast_nullable_to_non_nullable
                      as int,
            rooms: null == rooms
                ? _value.rooms
                : rooms // ignore: cast_nullable_to_non_nullable
                      as int,
            kind: null == kind
                ? _value.kind
                : kind // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BookingInImplCopyWith<$Res>
    implements $BookingInCopyWith<$Res> {
  factory _$$BookingInImplCopyWith(
    _$BookingInImpl value,
    $Res Function(_$BookingInImpl) then,
  ) = __$$BookingInImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'trip_date_range') String tripDateRange,
    @JsonKey(name: 'destination_code') String destinationCode,
    @JsonKey(name: 'passenger_cnt') int passengerCnt,
    @JsonKey(name: 'infant_lap') int infantLap,
    @JsonKey(name: 'infant_seat') int infantSeat,
    @JsonKey(name: 'cabin_idx') int cabinIdx,
    @JsonKey(name: 'depart_code') String departCode,
    @JsonKey(name: 'arrival_code') String arrivalCode,
    @JsonKey(name: 'depart_date') String departDate,
    @JsonKey(name: 'return_date') String? returnDate,
    @JsonKey(name: 'prices') String? prices,
    String destination,
    int adult,
    int children,
    int rooms,
    String kind,
  });
}

/// @nodoc
class __$$BookingInImplCopyWithImpl<$Res>
    extends _$BookingInCopyWithImpl<$Res, _$BookingInImpl>
    implements _$$BookingInImplCopyWith<$Res> {
  __$$BookingInImplCopyWithImpl(
    _$BookingInImpl _value,
    $Res Function(_$BookingInImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookingIn
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tripDateRange = null,
    Object? destinationCode = null,
    Object? passengerCnt = null,
    Object? infantLap = null,
    Object? infantSeat = null,
    Object? cabinIdx = null,
    Object? departCode = null,
    Object? arrivalCode = null,
    Object? departDate = null,
    Object? returnDate = freezed,
    Object? prices = freezed,
    Object? destination = null,
    Object? adult = null,
    Object? children = null,
    Object? rooms = null,
    Object? kind = null,
  }) {
    return _then(
      _$BookingInImpl(
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
        prices: freezed == prices
            ? _value.prices
            : prices // ignore: cast_nullable_to_non_nullable
                  as String?,
        destination: null == destination
            ? _value.destination
            : destination // ignore: cast_nullable_to_non_nullable
                  as String,
        adult: null == adult
            ? _value.adult
            : adult // ignore: cast_nullable_to_non_nullable
                  as int,
        children: null == children
            ? _value.children
            : children // ignore: cast_nullable_to_non_nullable
                  as int,
        rooms: null == rooms
            ? _value.rooms
            : rooms // ignore: cast_nullable_to_non_nullable
                  as int,
        kind: null == kind
            ? _value.kind
            : kind // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingInImpl implements _BookingIn {
  const _$BookingInImpl({
    @JsonKey(name: 'trip_date_range') required this.tripDateRange,
    @JsonKey(name: 'destination_code') required this.destinationCode,
    @JsonKey(name: 'passenger_cnt') required this.passengerCnt,
    @JsonKey(name: 'infant_lap') required this.infantLap,
    @JsonKey(name: 'infant_seat') required this.infantSeat,
    @JsonKey(name: 'cabin_idx') required this.cabinIdx,
    @JsonKey(name: 'depart_code') required this.departCode,
    @JsonKey(name: 'arrival_code') required this.arrivalCode,
    @JsonKey(name: 'depart_date') required this.departDate,
    @JsonKey(name: 'return_date') this.returnDate,
    @JsonKey(name: 'prices') required this.prices,
    required this.destination,
    required this.adult,
    required this.children,
    required this.rooms,
    required this.kind,
  });

  factory _$BookingInImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingInImplFromJson(json);

  // 🔥 Moved annotations above each parameter
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
  @JsonKey(name: 'infant_lap')
  final int infantLap;
  @override
  @JsonKey(name: 'infant_seat')
  final int infantSeat;
  @override
  @JsonKey(name: 'cabin_idx')
  final int cabinIdx;
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
  @override
  @JsonKey(name: 'prices')
  final String? prices;
  @override
  final String destination;
  @override
  final int adult;
  @override
  final int children;
  @override
  final int rooms;
  @override
  final String kind;

  @override
  String toString() {
    return 'BookingIn(tripDateRange: $tripDateRange, destinationCode: $destinationCode, passengerCnt: $passengerCnt, infantLap: $infantLap, infantSeat: $infantSeat, cabinIdx: $cabinIdx, departCode: $departCode, arrivalCode: $arrivalCode, departDate: $departDate, returnDate: $returnDate, prices: $prices, destination: $destination, adult: $adult, children: $children, rooms: $rooms, kind: $kind)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingInImpl &&
            (identical(other.tripDateRange, tripDateRange) ||
                other.tripDateRange == tripDateRange) &&
            (identical(other.destinationCode, destinationCode) ||
                other.destinationCode == destinationCode) &&
            (identical(other.passengerCnt, passengerCnt) ||
                other.passengerCnt == passengerCnt) &&
            (identical(other.infantLap, infantLap) ||
                other.infantLap == infantLap) &&
            (identical(other.infantSeat, infantSeat) ||
                other.infantSeat == infantSeat) &&
            (identical(other.cabinIdx, cabinIdx) ||
                other.cabinIdx == cabinIdx) &&
            (identical(other.departCode, departCode) ||
                other.departCode == departCode) &&
            (identical(other.arrivalCode, arrivalCode) ||
                other.arrivalCode == arrivalCode) &&
            (identical(other.departDate, departDate) ||
                other.departDate == departDate) &&
            (identical(other.returnDate, returnDate) ||
                other.returnDate == returnDate) &&
            (identical(other.prices, prices) || other.prices == prices) &&
            (identical(other.destination, destination) ||
                other.destination == destination) &&
            (identical(other.adult, adult) || other.adult == adult) &&
            (identical(other.children, children) ||
                other.children == children) &&
            (identical(other.rooms, rooms) || other.rooms == rooms) &&
            (identical(other.kind, kind) || other.kind == kind));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    tripDateRange,
    destinationCode,
    passengerCnt,
    infantLap,
    infantSeat,
    cabinIdx,
    departCode,
    arrivalCode,
    departDate,
    returnDate,
    prices,
    destination,
    adult,
    children,
    rooms,
    kind,
  );

  /// Create a copy of BookingIn
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingInImplCopyWith<_$BookingInImpl> get copyWith =>
      __$$BookingInImplCopyWithImpl<_$BookingInImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingInImplToJson(this);
  }
}

abstract class _BookingIn implements BookingIn {
  const factory _BookingIn({
    @JsonKey(name: 'trip_date_range') required final String tripDateRange,
    @JsonKey(name: 'destination_code') required final String destinationCode,
    @JsonKey(name: 'passenger_cnt') required final int passengerCnt,
    @JsonKey(name: 'infant_lap') required final int infantLap,
    @JsonKey(name: 'infant_seat') required final int infantSeat,
    @JsonKey(name: 'cabin_idx') required final int cabinIdx,
    @JsonKey(name: 'depart_code') required final String departCode,
    @JsonKey(name: 'arrival_code') required final String arrivalCode,
    @JsonKey(name: 'depart_date') required final String departDate,
    @JsonKey(name: 'return_date') final String? returnDate,
    @JsonKey(name: 'prices') required final String? prices,
    required final String destination,
    required final int adult,
    required final int children,
    required final int rooms,
    required final String kind,
  }) = _$BookingInImpl;

  factory _BookingIn.fromJson(Map<String, dynamic> json) =
      _$BookingInImpl.fromJson;

  // 🔥 Moved annotations above each parameter
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
  @JsonKey(name: 'infant_lap')
  int get infantLap;
  @override
  @JsonKey(name: 'infant_seat')
  int get infantSeat;
  @override
  @JsonKey(name: 'cabin_idx')
  int get cabinIdx;
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
  @override
  @JsonKey(name: 'prices')
  String? get prices;
  @override
  String get destination;
  @override
  int get adult;
  @override
  int get children;
  @override
  int get rooms;
  @override
  String get kind;

  /// Create a copy of BookingIn
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingInImplCopyWith<_$BookingInImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
