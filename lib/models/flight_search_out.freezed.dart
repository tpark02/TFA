// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'flight_search_out.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FlightSearchOut _$FlightSearchOutFromJson(Map<String, dynamic> json) {
  return _FlightSearchOut.fromJson(json);
}

/// @nodoc
mixin _$FlightSearchOut {
  Meta? get meta => throw _privateConstructorUsedError;
  List<FlightOffer>? get data => throw _privateConstructorUsedError;
  Dictionaries? get dictionaries => throw _privateConstructorUsedError;

  /// Serializes this FlightSearchOut to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FlightSearchOut
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FlightSearchOutCopyWith<FlightSearchOut> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FlightSearchOutCopyWith<$Res> {
  factory $FlightSearchOutCopyWith(
    FlightSearchOut value,
    $Res Function(FlightSearchOut) then,
  ) = _$FlightSearchOutCopyWithImpl<$Res, FlightSearchOut>;
  @useResult
  $Res call({Meta? meta, List<FlightOffer>? data, Dictionaries? dictionaries});

  $MetaCopyWith<$Res>? get meta;
  $DictionariesCopyWith<$Res>? get dictionaries;
}

/// @nodoc
class _$FlightSearchOutCopyWithImpl<$Res, $Val extends FlightSearchOut>
    implements $FlightSearchOutCopyWith<$Res> {
  _$FlightSearchOutCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FlightSearchOut
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? meta = freezed,
    Object? data = freezed,
    Object? dictionaries = freezed,
  }) {
    return _then(
      _value.copyWith(
            meta: freezed == meta
                ? _value.meta
                : meta // ignore: cast_nullable_to_non_nullable
                      as Meta?,
            data: freezed == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as List<FlightOffer>?,
            dictionaries: freezed == dictionaries
                ? _value.dictionaries
                : dictionaries // ignore: cast_nullable_to_non_nullable
                      as Dictionaries?,
          )
          as $Val,
    );
  }

  /// Create a copy of FlightSearchOut
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MetaCopyWith<$Res>? get meta {
    if (_value.meta == null) {
      return null;
    }

    return $MetaCopyWith<$Res>(_value.meta!, (value) {
      return _then(_value.copyWith(meta: value) as $Val);
    });
  }

  /// Create a copy of FlightSearchOut
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DictionariesCopyWith<$Res>? get dictionaries {
    if (_value.dictionaries == null) {
      return null;
    }

    return $DictionariesCopyWith<$Res>(_value.dictionaries!, (value) {
      return _then(_value.copyWith(dictionaries: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FlightSearchOutImplCopyWith<$Res>
    implements $FlightSearchOutCopyWith<$Res> {
  factory _$$FlightSearchOutImplCopyWith(
    _$FlightSearchOutImpl value,
    $Res Function(_$FlightSearchOutImpl) then,
  ) = __$$FlightSearchOutImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Meta? meta, List<FlightOffer>? data, Dictionaries? dictionaries});

  @override
  $MetaCopyWith<$Res>? get meta;
  @override
  $DictionariesCopyWith<$Res>? get dictionaries;
}

/// @nodoc
class __$$FlightSearchOutImplCopyWithImpl<$Res>
    extends _$FlightSearchOutCopyWithImpl<$Res, _$FlightSearchOutImpl>
    implements _$$FlightSearchOutImplCopyWith<$Res> {
  __$$FlightSearchOutImplCopyWithImpl(
    _$FlightSearchOutImpl _value,
    $Res Function(_$FlightSearchOutImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FlightSearchOut
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? meta = freezed,
    Object? data = freezed,
    Object? dictionaries = freezed,
  }) {
    return _then(
      _$FlightSearchOutImpl(
        meta: freezed == meta
            ? _value.meta
            : meta // ignore: cast_nullable_to_non_nullable
                  as Meta?,
        data: freezed == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as List<FlightOffer>?,
        dictionaries: freezed == dictionaries
            ? _value.dictionaries
            : dictionaries // ignore: cast_nullable_to_non_nullable
                  as Dictionaries?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FlightSearchOutImpl implements _FlightSearchOut {
  const _$FlightSearchOutImpl({
    this.meta,
    final List<FlightOffer>? data,
    this.dictionaries,
  }) : _data = data;

  factory _$FlightSearchOutImpl.fromJson(Map<String, dynamic> json) =>
      _$$FlightSearchOutImplFromJson(json);

  @override
  final Meta? meta;
  final List<FlightOffer>? _data;
  @override
  List<FlightOffer>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final Dictionaries? dictionaries;

  @override
  String toString() {
    return 'FlightSearchOut(meta: $meta, data: $data, dictionaries: $dictionaries)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FlightSearchOutImpl &&
            (identical(other.meta, meta) || other.meta == meta) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.dictionaries, dictionaries) ||
                other.dictionaries == dictionaries));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    meta,
    const DeepCollectionEquality().hash(_data),
    dictionaries,
  );

  /// Create a copy of FlightSearchOut
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FlightSearchOutImplCopyWith<_$FlightSearchOutImpl> get copyWith =>
      __$$FlightSearchOutImplCopyWithImpl<_$FlightSearchOutImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FlightSearchOutImplToJson(this);
  }
}

abstract class _FlightSearchOut implements FlightSearchOut {
  const factory _FlightSearchOut({
    final Meta? meta,
    final List<FlightOffer>? data,
    final Dictionaries? dictionaries,
  }) = _$FlightSearchOutImpl;

  factory _FlightSearchOut.fromJson(Map<String, dynamic> json) =
      _$FlightSearchOutImpl.fromJson;

  @override
  Meta? get meta;
  @override
  List<FlightOffer>? get data;
  @override
  Dictionaries? get dictionaries;

  /// Create a copy of FlightSearchOut
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FlightSearchOutImplCopyWith<_$FlightSearchOutImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Meta _$MetaFromJson(Map<String, dynamic> json) {
  return _Meta.fromJson(json);
}

/// @nodoc
mixin _$Meta {
  int? get count => throw _privateConstructorUsedError;
  MetaLinks? get links => throw _privateConstructorUsedError;

  /// Serializes this Meta to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Meta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MetaCopyWith<Meta> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MetaCopyWith<$Res> {
  factory $MetaCopyWith(Meta value, $Res Function(Meta) then) =
      _$MetaCopyWithImpl<$Res, Meta>;
  @useResult
  $Res call({int? count, MetaLinks? links});

  $MetaLinksCopyWith<$Res>? get links;
}

/// @nodoc
class _$MetaCopyWithImpl<$Res, $Val extends Meta>
    implements $MetaCopyWith<$Res> {
  _$MetaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Meta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? count = freezed, Object? links = freezed}) {
    return _then(
      _value.copyWith(
            count: freezed == count
                ? _value.count
                : count // ignore: cast_nullable_to_non_nullable
                      as int?,
            links: freezed == links
                ? _value.links
                : links // ignore: cast_nullable_to_non_nullable
                      as MetaLinks?,
          )
          as $Val,
    );
  }

  /// Create a copy of Meta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MetaLinksCopyWith<$Res>? get links {
    if (_value.links == null) {
      return null;
    }

    return $MetaLinksCopyWith<$Res>(_value.links!, (value) {
      return _then(_value.copyWith(links: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MetaImplCopyWith<$Res> implements $MetaCopyWith<$Res> {
  factory _$$MetaImplCopyWith(
    _$MetaImpl value,
    $Res Function(_$MetaImpl) then,
  ) = __$$MetaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? count, MetaLinks? links});

  @override
  $MetaLinksCopyWith<$Res>? get links;
}

/// @nodoc
class __$$MetaImplCopyWithImpl<$Res>
    extends _$MetaCopyWithImpl<$Res, _$MetaImpl>
    implements _$$MetaImplCopyWith<$Res> {
  __$$MetaImplCopyWithImpl(_$MetaImpl _value, $Res Function(_$MetaImpl) _then)
    : super(_value, _then);

  /// Create a copy of Meta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? count = freezed, Object? links = freezed}) {
    return _then(
      _$MetaImpl(
        count: freezed == count
            ? _value.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int?,
        links: freezed == links
            ? _value.links
            : links // ignore: cast_nullable_to_non_nullable
                  as MetaLinks?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MetaImpl implements _Meta {
  const _$MetaImpl({this.count, this.links});

  factory _$MetaImpl.fromJson(Map<String, dynamic> json) =>
      _$$MetaImplFromJson(json);

  @override
  final int? count;
  @override
  final MetaLinks? links;

  @override
  String toString() {
    return 'Meta(count: $count, links: $links)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetaImpl &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.links, links) || other.links == links));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, count, links);

  /// Create a copy of Meta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetaImplCopyWith<_$MetaImpl> get copyWith =>
      __$$MetaImplCopyWithImpl<_$MetaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MetaImplToJson(this);
  }
}

abstract class _Meta implements Meta {
  const factory _Meta({final int? count, final MetaLinks? links}) = _$MetaImpl;

  factory _Meta.fromJson(Map<String, dynamic> json) = _$MetaImpl.fromJson;

  @override
  int? get count;
  @override
  MetaLinks? get links;

  /// Create a copy of Meta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetaImplCopyWith<_$MetaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MetaLinks _$MetaLinksFromJson(Map<String, dynamic> json) {
  return _MetaLinks.fromJson(json);
}

/// @nodoc
mixin _$MetaLinks {
  String? get self => throw _privateConstructorUsedError;

  /// Serializes this MetaLinks to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MetaLinks
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MetaLinksCopyWith<MetaLinks> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MetaLinksCopyWith<$Res> {
  factory $MetaLinksCopyWith(MetaLinks value, $Res Function(MetaLinks) then) =
      _$MetaLinksCopyWithImpl<$Res, MetaLinks>;
  @useResult
  $Res call({String? self});
}

/// @nodoc
class _$MetaLinksCopyWithImpl<$Res, $Val extends MetaLinks>
    implements $MetaLinksCopyWith<$Res> {
  _$MetaLinksCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MetaLinks
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? self = freezed}) {
    return _then(
      _value.copyWith(
            self: freezed == self
                ? _value.self
                : self // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MetaLinksImplCopyWith<$Res>
    implements $MetaLinksCopyWith<$Res> {
  factory _$$MetaLinksImplCopyWith(
    _$MetaLinksImpl value,
    $Res Function(_$MetaLinksImpl) then,
  ) = __$$MetaLinksImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? self});
}

/// @nodoc
class __$$MetaLinksImplCopyWithImpl<$Res>
    extends _$MetaLinksCopyWithImpl<$Res, _$MetaLinksImpl>
    implements _$$MetaLinksImplCopyWith<$Res> {
  __$$MetaLinksImplCopyWithImpl(
    _$MetaLinksImpl _value,
    $Res Function(_$MetaLinksImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MetaLinks
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? self = freezed}) {
    return _then(
      _$MetaLinksImpl(
        self: freezed == self
            ? _value.self
            : self // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MetaLinksImpl implements _MetaLinks {
  const _$MetaLinksImpl({this.self});

  factory _$MetaLinksImpl.fromJson(Map<String, dynamic> json) =>
      _$$MetaLinksImplFromJson(json);

  @override
  final String? self;

  @override
  String toString() {
    return 'MetaLinks(self: $self)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetaLinksImpl &&
            (identical(other.self, self) || other.self == self));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, self);

  /// Create a copy of MetaLinks
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetaLinksImplCopyWith<_$MetaLinksImpl> get copyWith =>
      __$$MetaLinksImplCopyWithImpl<_$MetaLinksImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MetaLinksImplToJson(this);
  }
}

abstract class _MetaLinks implements MetaLinks {
  const factory _MetaLinks({final String? self}) = _$MetaLinksImpl;

  factory _MetaLinks.fromJson(Map<String, dynamic> json) =
      _$MetaLinksImpl.fromJson;

  @override
  String? get self;

  /// Create a copy of MetaLinks
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetaLinksImplCopyWith<_$MetaLinksImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FlightOffer _$FlightOfferFromJson(Map<String, dynamic> json) {
  return _FlightOffer.fromJson(json);
}

/// @nodoc
mixin _$FlightOffer {
  String? get type => throw _privateConstructorUsedError;
  String? get id => throw _privateConstructorUsedError;
  String? get source => throw _privateConstructorUsedError;
  bool? get instantTicketingRequired => throw _privateConstructorUsedError;
  bool? get nonHomogeneous => throw _privateConstructorUsedError;
  bool? get oneWay => throw _privateConstructorUsedError;
  bool? get isUpsellOffer => throw _privateConstructorUsedError;
  String? get lastTicketingDate => throw _privateConstructorUsedError;
  String? get lastTicketingDateTime => throw _privateConstructorUsedError;
  int? get numberOfBookableSeats => throw _privateConstructorUsedError;
  List<Itinerary>? get itineraries => throw _privateConstructorUsedError;
  Price? get price => throw _privateConstructorUsedError;
  PricingOptions? get pricingOptions => throw _privateConstructorUsedError;
  List<String>? get validatingAirlineCodes =>
      throw _privateConstructorUsedError;
  List<TravelerPricing>? get travelerPricings =>
      throw _privateConstructorUsedError;

  /// Serializes this FlightOffer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FlightOffer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FlightOfferCopyWith<FlightOffer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FlightOfferCopyWith<$Res> {
  factory $FlightOfferCopyWith(
    FlightOffer value,
    $Res Function(FlightOffer) then,
  ) = _$FlightOfferCopyWithImpl<$Res, FlightOffer>;
  @useResult
  $Res call({
    String? type,
    String? id,
    String? source,
    bool? instantTicketingRequired,
    bool? nonHomogeneous,
    bool? oneWay,
    bool? isUpsellOffer,
    String? lastTicketingDate,
    String? lastTicketingDateTime,
    int? numberOfBookableSeats,
    List<Itinerary>? itineraries,
    Price? price,
    PricingOptions? pricingOptions,
    List<String>? validatingAirlineCodes,
    List<TravelerPricing>? travelerPricings,
  });

  $PriceCopyWith<$Res>? get price;
  $PricingOptionsCopyWith<$Res>? get pricingOptions;
}

/// @nodoc
class _$FlightOfferCopyWithImpl<$Res, $Val extends FlightOffer>
    implements $FlightOfferCopyWith<$Res> {
  _$FlightOfferCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FlightOffer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = freezed,
    Object? id = freezed,
    Object? source = freezed,
    Object? instantTicketingRequired = freezed,
    Object? nonHomogeneous = freezed,
    Object? oneWay = freezed,
    Object? isUpsellOffer = freezed,
    Object? lastTicketingDate = freezed,
    Object? lastTicketingDateTime = freezed,
    Object? numberOfBookableSeats = freezed,
    Object? itineraries = freezed,
    Object? price = freezed,
    Object? pricingOptions = freezed,
    Object? validatingAirlineCodes = freezed,
    Object? travelerPricings = freezed,
  }) {
    return _then(
      _value.copyWith(
            type: freezed == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String?,
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            source: freezed == source
                ? _value.source
                : source // ignore: cast_nullable_to_non_nullable
                      as String?,
            instantTicketingRequired: freezed == instantTicketingRequired
                ? _value.instantTicketingRequired
                : instantTicketingRequired // ignore: cast_nullable_to_non_nullable
                      as bool?,
            nonHomogeneous: freezed == nonHomogeneous
                ? _value.nonHomogeneous
                : nonHomogeneous // ignore: cast_nullable_to_non_nullable
                      as bool?,
            oneWay: freezed == oneWay
                ? _value.oneWay
                : oneWay // ignore: cast_nullable_to_non_nullable
                      as bool?,
            isUpsellOffer: freezed == isUpsellOffer
                ? _value.isUpsellOffer
                : isUpsellOffer // ignore: cast_nullable_to_non_nullable
                      as bool?,
            lastTicketingDate: freezed == lastTicketingDate
                ? _value.lastTicketingDate
                : lastTicketingDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastTicketingDateTime: freezed == lastTicketingDateTime
                ? _value.lastTicketingDateTime
                : lastTicketingDateTime // ignore: cast_nullable_to_non_nullable
                      as String?,
            numberOfBookableSeats: freezed == numberOfBookableSeats
                ? _value.numberOfBookableSeats
                : numberOfBookableSeats // ignore: cast_nullable_to_non_nullable
                      as int?,
            itineraries: freezed == itineraries
                ? _value.itineraries
                : itineraries // ignore: cast_nullable_to_non_nullable
                      as List<Itinerary>?,
            price: freezed == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as Price?,
            pricingOptions: freezed == pricingOptions
                ? _value.pricingOptions
                : pricingOptions // ignore: cast_nullable_to_non_nullable
                      as PricingOptions?,
            validatingAirlineCodes: freezed == validatingAirlineCodes
                ? _value.validatingAirlineCodes
                : validatingAirlineCodes // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            travelerPricings: freezed == travelerPricings
                ? _value.travelerPricings
                : travelerPricings // ignore: cast_nullable_to_non_nullable
                      as List<TravelerPricing>?,
          )
          as $Val,
    );
  }

  /// Create a copy of FlightOffer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PriceCopyWith<$Res>? get price {
    if (_value.price == null) {
      return null;
    }

    return $PriceCopyWith<$Res>(_value.price!, (value) {
      return _then(_value.copyWith(price: value) as $Val);
    });
  }

  /// Create a copy of FlightOffer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PricingOptionsCopyWith<$Res>? get pricingOptions {
    if (_value.pricingOptions == null) {
      return null;
    }

    return $PricingOptionsCopyWith<$Res>(_value.pricingOptions!, (value) {
      return _then(_value.copyWith(pricingOptions: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FlightOfferImplCopyWith<$Res>
    implements $FlightOfferCopyWith<$Res> {
  factory _$$FlightOfferImplCopyWith(
    _$FlightOfferImpl value,
    $Res Function(_$FlightOfferImpl) then,
  ) = __$$FlightOfferImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? type,
    String? id,
    String? source,
    bool? instantTicketingRequired,
    bool? nonHomogeneous,
    bool? oneWay,
    bool? isUpsellOffer,
    String? lastTicketingDate,
    String? lastTicketingDateTime,
    int? numberOfBookableSeats,
    List<Itinerary>? itineraries,
    Price? price,
    PricingOptions? pricingOptions,
    List<String>? validatingAirlineCodes,
    List<TravelerPricing>? travelerPricings,
  });

  @override
  $PriceCopyWith<$Res>? get price;
  @override
  $PricingOptionsCopyWith<$Res>? get pricingOptions;
}

/// @nodoc
class __$$FlightOfferImplCopyWithImpl<$Res>
    extends _$FlightOfferCopyWithImpl<$Res, _$FlightOfferImpl>
    implements _$$FlightOfferImplCopyWith<$Res> {
  __$$FlightOfferImplCopyWithImpl(
    _$FlightOfferImpl _value,
    $Res Function(_$FlightOfferImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FlightOffer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = freezed,
    Object? id = freezed,
    Object? source = freezed,
    Object? instantTicketingRequired = freezed,
    Object? nonHomogeneous = freezed,
    Object? oneWay = freezed,
    Object? isUpsellOffer = freezed,
    Object? lastTicketingDate = freezed,
    Object? lastTicketingDateTime = freezed,
    Object? numberOfBookableSeats = freezed,
    Object? itineraries = freezed,
    Object? price = freezed,
    Object? pricingOptions = freezed,
    Object? validatingAirlineCodes = freezed,
    Object? travelerPricings = freezed,
  }) {
    return _then(
      _$FlightOfferImpl(
        type: freezed == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String?,
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        source: freezed == source
            ? _value.source
            : source // ignore: cast_nullable_to_non_nullable
                  as String?,
        instantTicketingRequired: freezed == instantTicketingRequired
            ? _value.instantTicketingRequired
            : instantTicketingRequired // ignore: cast_nullable_to_non_nullable
                  as bool?,
        nonHomogeneous: freezed == nonHomogeneous
            ? _value.nonHomogeneous
            : nonHomogeneous // ignore: cast_nullable_to_non_nullable
                  as bool?,
        oneWay: freezed == oneWay
            ? _value.oneWay
            : oneWay // ignore: cast_nullable_to_non_nullable
                  as bool?,
        isUpsellOffer: freezed == isUpsellOffer
            ? _value.isUpsellOffer
            : isUpsellOffer // ignore: cast_nullable_to_non_nullable
                  as bool?,
        lastTicketingDate: freezed == lastTicketingDate
            ? _value.lastTicketingDate
            : lastTicketingDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastTicketingDateTime: freezed == lastTicketingDateTime
            ? _value.lastTicketingDateTime
            : lastTicketingDateTime // ignore: cast_nullable_to_non_nullable
                  as String?,
        numberOfBookableSeats: freezed == numberOfBookableSeats
            ? _value.numberOfBookableSeats
            : numberOfBookableSeats // ignore: cast_nullable_to_non_nullable
                  as int?,
        itineraries: freezed == itineraries
            ? _value._itineraries
            : itineraries // ignore: cast_nullable_to_non_nullable
                  as List<Itinerary>?,
        price: freezed == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as Price?,
        pricingOptions: freezed == pricingOptions
            ? _value.pricingOptions
            : pricingOptions // ignore: cast_nullable_to_non_nullable
                  as PricingOptions?,
        validatingAirlineCodes: freezed == validatingAirlineCodes
            ? _value._validatingAirlineCodes
            : validatingAirlineCodes // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        travelerPricings: freezed == travelerPricings
            ? _value._travelerPricings
            : travelerPricings // ignore: cast_nullable_to_non_nullable
                  as List<TravelerPricing>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FlightOfferImpl implements _FlightOffer {
  const _$FlightOfferImpl({
    this.type,
    this.id,
    this.source,
    this.instantTicketingRequired,
    this.nonHomogeneous,
    this.oneWay,
    this.isUpsellOffer,
    this.lastTicketingDate,
    this.lastTicketingDateTime,
    this.numberOfBookableSeats,
    final List<Itinerary>? itineraries,
    this.price,
    this.pricingOptions,
    final List<String>? validatingAirlineCodes,
    final List<TravelerPricing>? travelerPricings,
  }) : _itineraries = itineraries,
       _validatingAirlineCodes = validatingAirlineCodes,
       _travelerPricings = travelerPricings;

  factory _$FlightOfferImpl.fromJson(Map<String, dynamic> json) =>
      _$$FlightOfferImplFromJson(json);

  @override
  final String? type;
  @override
  final String? id;
  @override
  final String? source;
  @override
  final bool? instantTicketingRequired;
  @override
  final bool? nonHomogeneous;
  @override
  final bool? oneWay;
  @override
  final bool? isUpsellOffer;
  @override
  final String? lastTicketingDate;
  @override
  final String? lastTicketingDateTime;
  @override
  final int? numberOfBookableSeats;
  final List<Itinerary>? _itineraries;
  @override
  List<Itinerary>? get itineraries {
    final value = _itineraries;
    if (value == null) return null;
    if (_itineraries is EqualUnmodifiableListView) return _itineraries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final Price? price;
  @override
  final PricingOptions? pricingOptions;
  final List<String>? _validatingAirlineCodes;
  @override
  List<String>? get validatingAirlineCodes {
    final value = _validatingAirlineCodes;
    if (value == null) return null;
    if (_validatingAirlineCodes is EqualUnmodifiableListView)
      return _validatingAirlineCodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<TravelerPricing>? _travelerPricings;
  @override
  List<TravelerPricing>? get travelerPricings {
    final value = _travelerPricings;
    if (value == null) return null;
    if (_travelerPricings is EqualUnmodifiableListView)
      return _travelerPricings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'FlightOffer(type: $type, id: $id, source: $source, instantTicketingRequired: $instantTicketingRequired, nonHomogeneous: $nonHomogeneous, oneWay: $oneWay, isUpsellOffer: $isUpsellOffer, lastTicketingDate: $lastTicketingDate, lastTicketingDateTime: $lastTicketingDateTime, numberOfBookableSeats: $numberOfBookableSeats, itineraries: $itineraries, price: $price, pricingOptions: $pricingOptions, validatingAirlineCodes: $validatingAirlineCodes, travelerPricings: $travelerPricings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FlightOfferImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(
                  other.instantTicketingRequired,
                  instantTicketingRequired,
                ) ||
                other.instantTicketingRequired == instantTicketingRequired) &&
            (identical(other.nonHomogeneous, nonHomogeneous) ||
                other.nonHomogeneous == nonHomogeneous) &&
            (identical(other.oneWay, oneWay) || other.oneWay == oneWay) &&
            (identical(other.isUpsellOffer, isUpsellOffer) ||
                other.isUpsellOffer == isUpsellOffer) &&
            (identical(other.lastTicketingDate, lastTicketingDate) ||
                other.lastTicketingDate == lastTicketingDate) &&
            (identical(other.lastTicketingDateTime, lastTicketingDateTime) ||
                other.lastTicketingDateTime == lastTicketingDateTime) &&
            (identical(other.numberOfBookableSeats, numberOfBookableSeats) ||
                other.numberOfBookableSeats == numberOfBookableSeats) &&
            const DeepCollectionEquality().equals(
              other._itineraries,
              _itineraries,
            ) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.pricingOptions, pricingOptions) ||
                other.pricingOptions == pricingOptions) &&
            const DeepCollectionEquality().equals(
              other._validatingAirlineCodes,
              _validatingAirlineCodes,
            ) &&
            const DeepCollectionEquality().equals(
              other._travelerPricings,
              _travelerPricings,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    type,
    id,
    source,
    instantTicketingRequired,
    nonHomogeneous,
    oneWay,
    isUpsellOffer,
    lastTicketingDate,
    lastTicketingDateTime,
    numberOfBookableSeats,
    const DeepCollectionEquality().hash(_itineraries),
    price,
    pricingOptions,
    const DeepCollectionEquality().hash(_validatingAirlineCodes),
    const DeepCollectionEquality().hash(_travelerPricings),
  );

  /// Create a copy of FlightOffer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FlightOfferImplCopyWith<_$FlightOfferImpl> get copyWith =>
      __$$FlightOfferImplCopyWithImpl<_$FlightOfferImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FlightOfferImplToJson(this);
  }
}

abstract class _FlightOffer implements FlightOffer {
  const factory _FlightOffer({
    final String? type,
    final String? id,
    final String? source,
    final bool? instantTicketingRequired,
    final bool? nonHomogeneous,
    final bool? oneWay,
    final bool? isUpsellOffer,
    final String? lastTicketingDate,
    final String? lastTicketingDateTime,
    final int? numberOfBookableSeats,
    final List<Itinerary>? itineraries,
    final Price? price,
    final PricingOptions? pricingOptions,
    final List<String>? validatingAirlineCodes,
    final List<TravelerPricing>? travelerPricings,
  }) = _$FlightOfferImpl;

  factory _FlightOffer.fromJson(Map<String, dynamic> json) =
      _$FlightOfferImpl.fromJson;

  @override
  String? get type;
  @override
  String? get id;
  @override
  String? get source;
  @override
  bool? get instantTicketingRequired;
  @override
  bool? get nonHomogeneous;
  @override
  bool? get oneWay;
  @override
  bool? get isUpsellOffer;
  @override
  String? get lastTicketingDate;
  @override
  String? get lastTicketingDateTime;
  @override
  int? get numberOfBookableSeats;
  @override
  List<Itinerary>? get itineraries;
  @override
  Price? get price;
  @override
  PricingOptions? get pricingOptions;
  @override
  List<String>? get validatingAirlineCodes;
  @override
  List<TravelerPricing>? get travelerPricings;

  /// Create a copy of FlightOffer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FlightOfferImplCopyWith<_$FlightOfferImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Itinerary _$ItineraryFromJson(Map<String, dynamic> json) {
  return _Itinerary.fromJson(json);
}

/// @nodoc
mixin _$Itinerary {
  String? get duration => throw _privateConstructorUsedError;
  List<Segment>? get segments => throw _privateConstructorUsedError;

  /// Serializes this Itinerary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Itinerary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ItineraryCopyWith<Itinerary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ItineraryCopyWith<$Res> {
  factory $ItineraryCopyWith(Itinerary value, $Res Function(Itinerary) then) =
      _$ItineraryCopyWithImpl<$Res, Itinerary>;
  @useResult
  $Res call({String? duration, List<Segment>? segments});
}

/// @nodoc
class _$ItineraryCopyWithImpl<$Res, $Val extends Itinerary>
    implements $ItineraryCopyWith<$Res> {
  _$ItineraryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Itinerary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? duration = freezed, Object? segments = freezed}) {
    return _then(
      _value.copyWith(
            duration: freezed == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                      as String?,
            segments: freezed == segments
                ? _value.segments
                : segments // ignore: cast_nullable_to_non_nullable
                      as List<Segment>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ItineraryImplCopyWith<$Res>
    implements $ItineraryCopyWith<$Res> {
  factory _$$ItineraryImplCopyWith(
    _$ItineraryImpl value,
    $Res Function(_$ItineraryImpl) then,
  ) = __$$ItineraryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? duration, List<Segment>? segments});
}

/// @nodoc
class __$$ItineraryImplCopyWithImpl<$Res>
    extends _$ItineraryCopyWithImpl<$Res, _$ItineraryImpl>
    implements _$$ItineraryImplCopyWith<$Res> {
  __$$ItineraryImplCopyWithImpl(
    _$ItineraryImpl _value,
    $Res Function(_$ItineraryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Itinerary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? duration = freezed, Object? segments = freezed}) {
    return _then(
      _$ItineraryImpl(
        duration: freezed == duration
            ? _value.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String?,
        segments: freezed == segments
            ? _value._segments
            : segments // ignore: cast_nullable_to_non_nullable
                  as List<Segment>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ItineraryImpl implements _Itinerary {
  const _$ItineraryImpl({this.duration, final List<Segment>? segments})
    : _segments = segments;

  factory _$ItineraryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ItineraryImplFromJson(json);

  @override
  final String? duration;
  final List<Segment>? _segments;
  @override
  List<Segment>? get segments {
    final value = _segments;
    if (value == null) return null;
    if (_segments is EqualUnmodifiableListView) return _segments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Itinerary(duration: $duration, segments: $segments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ItineraryImpl &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            const DeepCollectionEquality().equals(other._segments, _segments));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    duration,
    const DeepCollectionEquality().hash(_segments),
  );

  /// Create a copy of Itinerary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ItineraryImplCopyWith<_$ItineraryImpl> get copyWith =>
      __$$ItineraryImplCopyWithImpl<_$ItineraryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ItineraryImplToJson(this);
  }
}

abstract class _Itinerary implements Itinerary {
  const factory _Itinerary({
    final String? duration,
    final List<Segment>? segments,
  }) = _$ItineraryImpl;

  factory _Itinerary.fromJson(Map<String, dynamic> json) =
      _$ItineraryImpl.fromJson;

  @override
  String? get duration;
  @override
  List<Segment>? get segments;

  /// Create a copy of Itinerary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ItineraryImplCopyWith<_$ItineraryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Segment _$SegmentFromJson(Map<String, dynamic> json) {
  return _Segment.fromJson(json);
}

/// @nodoc
mixin _$Segment {
  DepartureArrival? get departure => throw _privateConstructorUsedError;
  DepartureArrival? get arrival => throw _privateConstructorUsedError;
  String? get carrierCode => throw _privateConstructorUsedError;
  String? get number => throw _privateConstructorUsedError;
  Aircraft? get aircraft => throw _privateConstructorUsedError;
  Operating? get operating => throw _privateConstructorUsedError;
  String? get duration => throw _privateConstructorUsedError;
  String? get id => throw _privateConstructorUsedError;
  int? get numberOfStops => throw _privateConstructorUsedError;
  bool? get blacklistedInEU => throw _privateConstructorUsedError;

  /// Serializes this Segment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Segment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SegmentCopyWith<Segment> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SegmentCopyWith<$Res> {
  factory $SegmentCopyWith(Segment value, $Res Function(Segment) then) =
      _$SegmentCopyWithImpl<$Res, Segment>;
  @useResult
  $Res call({
    DepartureArrival? departure,
    DepartureArrival? arrival,
    String? carrierCode,
    String? number,
    Aircraft? aircraft,
    Operating? operating,
    String? duration,
    String? id,
    int? numberOfStops,
    bool? blacklistedInEU,
  });

  $DepartureArrivalCopyWith<$Res>? get departure;
  $DepartureArrivalCopyWith<$Res>? get arrival;
  $AircraftCopyWith<$Res>? get aircraft;
  $OperatingCopyWith<$Res>? get operating;
}

/// @nodoc
class _$SegmentCopyWithImpl<$Res, $Val extends Segment>
    implements $SegmentCopyWith<$Res> {
  _$SegmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Segment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? departure = freezed,
    Object? arrival = freezed,
    Object? carrierCode = freezed,
    Object? number = freezed,
    Object? aircraft = freezed,
    Object? operating = freezed,
    Object? duration = freezed,
    Object? id = freezed,
    Object? numberOfStops = freezed,
    Object? blacklistedInEU = freezed,
  }) {
    return _then(
      _value.copyWith(
            departure: freezed == departure
                ? _value.departure
                : departure // ignore: cast_nullable_to_non_nullable
                      as DepartureArrival?,
            arrival: freezed == arrival
                ? _value.arrival
                : arrival // ignore: cast_nullable_to_non_nullable
                      as DepartureArrival?,
            carrierCode: freezed == carrierCode
                ? _value.carrierCode
                : carrierCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            number: freezed == number
                ? _value.number
                : number // ignore: cast_nullable_to_non_nullable
                      as String?,
            aircraft: freezed == aircraft
                ? _value.aircraft
                : aircraft // ignore: cast_nullable_to_non_nullable
                      as Aircraft?,
            operating: freezed == operating
                ? _value.operating
                : operating // ignore: cast_nullable_to_non_nullable
                      as Operating?,
            duration: freezed == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                      as String?,
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            numberOfStops: freezed == numberOfStops
                ? _value.numberOfStops
                : numberOfStops // ignore: cast_nullable_to_non_nullable
                      as int?,
            blacklistedInEU: freezed == blacklistedInEU
                ? _value.blacklistedInEU
                : blacklistedInEU // ignore: cast_nullable_to_non_nullable
                      as bool?,
          )
          as $Val,
    );
  }

  /// Create a copy of Segment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DepartureArrivalCopyWith<$Res>? get departure {
    if (_value.departure == null) {
      return null;
    }

    return $DepartureArrivalCopyWith<$Res>(_value.departure!, (value) {
      return _then(_value.copyWith(departure: value) as $Val);
    });
  }

  /// Create a copy of Segment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DepartureArrivalCopyWith<$Res>? get arrival {
    if (_value.arrival == null) {
      return null;
    }

    return $DepartureArrivalCopyWith<$Res>(_value.arrival!, (value) {
      return _then(_value.copyWith(arrival: value) as $Val);
    });
  }

  /// Create a copy of Segment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AircraftCopyWith<$Res>? get aircraft {
    if (_value.aircraft == null) {
      return null;
    }

    return $AircraftCopyWith<$Res>(_value.aircraft!, (value) {
      return _then(_value.copyWith(aircraft: value) as $Val);
    });
  }

  /// Create a copy of Segment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OperatingCopyWith<$Res>? get operating {
    if (_value.operating == null) {
      return null;
    }

    return $OperatingCopyWith<$Res>(_value.operating!, (value) {
      return _then(_value.copyWith(operating: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SegmentImplCopyWith<$Res> implements $SegmentCopyWith<$Res> {
  factory _$$SegmentImplCopyWith(
    _$SegmentImpl value,
    $Res Function(_$SegmentImpl) then,
  ) = __$$SegmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DepartureArrival? departure,
    DepartureArrival? arrival,
    String? carrierCode,
    String? number,
    Aircraft? aircraft,
    Operating? operating,
    String? duration,
    String? id,
    int? numberOfStops,
    bool? blacklistedInEU,
  });

  @override
  $DepartureArrivalCopyWith<$Res>? get departure;
  @override
  $DepartureArrivalCopyWith<$Res>? get arrival;
  @override
  $AircraftCopyWith<$Res>? get aircraft;
  @override
  $OperatingCopyWith<$Res>? get operating;
}

/// @nodoc
class __$$SegmentImplCopyWithImpl<$Res>
    extends _$SegmentCopyWithImpl<$Res, _$SegmentImpl>
    implements _$$SegmentImplCopyWith<$Res> {
  __$$SegmentImplCopyWithImpl(
    _$SegmentImpl _value,
    $Res Function(_$SegmentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Segment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? departure = freezed,
    Object? arrival = freezed,
    Object? carrierCode = freezed,
    Object? number = freezed,
    Object? aircraft = freezed,
    Object? operating = freezed,
    Object? duration = freezed,
    Object? id = freezed,
    Object? numberOfStops = freezed,
    Object? blacklistedInEU = freezed,
  }) {
    return _then(
      _$SegmentImpl(
        departure: freezed == departure
            ? _value.departure
            : departure // ignore: cast_nullable_to_non_nullable
                  as DepartureArrival?,
        arrival: freezed == arrival
            ? _value.arrival
            : arrival // ignore: cast_nullable_to_non_nullable
                  as DepartureArrival?,
        carrierCode: freezed == carrierCode
            ? _value.carrierCode
            : carrierCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        number: freezed == number
            ? _value.number
            : number // ignore: cast_nullable_to_non_nullable
                  as String?,
        aircraft: freezed == aircraft
            ? _value.aircraft
            : aircraft // ignore: cast_nullable_to_non_nullable
                  as Aircraft?,
        operating: freezed == operating
            ? _value.operating
            : operating // ignore: cast_nullable_to_non_nullable
                  as Operating?,
        duration: freezed == duration
            ? _value.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String?,
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        numberOfStops: freezed == numberOfStops
            ? _value.numberOfStops
            : numberOfStops // ignore: cast_nullable_to_non_nullable
                  as int?,
        blacklistedInEU: freezed == blacklistedInEU
            ? _value.blacklistedInEU
            : blacklistedInEU // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SegmentImpl implements _Segment {
  const _$SegmentImpl({
    this.departure,
    this.arrival,
    this.carrierCode,
    this.number,
    this.aircraft,
    this.operating,
    this.duration,
    this.id,
    this.numberOfStops,
    this.blacklistedInEU,
  });

  factory _$SegmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$SegmentImplFromJson(json);

  @override
  final DepartureArrival? departure;
  @override
  final DepartureArrival? arrival;
  @override
  final String? carrierCode;
  @override
  final String? number;
  @override
  final Aircraft? aircraft;
  @override
  final Operating? operating;
  @override
  final String? duration;
  @override
  final String? id;
  @override
  final int? numberOfStops;
  @override
  final bool? blacklistedInEU;

  @override
  String toString() {
    return 'Segment(departure: $departure, arrival: $arrival, carrierCode: $carrierCode, number: $number, aircraft: $aircraft, operating: $operating, duration: $duration, id: $id, numberOfStops: $numberOfStops, blacklistedInEU: $blacklistedInEU)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SegmentImpl &&
            (identical(other.departure, departure) ||
                other.departure == departure) &&
            (identical(other.arrival, arrival) || other.arrival == arrival) &&
            (identical(other.carrierCode, carrierCode) ||
                other.carrierCode == carrierCode) &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.aircraft, aircraft) ||
                other.aircraft == aircraft) &&
            (identical(other.operating, operating) ||
                other.operating == operating) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.numberOfStops, numberOfStops) ||
                other.numberOfStops == numberOfStops) &&
            (identical(other.blacklistedInEU, blacklistedInEU) ||
                other.blacklistedInEU == blacklistedInEU));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    departure,
    arrival,
    carrierCode,
    number,
    aircraft,
    operating,
    duration,
    id,
    numberOfStops,
    blacklistedInEU,
  );

  /// Create a copy of Segment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SegmentImplCopyWith<_$SegmentImpl> get copyWith =>
      __$$SegmentImplCopyWithImpl<_$SegmentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SegmentImplToJson(this);
  }
}

abstract class _Segment implements Segment {
  const factory _Segment({
    final DepartureArrival? departure,
    final DepartureArrival? arrival,
    final String? carrierCode,
    final String? number,
    final Aircraft? aircraft,
    final Operating? operating,
    final String? duration,
    final String? id,
    final int? numberOfStops,
    final bool? blacklistedInEU,
  }) = _$SegmentImpl;

  factory _Segment.fromJson(Map<String, dynamic> json) = _$SegmentImpl.fromJson;

  @override
  DepartureArrival? get departure;
  @override
  DepartureArrival? get arrival;
  @override
  String? get carrierCode;
  @override
  String? get number;
  @override
  Aircraft? get aircraft;
  @override
  Operating? get operating;
  @override
  String? get duration;
  @override
  String? get id;
  @override
  int? get numberOfStops;
  @override
  bool? get blacklistedInEU;

  /// Create a copy of Segment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SegmentImplCopyWith<_$SegmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DepartureArrival _$DepartureArrivalFromJson(Map<String, dynamic> json) {
  return _DepartureArrival.fromJson(json);
}

/// @nodoc
mixin _$DepartureArrival {
  String? get iataCode => throw _privateConstructorUsedError;
  String? get terminal => throw _privateConstructorUsedError;
  String? get at => throw _privateConstructorUsedError;

  /// Serializes this DepartureArrival to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DepartureArrival
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DepartureArrivalCopyWith<DepartureArrival> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DepartureArrivalCopyWith<$Res> {
  factory $DepartureArrivalCopyWith(
    DepartureArrival value,
    $Res Function(DepartureArrival) then,
  ) = _$DepartureArrivalCopyWithImpl<$Res, DepartureArrival>;
  @useResult
  $Res call({String? iataCode, String? terminal, String? at});
}

/// @nodoc
class _$DepartureArrivalCopyWithImpl<$Res, $Val extends DepartureArrival>
    implements $DepartureArrivalCopyWith<$Res> {
  _$DepartureArrivalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DepartureArrival
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? iataCode = freezed,
    Object? terminal = freezed,
    Object? at = freezed,
  }) {
    return _then(
      _value.copyWith(
            iataCode: freezed == iataCode
                ? _value.iataCode
                : iataCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            terminal: freezed == terminal
                ? _value.terminal
                : terminal // ignore: cast_nullable_to_non_nullable
                      as String?,
            at: freezed == at
                ? _value.at
                : at // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DepartureArrivalImplCopyWith<$Res>
    implements $DepartureArrivalCopyWith<$Res> {
  factory _$$DepartureArrivalImplCopyWith(
    _$DepartureArrivalImpl value,
    $Res Function(_$DepartureArrivalImpl) then,
  ) = __$$DepartureArrivalImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? iataCode, String? terminal, String? at});
}

/// @nodoc
class __$$DepartureArrivalImplCopyWithImpl<$Res>
    extends _$DepartureArrivalCopyWithImpl<$Res, _$DepartureArrivalImpl>
    implements _$$DepartureArrivalImplCopyWith<$Res> {
  __$$DepartureArrivalImplCopyWithImpl(
    _$DepartureArrivalImpl _value,
    $Res Function(_$DepartureArrivalImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DepartureArrival
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? iataCode = freezed,
    Object? terminal = freezed,
    Object? at = freezed,
  }) {
    return _then(
      _$DepartureArrivalImpl(
        iataCode: freezed == iataCode
            ? _value.iataCode
            : iataCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        terminal: freezed == terminal
            ? _value.terminal
            : terminal // ignore: cast_nullable_to_non_nullable
                  as String?,
        at: freezed == at
            ? _value.at
            : at // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DepartureArrivalImpl implements _DepartureArrival {
  const _$DepartureArrivalImpl({this.iataCode, this.terminal, this.at});

  factory _$DepartureArrivalImpl.fromJson(Map<String, dynamic> json) =>
      _$$DepartureArrivalImplFromJson(json);

  @override
  final String? iataCode;
  @override
  final String? terminal;
  @override
  final String? at;

  @override
  String toString() {
    return 'DepartureArrival(iataCode: $iataCode, terminal: $terminal, at: $at)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DepartureArrivalImpl &&
            (identical(other.iataCode, iataCode) ||
                other.iataCode == iataCode) &&
            (identical(other.terminal, terminal) ||
                other.terminal == terminal) &&
            (identical(other.at, at) || other.at == at));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, iataCode, terminal, at);

  /// Create a copy of DepartureArrival
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DepartureArrivalImplCopyWith<_$DepartureArrivalImpl> get copyWith =>
      __$$DepartureArrivalImplCopyWithImpl<_$DepartureArrivalImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DepartureArrivalImplToJson(this);
  }
}

abstract class _DepartureArrival implements DepartureArrival {
  const factory _DepartureArrival({
    final String? iataCode,
    final String? terminal,
    final String? at,
  }) = _$DepartureArrivalImpl;

  factory _DepartureArrival.fromJson(Map<String, dynamic> json) =
      _$DepartureArrivalImpl.fromJson;

  @override
  String? get iataCode;
  @override
  String? get terminal;
  @override
  String? get at;

  /// Create a copy of DepartureArrival
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DepartureArrivalImplCopyWith<_$DepartureArrivalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Aircraft _$AircraftFromJson(Map<String, dynamic> json) {
  return _Aircraft.fromJson(json);
}

/// @nodoc
mixin _$Aircraft {
  String? get code => throw _privateConstructorUsedError;

  /// Serializes this Aircraft to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Aircraft
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AircraftCopyWith<Aircraft> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AircraftCopyWith<$Res> {
  factory $AircraftCopyWith(Aircraft value, $Res Function(Aircraft) then) =
      _$AircraftCopyWithImpl<$Res, Aircraft>;
  @useResult
  $Res call({String? code});
}

/// @nodoc
class _$AircraftCopyWithImpl<$Res, $Val extends Aircraft>
    implements $AircraftCopyWith<$Res> {
  _$AircraftCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Aircraft
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? code = freezed}) {
    return _then(
      _value.copyWith(
            code: freezed == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AircraftImplCopyWith<$Res>
    implements $AircraftCopyWith<$Res> {
  factory _$$AircraftImplCopyWith(
    _$AircraftImpl value,
    $Res Function(_$AircraftImpl) then,
  ) = __$$AircraftImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? code});
}

/// @nodoc
class __$$AircraftImplCopyWithImpl<$Res>
    extends _$AircraftCopyWithImpl<$Res, _$AircraftImpl>
    implements _$$AircraftImplCopyWith<$Res> {
  __$$AircraftImplCopyWithImpl(
    _$AircraftImpl _value,
    $Res Function(_$AircraftImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Aircraft
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? code = freezed}) {
    return _then(
      _$AircraftImpl(
        code: freezed == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AircraftImpl implements _Aircraft {
  const _$AircraftImpl({this.code});

  factory _$AircraftImpl.fromJson(Map<String, dynamic> json) =>
      _$$AircraftImplFromJson(json);

  @override
  final String? code;

  @override
  String toString() {
    return 'Aircraft(code: $code)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AircraftImpl &&
            (identical(other.code, code) || other.code == code));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, code);

  /// Create a copy of Aircraft
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AircraftImplCopyWith<_$AircraftImpl> get copyWith =>
      __$$AircraftImplCopyWithImpl<_$AircraftImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AircraftImplToJson(this);
  }
}

abstract class _Aircraft implements Aircraft {
  const factory _Aircraft({final String? code}) = _$AircraftImpl;

  factory _Aircraft.fromJson(Map<String, dynamic> json) =
      _$AircraftImpl.fromJson;

  @override
  String? get code;

  /// Create a copy of Aircraft
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AircraftImplCopyWith<_$AircraftImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Operating _$OperatingFromJson(Map<String, dynamic> json) {
  return _Operating.fromJson(json);
}

/// @nodoc
mixin _$Operating {
  String? get carrierCode => throw _privateConstructorUsedError;

  /// Serializes this Operating to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Operating
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OperatingCopyWith<Operating> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OperatingCopyWith<$Res> {
  factory $OperatingCopyWith(Operating value, $Res Function(Operating) then) =
      _$OperatingCopyWithImpl<$Res, Operating>;
  @useResult
  $Res call({String? carrierCode});
}

/// @nodoc
class _$OperatingCopyWithImpl<$Res, $Val extends Operating>
    implements $OperatingCopyWith<$Res> {
  _$OperatingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Operating
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? carrierCode = freezed}) {
    return _then(
      _value.copyWith(
            carrierCode: freezed == carrierCode
                ? _value.carrierCode
                : carrierCode // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OperatingImplCopyWith<$Res>
    implements $OperatingCopyWith<$Res> {
  factory _$$OperatingImplCopyWith(
    _$OperatingImpl value,
    $Res Function(_$OperatingImpl) then,
  ) = __$$OperatingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? carrierCode});
}

/// @nodoc
class __$$OperatingImplCopyWithImpl<$Res>
    extends _$OperatingCopyWithImpl<$Res, _$OperatingImpl>
    implements _$$OperatingImplCopyWith<$Res> {
  __$$OperatingImplCopyWithImpl(
    _$OperatingImpl _value,
    $Res Function(_$OperatingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Operating
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? carrierCode = freezed}) {
    return _then(
      _$OperatingImpl(
        carrierCode: freezed == carrierCode
            ? _value.carrierCode
            : carrierCode // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OperatingImpl implements _Operating {
  const _$OperatingImpl({this.carrierCode});

  factory _$OperatingImpl.fromJson(Map<String, dynamic> json) =>
      _$$OperatingImplFromJson(json);

  @override
  final String? carrierCode;

  @override
  String toString() {
    return 'Operating(carrierCode: $carrierCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OperatingImpl &&
            (identical(other.carrierCode, carrierCode) ||
                other.carrierCode == carrierCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, carrierCode);

  /// Create a copy of Operating
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OperatingImplCopyWith<_$OperatingImpl> get copyWith =>
      __$$OperatingImplCopyWithImpl<_$OperatingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OperatingImplToJson(this);
  }
}

abstract class _Operating implements Operating {
  const factory _Operating({final String? carrierCode}) = _$OperatingImpl;

  factory _Operating.fromJson(Map<String, dynamic> json) =
      _$OperatingImpl.fromJson;

  @override
  String? get carrierCode;

  /// Create a copy of Operating
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OperatingImplCopyWith<_$OperatingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Price _$PriceFromJson(Map<String, dynamic> json) {
  return _Price.fromJson(json);
}

/// @nodoc
mixin _$Price {
  String? get currency => throw _privateConstructorUsedError;
  String? get total => throw _privateConstructorUsedError;
  String? get base => throw _privateConstructorUsedError;
  List<Fee>? get fees => throw _privateConstructorUsedError;
  String? get grandTotal => throw _privateConstructorUsedError;
  List<AdditionalService>? get additionalServices =>
      throw _privateConstructorUsedError;

  /// Serializes this Price to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Price
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PriceCopyWith<Price> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PriceCopyWith<$Res> {
  factory $PriceCopyWith(Price value, $Res Function(Price) then) =
      _$PriceCopyWithImpl<$Res, Price>;
  @useResult
  $Res call({
    String? currency,
    String? total,
    String? base,
    List<Fee>? fees,
    String? grandTotal,
    List<AdditionalService>? additionalServices,
  });
}

/// @nodoc
class _$PriceCopyWithImpl<$Res, $Val extends Price>
    implements $PriceCopyWith<$Res> {
  _$PriceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Price
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currency = freezed,
    Object? total = freezed,
    Object? base = freezed,
    Object? fees = freezed,
    Object? grandTotal = freezed,
    Object? additionalServices = freezed,
  }) {
    return _then(
      _value.copyWith(
            currency: freezed == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String?,
            total: freezed == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as String?,
            base: freezed == base
                ? _value.base
                : base // ignore: cast_nullable_to_non_nullable
                      as String?,
            fees: freezed == fees
                ? _value.fees
                : fees // ignore: cast_nullable_to_non_nullable
                      as List<Fee>?,
            grandTotal: freezed == grandTotal
                ? _value.grandTotal
                : grandTotal // ignore: cast_nullable_to_non_nullable
                      as String?,
            additionalServices: freezed == additionalServices
                ? _value.additionalServices
                : additionalServices // ignore: cast_nullable_to_non_nullable
                      as List<AdditionalService>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PriceImplCopyWith<$Res> implements $PriceCopyWith<$Res> {
  factory _$$PriceImplCopyWith(
    _$PriceImpl value,
    $Res Function(_$PriceImpl) then,
  ) = __$$PriceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? currency,
    String? total,
    String? base,
    List<Fee>? fees,
    String? grandTotal,
    List<AdditionalService>? additionalServices,
  });
}

/// @nodoc
class __$$PriceImplCopyWithImpl<$Res>
    extends _$PriceCopyWithImpl<$Res, _$PriceImpl>
    implements _$$PriceImplCopyWith<$Res> {
  __$$PriceImplCopyWithImpl(
    _$PriceImpl _value,
    $Res Function(_$PriceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Price
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currency = freezed,
    Object? total = freezed,
    Object? base = freezed,
    Object? fees = freezed,
    Object? grandTotal = freezed,
    Object? additionalServices = freezed,
  }) {
    return _then(
      _$PriceImpl(
        currency: freezed == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String?,
        total: freezed == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as String?,
        base: freezed == base
            ? _value.base
            : base // ignore: cast_nullable_to_non_nullable
                  as String?,
        fees: freezed == fees
            ? _value._fees
            : fees // ignore: cast_nullable_to_non_nullable
                  as List<Fee>?,
        grandTotal: freezed == grandTotal
            ? _value.grandTotal
            : grandTotal // ignore: cast_nullable_to_non_nullable
                  as String?,
        additionalServices: freezed == additionalServices
            ? _value._additionalServices
            : additionalServices // ignore: cast_nullable_to_non_nullable
                  as List<AdditionalService>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PriceImpl implements _Price {
  const _$PriceImpl({
    this.currency,
    this.total,
    this.base,
    final List<Fee>? fees,
    this.grandTotal,
    final List<AdditionalService>? additionalServices,
  }) : _fees = fees,
       _additionalServices = additionalServices;

  factory _$PriceImpl.fromJson(Map<String, dynamic> json) =>
      _$$PriceImplFromJson(json);

  @override
  final String? currency;
  @override
  final String? total;
  @override
  final String? base;
  final List<Fee>? _fees;
  @override
  List<Fee>? get fees {
    final value = _fees;
    if (value == null) return null;
    if (_fees is EqualUnmodifiableListView) return _fees;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? grandTotal;
  final List<AdditionalService>? _additionalServices;
  @override
  List<AdditionalService>? get additionalServices {
    final value = _additionalServices;
    if (value == null) return null;
    if (_additionalServices is EqualUnmodifiableListView)
      return _additionalServices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Price(currency: $currency, total: $total, base: $base, fees: $fees, grandTotal: $grandTotal, additionalServices: $additionalServices)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PriceImpl &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.base, base) || other.base == base) &&
            const DeepCollectionEquality().equals(other._fees, _fees) &&
            (identical(other.grandTotal, grandTotal) ||
                other.grandTotal == grandTotal) &&
            const DeepCollectionEquality().equals(
              other._additionalServices,
              _additionalServices,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    currency,
    total,
    base,
    const DeepCollectionEquality().hash(_fees),
    grandTotal,
    const DeepCollectionEquality().hash(_additionalServices),
  );

  /// Create a copy of Price
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PriceImplCopyWith<_$PriceImpl> get copyWith =>
      __$$PriceImplCopyWithImpl<_$PriceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PriceImplToJson(this);
  }
}

abstract class _Price implements Price {
  const factory _Price({
    final String? currency,
    final String? total,
    final String? base,
    final List<Fee>? fees,
    final String? grandTotal,
    final List<AdditionalService>? additionalServices,
  }) = _$PriceImpl;

  factory _Price.fromJson(Map<String, dynamic> json) = _$PriceImpl.fromJson;

  @override
  String? get currency;
  @override
  String? get total;
  @override
  String? get base;
  @override
  List<Fee>? get fees;
  @override
  String? get grandTotal;
  @override
  List<AdditionalService>? get additionalServices;

  /// Create a copy of Price
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PriceImplCopyWith<_$PriceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Fee _$FeeFromJson(Map<String, dynamic> json) {
  return _Fee.fromJson(json);
}

/// @nodoc
mixin _$Fee {
  String? get amount => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;

  /// Serializes this Fee to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Fee
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeeCopyWith<Fee> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeeCopyWith<$Res> {
  factory $FeeCopyWith(Fee value, $Res Function(Fee) then) =
      _$FeeCopyWithImpl<$Res, Fee>;
  @useResult
  $Res call({String? amount, String? type});
}

/// @nodoc
class _$FeeCopyWithImpl<$Res, $Val extends Fee> implements $FeeCopyWith<$Res> {
  _$FeeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Fee
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? amount = freezed, Object? type = freezed}) {
    return _then(
      _value.copyWith(
            amount: freezed == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as String?,
            type: freezed == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FeeImplCopyWith<$Res> implements $FeeCopyWith<$Res> {
  factory _$$FeeImplCopyWith(_$FeeImpl value, $Res Function(_$FeeImpl) then) =
      __$$FeeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? amount, String? type});
}

/// @nodoc
class __$$FeeImplCopyWithImpl<$Res> extends _$FeeCopyWithImpl<$Res, _$FeeImpl>
    implements _$$FeeImplCopyWith<$Res> {
  __$$FeeImplCopyWithImpl(_$FeeImpl _value, $Res Function(_$FeeImpl) _then)
    : super(_value, _then);

  /// Create a copy of Fee
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? amount = freezed, Object? type = freezed}) {
    return _then(
      _$FeeImpl(
        amount: freezed == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: freezed == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FeeImpl implements _Fee {
  const _$FeeImpl({this.amount, this.type});

  factory _$FeeImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeeImplFromJson(json);

  @override
  final String? amount;
  @override
  final String? type;

  @override
  String toString() {
    return 'Fee(amount: $amount, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeeImpl &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, amount, type);

  /// Create a copy of Fee
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeeImplCopyWith<_$FeeImpl> get copyWith =>
      __$$FeeImplCopyWithImpl<_$FeeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FeeImplToJson(this);
  }
}

abstract class _Fee implements Fee {
  const factory _Fee({final String? amount, final String? type}) = _$FeeImpl;

  factory _Fee.fromJson(Map<String, dynamic> json) = _$FeeImpl.fromJson;

  @override
  String? get amount;
  @override
  String? get type;

  /// Create a copy of Fee
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeeImplCopyWith<_$FeeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AdditionalService _$AdditionalServiceFromJson(Map<String, dynamic> json) {
  return _AdditionalService.fromJson(json);
}

/// @nodoc
mixin _$AdditionalService {
  String? get amount => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;

  /// Serializes this AdditionalService to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AdditionalService
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AdditionalServiceCopyWith<AdditionalService> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdditionalServiceCopyWith<$Res> {
  factory $AdditionalServiceCopyWith(
    AdditionalService value,
    $Res Function(AdditionalService) then,
  ) = _$AdditionalServiceCopyWithImpl<$Res, AdditionalService>;
  @useResult
  $Res call({String? amount, String? type});
}

/// @nodoc
class _$AdditionalServiceCopyWithImpl<$Res, $Val extends AdditionalService>
    implements $AdditionalServiceCopyWith<$Res> {
  _$AdditionalServiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AdditionalService
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? amount = freezed, Object? type = freezed}) {
    return _then(
      _value.copyWith(
            amount: freezed == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as String?,
            type: freezed == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AdditionalServiceImplCopyWith<$Res>
    implements $AdditionalServiceCopyWith<$Res> {
  factory _$$AdditionalServiceImplCopyWith(
    _$AdditionalServiceImpl value,
    $Res Function(_$AdditionalServiceImpl) then,
  ) = __$$AdditionalServiceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? amount, String? type});
}

/// @nodoc
class __$$AdditionalServiceImplCopyWithImpl<$Res>
    extends _$AdditionalServiceCopyWithImpl<$Res, _$AdditionalServiceImpl>
    implements _$$AdditionalServiceImplCopyWith<$Res> {
  __$$AdditionalServiceImplCopyWithImpl(
    _$AdditionalServiceImpl _value,
    $Res Function(_$AdditionalServiceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AdditionalService
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? amount = freezed, Object? type = freezed}) {
    return _then(
      _$AdditionalServiceImpl(
        amount: freezed == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: freezed == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AdditionalServiceImpl implements _AdditionalService {
  const _$AdditionalServiceImpl({this.amount, this.type});

  factory _$AdditionalServiceImpl.fromJson(Map<String, dynamic> json) =>
      _$$AdditionalServiceImplFromJson(json);

  @override
  final String? amount;
  @override
  final String? type;

  @override
  String toString() {
    return 'AdditionalService(amount: $amount, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdditionalServiceImpl &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, amount, type);

  /// Create a copy of AdditionalService
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AdditionalServiceImplCopyWith<_$AdditionalServiceImpl> get copyWith =>
      __$$AdditionalServiceImplCopyWithImpl<_$AdditionalServiceImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AdditionalServiceImplToJson(this);
  }
}

abstract class _AdditionalService implements AdditionalService {
  const factory _AdditionalService({final String? amount, final String? type}) =
      _$AdditionalServiceImpl;

  factory _AdditionalService.fromJson(Map<String, dynamic> json) =
      _$AdditionalServiceImpl.fromJson;

  @override
  String? get amount;
  @override
  String? get type;

  /// Create a copy of AdditionalService
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AdditionalServiceImplCopyWith<_$AdditionalServiceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PricingOptions _$PricingOptionsFromJson(Map<String, dynamic> json) {
  return _PricingOptions.fromJson(json);
}

/// @nodoc
mixin _$PricingOptions {
  List<String>? get fareType => throw _privateConstructorUsedError;
  bool? get includedCheckedBagsOnly => throw _privateConstructorUsedError;

  /// Serializes this PricingOptions to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PricingOptions
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PricingOptionsCopyWith<PricingOptions> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PricingOptionsCopyWith<$Res> {
  factory $PricingOptionsCopyWith(
    PricingOptions value,
    $Res Function(PricingOptions) then,
  ) = _$PricingOptionsCopyWithImpl<$Res, PricingOptions>;
  @useResult
  $Res call({List<String>? fareType, bool? includedCheckedBagsOnly});
}

/// @nodoc
class _$PricingOptionsCopyWithImpl<$Res, $Val extends PricingOptions>
    implements $PricingOptionsCopyWith<$Res> {
  _$PricingOptionsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PricingOptions
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fareType = freezed,
    Object? includedCheckedBagsOnly = freezed,
  }) {
    return _then(
      _value.copyWith(
            fareType: freezed == fareType
                ? _value.fareType
                : fareType // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            includedCheckedBagsOnly: freezed == includedCheckedBagsOnly
                ? _value.includedCheckedBagsOnly
                : includedCheckedBagsOnly // ignore: cast_nullable_to_non_nullable
                      as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PricingOptionsImplCopyWith<$Res>
    implements $PricingOptionsCopyWith<$Res> {
  factory _$$PricingOptionsImplCopyWith(
    _$PricingOptionsImpl value,
    $Res Function(_$PricingOptionsImpl) then,
  ) = __$$PricingOptionsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String>? fareType, bool? includedCheckedBagsOnly});
}

/// @nodoc
class __$$PricingOptionsImplCopyWithImpl<$Res>
    extends _$PricingOptionsCopyWithImpl<$Res, _$PricingOptionsImpl>
    implements _$$PricingOptionsImplCopyWith<$Res> {
  __$$PricingOptionsImplCopyWithImpl(
    _$PricingOptionsImpl _value,
    $Res Function(_$PricingOptionsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PricingOptions
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fareType = freezed,
    Object? includedCheckedBagsOnly = freezed,
  }) {
    return _then(
      _$PricingOptionsImpl(
        fareType: freezed == fareType
            ? _value._fareType
            : fareType // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        includedCheckedBagsOnly: freezed == includedCheckedBagsOnly
            ? _value.includedCheckedBagsOnly
            : includedCheckedBagsOnly // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PricingOptionsImpl implements _PricingOptions {
  const _$PricingOptionsImpl({
    final List<String>? fareType,
    this.includedCheckedBagsOnly,
  }) : _fareType = fareType;

  factory _$PricingOptionsImpl.fromJson(Map<String, dynamic> json) =>
      _$$PricingOptionsImplFromJson(json);

  final List<String>? _fareType;
  @override
  List<String>? get fareType {
    final value = _fareType;
    if (value == null) return null;
    if (_fareType is EqualUnmodifiableListView) return _fareType;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final bool? includedCheckedBagsOnly;

  @override
  String toString() {
    return 'PricingOptions(fareType: $fareType, includedCheckedBagsOnly: $includedCheckedBagsOnly)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PricingOptionsImpl &&
            const DeepCollectionEquality().equals(other._fareType, _fareType) &&
            (identical(
                  other.includedCheckedBagsOnly,
                  includedCheckedBagsOnly,
                ) ||
                other.includedCheckedBagsOnly == includedCheckedBagsOnly));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_fareType),
    includedCheckedBagsOnly,
  );

  /// Create a copy of PricingOptions
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PricingOptionsImplCopyWith<_$PricingOptionsImpl> get copyWith =>
      __$$PricingOptionsImplCopyWithImpl<_$PricingOptionsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PricingOptionsImplToJson(this);
  }
}

abstract class _PricingOptions implements PricingOptions {
  const factory _PricingOptions({
    final List<String>? fareType,
    final bool? includedCheckedBagsOnly,
  }) = _$PricingOptionsImpl;

  factory _PricingOptions.fromJson(Map<String, dynamic> json) =
      _$PricingOptionsImpl.fromJson;

  @override
  List<String>? get fareType;
  @override
  bool? get includedCheckedBagsOnly;

  /// Create a copy of PricingOptions
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PricingOptionsImplCopyWith<_$PricingOptionsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TravelerPricing _$TravelerPricingFromJson(Map<String, dynamic> json) {
  return _TravelerPricing.fromJson(json);
}

/// @nodoc
mixin _$TravelerPricing {
  String? get travelerId => throw _privateConstructorUsedError;
  String? get fareOption => throw _privateConstructorUsedError;
  String? get travelerType => throw _privateConstructorUsedError;
  Price? get price => throw _privateConstructorUsedError;
  List<FareDetailsBySegment>? get fareDetailsBySegment =>
      throw _privateConstructorUsedError;

  /// Serializes this TravelerPricing to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TravelerPricing
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TravelerPricingCopyWith<TravelerPricing> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TravelerPricingCopyWith<$Res> {
  factory $TravelerPricingCopyWith(
    TravelerPricing value,
    $Res Function(TravelerPricing) then,
  ) = _$TravelerPricingCopyWithImpl<$Res, TravelerPricing>;
  @useResult
  $Res call({
    String? travelerId,
    String? fareOption,
    String? travelerType,
    Price? price,
    List<FareDetailsBySegment>? fareDetailsBySegment,
  });

  $PriceCopyWith<$Res>? get price;
}

/// @nodoc
class _$TravelerPricingCopyWithImpl<$Res, $Val extends TravelerPricing>
    implements $TravelerPricingCopyWith<$Res> {
  _$TravelerPricingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TravelerPricing
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? travelerId = freezed,
    Object? fareOption = freezed,
    Object? travelerType = freezed,
    Object? price = freezed,
    Object? fareDetailsBySegment = freezed,
  }) {
    return _then(
      _value.copyWith(
            travelerId: freezed == travelerId
                ? _value.travelerId
                : travelerId // ignore: cast_nullable_to_non_nullable
                      as String?,
            fareOption: freezed == fareOption
                ? _value.fareOption
                : fareOption // ignore: cast_nullable_to_non_nullable
                      as String?,
            travelerType: freezed == travelerType
                ? _value.travelerType
                : travelerType // ignore: cast_nullable_to_non_nullable
                      as String?,
            price: freezed == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as Price?,
            fareDetailsBySegment: freezed == fareDetailsBySegment
                ? _value.fareDetailsBySegment
                : fareDetailsBySegment // ignore: cast_nullable_to_non_nullable
                      as List<FareDetailsBySegment>?,
          )
          as $Val,
    );
  }

  /// Create a copy of TravelerPricing
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PriceCopyWith<$Res>? get price {
    if (_value.price == null) {
      return null;
    }

    return $PriceCopyWith<$Res>(_value.price!, (value) {
      return _then(_value.copyWith(price: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TravelerPricingImplCopyWith<$Res>
    implements $TravelerPricingCopyWith<$Res> {
  factory _$$TravelerPricingImplCopyWith(
    _$TravelerPricingImpl value,
    $Res Function(_$TravelerPricingImpl) then,
  ) = __$$TravelerPricingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? travelerId,
    String? fareOption,
    String? travelerType,
    Price? price,
    List<FareDetailsBySegment>? fareDetailsBySegment,
  });

  @override
  $PriceCopyWith<$Res>? get price;
}

/// @nodoc
class __$$TravelerPricingImplCopyWithImpl<$Res>
    extends _$TravelerPricingCopyWithImpl<$Res, _$TravelerPricingImpl>
    implements _$$TravelerPricingImplCopyWith<$Res> {
  __$$TravelerPricingImplCopyWithImpl(
    _$TravelerPricingImpl _value,
    $Res Function(_$TravelerPricingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TravelerPricing
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? travelerId = freezed,
    Object? fareOption = freezed,
    Object? travelerType = freezed,
    Object? price = freezed,
    Object? fareDetailsBySegment = freezed,
  }) {
    return _then(
      _$TravelerPricingImpl(
        travelerId: freezed == travelerId
            ? _value.travelerId
            : travelerId // ignore: cast_nullable_to_non_nullable
                  as String?,
        fareOption: freezed == fareOption
            ? _value.fareOption
            : fareOption // ignore: cast_nullable_to_non_nullable
                  as String?,
        travelerType: freezed == travelerType
            ? _value.travelerType
            : travelerType // ignore: cast_nullable_to_non_nullable
                  as String?,
        price: freezed == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as Price?,
        fareDetailsBySegment: freezed == fareDetailsBySegment
            ? _value._fareDetailsBySegment
            : fareDetailsBySegment // ignore: cast_nullable_to_non_nullable
                  as List<FareDetailsBySegment>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TravelerPricingImpl implements _TravelerPricing {
  const _$TravelerPricingImpl({
    this.travelerId,
    this.fareOption,
    this.travelerType,
    this.price,
    final List<FareDetailsBySegment>? fareDetailsBySegment,
  }) : _fareDetailsBySegment = fareDetailsBySegment;

  factory _$TravelerPricingImpl.fromJson(Map<String, dynamic> json) =>
      _$$TravelerPricingImplFromJson(json);

  @override
  final String? travelerId;
  @override
  final String? fareOption;
  @override
  final String? travelerType;
  @override
  final Price? price;
  final List<FareDetailsBySegment>? _fareDetailsBySegment;
  @override
  List<FareDetailsBySegment>? get fareDetailsBySegment {
    final value = _fareDetailsBySegment;
    if (value == null) return null;
    if (_fareDetailsBySegment is EqualUnmodifiableListView)
      return _fareDetailsBySegment;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'TravelerPricing(travelerId: $travelerId, fareOption: $fareOption, travelerType: $travelerType, price: $price, fareDetailsBySegment: $fareDetailsBySegment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TravelerPricingImpl &&
            (identical(other.travelerId, travelerId) ||
                other.travelerId == travelerId) &&
            (identical(other.fareOption, fareOption) ||
                other.fareOption == fareOption) &&
            (identical(other.travelerType, travelerType) ||
                other.travelerType == travelerType) &&
            (identical(other.price, price) || other.price == price) &&
            const DeepCollectionEquality().equals(
              other._fareDetailsBySegment,
              _fareDetailsBySegment,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    travelerId,
    fareOption,
    travelerType,
    price,
    const DeepCollectionEquality().hash(_fareDetailsBySegment),
  );

  /// Create a copy of TravelerPricing
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TravelerPricingImplCopyWith<_$TravelerPricingImpl> get copyWith =>
      __$$TravelerPricingImplCopyWithImpl<_$TravelerPricingImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TravelerPricingImplToJson(this);
  }
}

abstract class _TravelerPricing implements TravelerPricing {
  const factory _TravelerPricing({
    final String? travelerId,
    final String? fareOption,
    final String? travelerType,
    final Price? price,
    final List<FareDetailsBySegment>? fareDetailsBySegment,
  }) = _$TravelerPricingImpl;

  factory _TravelerPricing.fromJson(Map<String, dynamic> json) =
      _$TravelerPricingImpl.fromJson;

  @override
  String? get travelerId;
  @override
  String? get fareOption;
  @override
  String? get travelerType;
  @override
  Price? get price;
  @override
  List<FareDetailsBySegment>? get fareDetailsBySegment;

  /// Create a copy of TravelerPricing
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TravelerPricingImplCopyWith<_$TravelerPricingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FareDetailsBySegment _$FareDetailsBySegmentFromJson(Map<String, dynamic> json) {
  return _FareDetailsBySegment.fromJson(json);
}

/// @nodoc
mixin _$FareDetailsBySegment {
  String? get segmentId => throw _privateConstructorUsedError;
  String? get cabin => throw _privateConstructorUsedError;
  String? get fareBasis => throw _privateConstructorUsedError;
  @JsonKey(name: 'class')
  String? get class_ => throw _privateConstructorUsedError;
  IncludedBags? get includedCheckedBags => throw _privateConstructorUsedError;
  IncludedBags? get includedCabinBags => throw _privateConstructorUsedError;

  /// Serializes this FareDetailsBySegment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FareDetailsBySegment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FareDetailsBySegmentCopyWith<FareDetailsBySegment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FareDetailsBySegmentCopyWith<$Res> {
  factory $FareDetailsBySegmentCopyWith(
    FareDetailsBySegment value,
    $Res Function(FareDetailsBySegment) then,
  ) = _$FareDetailsBySegmentCopyWithImpl<$Res, FareDetailsBySegment>;
  @useResult
  $Res call({
    String? segmentId,
    String? cabin,
    String? fareBasis,
    @JsonKey(name: 'class') String? class_,
    IncludedBags? includedCheckedBags,
    IncludedBags? includedCabinBags,
  });

  $IncludedBagsCopyWith<$Res>? get includedCheckedBags;
  $IncludedBagsCopyWith<$Res>? get includedCabinBags;
}

/// @nodoc
class _$FareDetailsBySegmentCopyWithImpl<
  $Res,
  $Val extends FareDetailsBySegment
>
    implements $FareDetailsBySegmentCopyWith<$Res> {
  _$FareDetailsBySegmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FareDetailsBySegment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? segmentId = freezed,
    Object? cabin = freezed,
    Object? fareBasis = freezed,
    Object? class_ = freezed,
    Object? includedCheckedBags = freezed,
    Object? includedCabinBags = freezed,
  }) {
    return _then(
      _value.copyWith(
            segmentId: freezed == segmentId
                ? _value.segmentId
                : segmentId // ignore: cast_nullable_to_non_nullable
                      as String?,
            cabin: freezed == cabin
                ? _value.cabin
                : cabin // ignore: cast_nullable_to_non_nullable
                      as String?,
            fareBasis: freezed == fareBasis
                ? _value.fareBasis
                : fareBasis // ignore: cast_nullable_to_non_nullable
                      as String?,
            class_: freezed == class_
                ? _value.class_
                : class_ // ignore: cast_nullable_to_non_nullable
                      as String?,
            includedCheckedBags: freezed == includedCheckedBags
                ? _value.includedCheckedBags
                : includedCheckedBags // ignore: cast_nullable_to_non_nullable
                      as IncludedBags?,
            includedCabinBags: freezed == includedCabinBags
                ? _value.includedCabinBags
                : includedCabinBags // ignore: cast_nullable_to_non_nullable
                      as IncludedBags?,
          )
          as $Val,
    );
  }

  /// Create a copy of FareDetailsBySegment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $IncludedBagsCopyWith<$Res>? get includedCheckedBags {
    if (_value.includedCheckedBags == null) {
      return null;
    }

    return $IncludedBagsCopyWith<$Res>(_value.includedCheckedBags!, (value) {
      return _then(_value.copyWith(includedCheckedBags: value) as $Val);
    });
  }

  /// Create a copy of FareDetailsBySegment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $IncludedBagsCopyWith<$Res>? get includedCabinBags {
    if (_value.includedCabinBags == null) {
      return null;
    }

    return $IncludedBagsCopyWith<$Res>(_value.includedCabinBags!, (value) {
      return _then(_value.copyWith(includedCabinBags: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FareDetailsBySegmentImplCopyWith<$Res>
    implements $FareDetailsBySegmentCopyWith<$Res> {
  factory _$$FareDetailsBySegmentImplCopyWith(
    _$FareDetailsBySegmentImpl value,
    $Res Function(_$FareDetailsBySegmentImpl) then,
  ) = __$$FareDetailsBySegmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? segmentId,
    String? cabin,
    String? fareBasis,
    @JsonKey(name: 'class') String? class_,
    IncludedBags? includedCheckedBags,
    IncludedBags? includedCabinBags,
  });

  @override
  $IncludedBagsCopyWith<$Res>? get includedCheckedBags;
  @override
  $IncludedBagsCopyWith<$Res>? get includedCabinBags;
}

/// @nodoc
class __$$FareDetailsBySegmentImplCopyWithImpl<$Res>
    extends _$FareDetailsBySegmentCopyWithImpl<$Res, _$FareDetailsBySegmentImpl>
    implements _$$FareDetailsBySegmentImplCopyWith<$Res> {
  __$$FareDetailsBySegmentImplCopyWithImpl(
    _$FareDetailsBySegmentImpl _value,
    $Res Function(_$FareDetailsBySegmentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FareDetailsBySegment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? segmentId = freezed,
    Object? cabin = freezed,
    Object? fareBasis = freezed,
    Object? class_ = freezed,
    Object? includedCheckedBags = freezed,
    Object? includedCabinBags = freezed,
  }) {
    return _then(
      _$FareDetailsBySegmentImpl(
        segmentId: freezed == segmentId
            ? _value.segmentId
            : segmentId // ignore: cast_nullable_to_non_nullable
                  as String?,
        cabin: freezed == cabin
            ? _value.cabin
            : cabin // ignore: cast_nullable_to_non_nullable
                  as String?,
        fareBasis: freezed == fareBasis
            ? _value.fareBasis
            : fareBasis // ignore: cast_nullable_to_non_nullable
                  as String?,
        class_: freezed == class_
            ? _value.class_
            : class_ // ignore: cast_nullable_to_non_nullable
                  as String?,
        includedCheckedBags: freezed == includedCheckedBags
            ? _value.includedCheckedBags
            : includedCheckedBags // ignore: cast_nullable_to_non_nullable
                  as IncludedBags?,
        includedCabinBags: freezed == includedCabinBags
            ? _value.includedCabinBags
            : includedCabinBags // ignore: cast_nullable_to_non_nullable
                  as IncludedBags?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FareDetailsBySegmentImpl implements _FareDetailsBySegment {
  const _$FareDetailsBySegmentImpl({
    this.segmentId,
    this.cabin,
    this.fareBasis,
    @JsonKey(name: 'class') this.class_,
    this.includedCheckedBags,
    this.includedCabinBags,
  });

  factory _$FareDetailsBySegmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$FareDetailsBySegmentImplFromJson(json);

  @override
  final String? segmentId;
  @override
  final String? cabin;
  @override
  final String? fareBasis;
  @override
  @JsonKey(name: 'class')
  final String? class_;
  @override
  final IncludedBags? includedCheckedBags;
  @override
  final IncludedBags? includedCabinBags;

  @override
  String toString() {
    return 'FareDetailsBySegment(segmentId: $segmentId, cabin: $cabin, fareBasis: $fareBasis, class_: $class_, includedCheckedBags: $includedCheckedBags, includedCabinBags: $includedCabinBags)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FareDetailsBySegmentImpl &&
            (identical(other.segmentId, segmentId) ||
                other.segmentId == segmentId) &&
            (identical(other.cabin, cabin) || other.cabin == cabin) &&
            (identical(other.fareBasis, fareBasis) ||
                other.fareBasis == fareBasis) &&
            (identical(other.class_, class_) || other.class_ == class_) &&
            (identical(other.includedCheckedBags, includedCheckedBags) ||
                other.includedCheckedBags == includedCheckedBags) &&
            (identical(other.includedCabinBags, includedCabinBags) ||
                other.includedCabinBags == includedCabinBags));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    segmentId,
    cabin,
    fareBasis,
    class_,
    includedCheckedBags,
    includedCabinBags,
  );

  /// Create a copy of FareDetailsBySegment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FareDetailsBySegmentImplCopyWith<_$FareDetailsBySegmentImpl>
  get copyWith =>
      __$$FareDetailsBySegmentImplCopyWithImpl<_$FareDetailsBySegmentImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FareDetailsBySegmentImplToJson(this);
  }
}

abstract class _FareDetailsBySegment implements FareDetailsBySegment {
  const factory _FareDetailsBySegment({
    final String? segmentId,
    final String? cabin,
    final String? fareBasis,
    @JsonKey(name: 'class') final String? class_,
    final IncludedBags? includedCheckedBags,
    final IncludedBags? includedCabinBags,
  }) = _$FareDetailsBySegmentImpl;

  factory _FareDetailsBySegment.fromJson(Map<String, dynamic> json) =
      _$FareDetailsBySegmentImpl.fromJson;

  @override
  String? get segmentId;
  @override
  String? get cabin;
  @override
  String? get fareBasis;
  @override
  @JsonKey(name: 'class')
  String? get class_;
  @override
  IncludedBags? get includedCheckedBags;
  @override
  IncludedBags? get includedCabinBags;

  /// Create a copy of FareDetailsBySegment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FareDetailsBySegmentImplCopyWith<_$FareDetailsBySegmentImpl>
  get copyWith => throw _privateConstructorUsedError;
}

IncludedCheckedBags _$IncludedCheckedBagsFromJson(Map<String, dynamic> json) {
  return _IncludedCheckedBags.fromJson(json);
}

/// @nodoc
mixin _$IncludedCheckedBags {
  int? get quantity => throw _privateConstructorUsedError;
  int? get weight => throw _privateConstructorUsedError;
  String? get weightUnit => throw _privateConstructorUsedError;

  /// Serializes this IncludedCheckedBags to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IncludedCheckedBags
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IncludedCheckedBagsCopyWith<IncludedCheckedBags> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IncludedCheckedBagsCopyWith<$Res> {
  factory $IncludedCheckedBagsCopyWith(
    IncludedCheckedBags value,
    $Res Function(IncludedCheckedBags) then,
  ) = _$IncludedCheckedBagsCopyWithImpl<$Res, IncludedCheckedBags>;
  @useResult
  $Res call({int? quantity, int? weight, String? weightUnit});
}

/// @nodoc
class _$IncludedCheckedBagsCopyWithImpl<$Res, $Val extends IncludedCheckedBags>
    implements $IncludedCheckedBagsCopyWith<$Res> {
  _$IncludedCheckedBagsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IncludedCheckedBags
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? quantity = freezed,
    Object? weight = freezed,
    Object? weightUnit = freezed,
  }) {
    return _then(
      _value.copyWith(
            quantity: freezed == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int?,
            weight: freezed == weight
                ? _value.weight
                : weight // ignore: cast_nullable_to_non_nullable
                      as int?,
            weightUnit: freezed == weightUnit
                ? _value.weightUnit
                : weightUnit // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$IncludedCheckedBagsImplCopyWith<$Res>
    implements $IncludedCheckedBagsCopyWith<$Res> {
  factory _$$IncludedCheckedBagsImplCopyWith(
    _$IncludedCheckedBagsImpl value,
    $Res Function(_$IncludedCheckedBagsImpl) then,
  ) = __$$IncludedCheckedBagsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? quantity, int? weight, String? weightUnit});
}

/// @nodoc
class __$$IncludedCheckedBagsImplCopyWithImpl<$Res>
    extends _$IncludedCheckedBagsCopyWithImpl<$Res, _$IncludedCheckedBagsImpl>
    implements _$$IncludedCheckedBagsImplCopyWith<$Res> {
  __$$IncludedCheckedBagsImplCopyWithImpl(
    _$IncludedCheckedBagsImpl _value,
    $Res Function(_$IncludedCheckedBagsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of IncludedCheckedBags
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? quantity = freezed,
    Object? weight = freezed,
    Object? weightUnit = freezed,
  }) {
    return _then(
      _$IncludedCheckedBagsImpl(
        quantity: freezed == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int?,
        weight: freezed == weight
            ? _value.weight
            : weight // ignore: cast_nullable_to_non_nullable
                  as int?,
        weightUnit: freezed == weightUnit
            ? _value.weightUnit
            : weightUnit // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$IncludedCheckedBagsImpl implements _IncludedCheckedBags {
  const _$IncludedCheckedBagsImpl({
    this.quantity,
    this.weight,
    this.weightUnit,
  });

  factory _$IncludedCheckedBagsImpl.fromJson(Map<String, dynamic> json) =>
      _$$IncludedCheckedBagsImplFromJson(json);

  @override
  final int? quantity;
  @override
  final int? weight;
  @override
  final String? weightUnit;

  @override
  String toString() {
    return 'IncludedCheckedBags(quantity: $quantity, weight: $weight, weightUnit: $weightUnit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IncludedCheckedBagsImpl &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.weightUnit, weightUnit) ||
                other.weightUnit == weightUnit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, quantity, weight, weightUnit);

  /// Create a copy of IncludedCheckedBags
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IncludedCheckedBagsImplCopyWith<_$IncludedCheckedBagsImpl> get copyWith =>
      __$$IncludedCheckedBagsImplCopyWithImpl<_$IncludedCheckedBagsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$IncludedCheckedBagsImplToJson(this);
  }
}

abstract class _IncludedCheckedBags implements IncludedCheckedBags {
  const factory _IncludedCheckedBags({
    final int? quantity,
    final int? weight,
    final String? weightUnit,
  }) = _$IncludedCheckedBagsImpl;

  factory _IncludedCheckedBags.fromJson(Map<String, dynamic> json) =
      _$IncludedCheckedBagsImpl.fromJson;

  @override
  int? get quantity;
  @override
  int? get weight;
  @override
  String? get weightUnit;

  /// Create a copy of IncludedCheckedBags
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IncludedCheckedBagsImplCopyWith<_$IncludedCheckedBagsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Dictionaries _$DictionariesFromJson(Map<String, dynamic> json) {
  return _Dictionaries.fromJson(json);
}

/// @nodoc
mixin _$Dictionaries {
  Map<String, Location>? get locations => throw _privateConstructorUsedError;
  Map<String, String>? get aircraft => throw _privateConstructorUsedError;
  Map<String, String>? get currencies => throw _privateConstructorUsedError;
  Map<String, String>? get carriers => throw _privateConstructorUsedError;

  /// Serializes this Dictionaries to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Dictionaries
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DictionariesCopyWith<Dictionaries> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DictionariesCopyWith<$Res> {
  factory $DictionariesCopyWith(
    Dictionaries value,
    $Res Function(Dictionaries) then,
  ) = _$DictionariesCopyWithImpl<$Res, Dictionaries>;
  @useResult
  $Res call({
    Map<String, Location>? locations,
    Map<String, String>? aircraft,
    Map<String, String>? currencies,
    Map<String, String>? carriers,
  });
}

/// @nodoc
class _$DictionariesCopyWithImpl<$Res, $Val extends Dictionaries>
    implements $DictionariesCopyWith<$Res> {
  _$DictionariesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Dictionaries
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? locations = freezed,
    Object? aircraft = freezed,
    Object? currencies = freezed,
    Object? carriers = freezed,
  }) {
    return _then(
      _value.copyWith(
            locations: freezed == locations
                ? _value.locations
                : locations // ignore: cast_nullable_to_non_nullable
                      as Map<String, Location>?,
            aircraft: freezed == aircraft
                ? _value.aircraft
                : aircraft // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>?,
            currencies: freezed == currencies
                ? _value.currencies
                : currencies // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>?,
            carriers: freezed == carriers
                ? _value.carriers
                : carriers // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DictionariesImplCopyWith<$Res>
    implements $DictionariesCopyWith<$Res> {
  factory _$$DictionariesImplCopyWith(
    _$DictionariesImpl value,
    $Res Function(_$DictionariesImpl) then,
  ) = __$$DictionariesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    Map<String, Location>? locations,
    Map<String, String>? aircraft,
    Map<String, String>? currencies,
    Map<String, String>? carriers,
  });
}

/// @nodoc
class __$$DictionariesImplCopyWithImpl<$Res>
    extends _$DictionariesCopyWithImpl<$Res, _$DictionariesImpl>
    implements _$$DictionariesImplCopyWith<$Res> {
  __$$DictionariesImplCopyWithImpl(
    _$DictionariesImpl _value,
    $Res Function(_$DictionariesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Dictionaries
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? locations = freezed,
    Object? aircraft = freezed,
    Object? currencies = freezed,
    Object? carriers = freezed,
  }) {
    return _then(
      _$DictionariesImpl(
        locations: freezed == locations
            ? _value._locations
            : locations // ignore: cast_nullable_to_non_nullable
                  as Map<String, Location>?,
        aircraft: freezed == aircraft
            ? _value._aircraft
            : aircraft // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>?,
        currencies: freezed == currencies
            ? _value._currencies
            : currencies // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>?,
        carriers: freezed == carriers
            ? _value._carriers
            : carriers // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DictionariesImpl implements _Dictionaries {
  const _$DictionariesImpl({
    final Map<String, Location>? locations,
    final Map<String, String>? aircraft,
    final Map<String, String>? currencies,
    final Map<String, String>? carriers,
  }) : _locations = locations,
       _aircraft = aircraft,
       _currencies = currencies,
       _carriers = carriers;

  factory _$DictionariesImpl.fromJson(Map<String, dynamic> json) =>
      _$$DictionariesImplFromJson(json);

  final Map<String, Location>? _locations;
  @override
  Map<String, Location>? get locations {
    final value = _locations;
    if (value == null) return null;
    if (_locations is EqualUnmodifiableMapView) return _locations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, String>? _aircraft;
  @override
  Map<String, String>? get aircraft {
    final value = _aircraft;
    if (value == null) return null;
    if (_aircraft is EqualUnmodifiableMapView) return _aircraft;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, String>? _currencies;
  @override
  Map<String, String>? get currencies {
    final value = _currencies;
    if (value == null) return null;
    if (_currencies is EqualUnmodifiableMapView) return _currencies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, String>? _carriers;
  @override
  Map<String, String>? get carriers {
    final value = _carriers;
    if (value == null) return null;
    if (_carriers is EqualUnmodifiableMapView) return _carriers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'Dictionaries(locations: $locations, aircraft: $aircraft, currencies: $currencies, carriers: $carriers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DictionariesImpl &&
            const DeepCollectionEquality().equals(
              other._locations,
              _locations,
            ) &&
            const DeepCollectionEquality().equals(other._aircraft, _aircraft) &&
            const DeepCollectionEquality().equals(
              other._currencies,
              _currencies,
            ) &&
            const DeepCollectionEquality().equals(other._carriers, _carriers));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_locations),
    const DeepCollectionEquality().hash(_aircraft),
    const DeepCollectionEquality().hash(_currencies),
    const DeepCollectionEquality().hash(_carriers),
  );

  /// Create a copy of Dictionaries
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DictionariesImplCopyWith<_$DictionariesImpl> get copyWith =>
      __$$DictionariesImplCopyWithImpl<_$DictionariesImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DictionariesImplToJson(this);
  }
}

abstract class _Dictionaries implements Dictionaries {
  const factory _Dictionaries({
    final Map<String, Location>? locations,
    final Map<String, String>? aircraft,
    final Map<String, String>? currencies,
    final Map<String, String>? carriers,
  }) = _$DictionariesImpl;

  factory _Dictionaries.fromJson(Map<String, dynamic> json) =
      _$DictionariesImpl.fromJson;

  @override
  Map<String, Location>? get locations;
  @override
  Map<String, String>? get aircraft;
  @override
  Map<String, String>? get currencies;
  @override
  Map<String, String>? get carriers;

  /// Create a copy of Dictionaries
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DictionariesImplCopyWith<_$DictionariesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Location _$LocationFromJson(Map<String, dynamic> json) {
  return _Location.fromJson(json);
}

/// @nodoc
mixin _$Location {
  String? get cityCode => throw _privateConstructorUsedError;
  String? get countryCode => throw _privateConstructorUsedError;

  /// Serializes this Location to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Location
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocationCopyWith<Location> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationCopyWith<$Res> {
  factory $LocationCopyWith(Location value, $Res Function(Location) then) =
      _$LocationCopyWithImpl<$Res, Location>;
  @useResult
  $Res call({String? cityCode, String? countryCode});
}

/// @nodoc
class _$LocationCopyWithImpl<$Res, $Val extends Location>
    implements $LocationCopyWith<$Res> {
  _$LocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Location
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? cityCode = freezed, Object? countryCode = freezed}) {
    return _then(
      _value.copyWith(
            cityCode: freezed == cityCode
                ? _value.cityCode
                : cityCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            countryCode: freezed == countryCode
                ? _value.countryCode
                : countryCode // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LocationImplCopyWith<$Res>
    implements $LocationCopyWith<$Res> {
  factory _$$LocationImplCopyWith(
    _$LocationImpl value,
    $Res Function(_$LocationImpl) then,
  ) = __$$LocationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? cityCode, String? countryCode});
}

/// @nodoc
class __$$LocationImplCopyWithImpl<$Res>
    extends _$LocationCopyWithImpl<$Res, _$LocationImpl>
    implements _$$LocationImplCopyWith<$Res> {
  __$$LocationImplCopyWithImpl(
    _$LocationImpl _value,
    $Res Function(_$LocationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Location
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? cityCode = freezed, Object? countryCode = freezed}) {
    return _then(
      _$LocationImpl(
        cityCode: freezed == cityCode
            ? _value.cityCode
            : cityCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        countryCode: freezed == countryCode
            ? _value.countryCode
            : countryCode // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LocationImpl implements _Location {
  const _$LocationImpl({this.cityCode, this.countryCode});

  factory _$LocationImpl.fromJson(Map<String, dynamic> json) =>
      _$$LocationImplFromJson(json);

  @override
  final String? cityCode;
  @override
  final String? countryCode;

  @override
  String toString() {
    return 'Location(cityCode: $cityCode, countryCode: $countryCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationImpl &&
            (identical(other.cityCode, cityCode) ||
                other.cityCode == cityCode) &&
            (identical(other.countryCode, countryCode) ||
                other.countryCode == countryCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, cityCode, countryCode);

  /// Create a copy of Location
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationImplCopyWith<_$LocationImpl> get copyWith =>
      __$$LocationImplCopyWithImpl<_$LocationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LocationImplToJson(this);
  }
}

abstract class _Location implements Location {
  const factory _Location({final String? cityCode, final String? countryCode}) =
      _$LocationImpl;

  factory _Location.fromJson(Map<String, dynamic> json) =
      _$LocationImpl.fromJson;

  @override
  String? get cityCode;
  @override
  String? get countryCode;

  /// Create a copy of Location
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocationImplCopyWith<_$LocationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

IncludedBags _$IncludedBagsFromJson(Map<String, dynamic> json) {
  return _IncludedBags.fromJson(json);
}

/// @nodoc
mixin _$IncludedBags {
  int? get quantity => throw _privateConstructorUsedError;
  int? get weight => throw _privateConstructorUsedError;
  String? get weightUnit => throw _privateConstructorUsedError;

  /// Serializes this IncludedBags to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IncludedBags
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IncludedBagsCopyWith<IncludedBags> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IncludedBagsCopyWith<$Res> {
  factory $IncludedBagsCopyWith(
    IncludedBags value,
    $Res Function(IncludedBags) then,
  ) = _$IncludedBagsCopyWithImpl<$Res, IncludedBags>;
  @useResult
  $Res call({int? quantity, int? weight, String? weightUnit});
}

/// @nodoc
class _$IncludedBagsCopyWithImpl<$Res, $Val extends IncludedBags>
    implements $IncludedBagsCopyWith<$Res> {
  _$IncludedBagsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IncludedBags
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? quantity = freezed,
    Object? weight = freezed,
    Object? weightUnit = freezed,
  }) {
    return _then(
      _value.copyWith(
            quantity: freezed == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int?,
            weight: freezed == weight
                ? _value.weight
                : weight // ignore: cast_nullable_to_non_nullable
                      as int?,
            weightUnit: freezed == weightUnit
                ? _value.weightUnit
                : weightUnit // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$IncludedBagsImplCopyWith<$Res>
    implements $IncludedBagsCopyWith<$Res> {
  factory _$$IncludedBagsImplCopyWith(
    _$IncludedBagsImpl value,
    $Res Function(_$IncludedBagsImpl) then,
  ) = __$$IncludedBagsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? quantity, int? weight, String? weightUnit});
}

/// @nodoc
class __$$IncludedBagsImplCopyWithImpl<$Res>
    extends _$IncludedBagsCopyWithImpl<$Res, _$IncludedBagsImpl>
    implements _$$IncludedBagsImplCopyWith<$Res> {
  __$$IncludedBagsImplCopyWithImpl(
    _$IncludedBagsImpl _value,
    $Res Function(_$IncludedBagsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of IncludedBags
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? quantity = freezed,
    Object? weight = freezed,
    Object? weightUnit = freezed,
  }) {
    return _then(
      _$IncludedBagsImpl(
        quantity: freezed == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int?,
        weight: freezed == weight
            ? _value.weight
            : weight // ignore: cast_nullable_to_non_nullable
                  as int?,
        weightUnit: freezed == weightUnit
            ? _value.weightUnit
            : weightUnit // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$IncludedBagsImpl implements _IncludedBags {
  const _$IncludedBagsImpl({this.quantity, this.weight, this.weightUnit});

  factory _$IncludedBagsImpl.fromJson(Map<String, dynamic> json) =>
      _$$IncludedBagsImplFromJson(json);

  @override
  final int? quantity;
  @override
  final int? weight;
  @override
  final String? weightUnit;

  @override
  String toString() {
    return 'IncludedBags(quantity: $quantity, weight: $weight, weightUnit: $weightUnit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IncludedBagsImpl &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.weightUnit, weightUnit) ||
                other.weightUnit == weightUnit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, quantity, weight, weightUnit);

  /// Create a copy of IncludedBags
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IncludedBagsImplCopyWith<_$IncludedBagsImpl> get copyWith =>
      __$$IncludedBagsImplCopyWithImpl<_$IncludedBagsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IncludedBagsImplToJson(this);
  }
}

abstract class _IncludedBags implements IncludedBags {
  const factory _IncludedBags({
    final int? quantity,
    final int? weight,
    final String? weightUnit,
  }) = _$IncludedBagsImpl;

  factory _IncludedBags.fromJson(Map<String, dynamic> json) =
      _$IncludedBagsImpl.fromJson;

  @override
  int? get quantity;
  @override
  int? get weight;
  @override
  String? get weightUnit;

  /// Create a copy of IncludedBags
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IncludedBagsImplCopyWith<_$IncludedBagsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
