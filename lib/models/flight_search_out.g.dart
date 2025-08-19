// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flight_search_out.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FlightSearchOutImpl _$$FlightSearchOutImplFromJson(
  Map<String, dynamic> json,
) => _$FlightSearchOutImpl(
  meta: json['meta'] == null
      ? null
      : Meta.fromJson(json['meta'] as Map<String, dynamic>),
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => FlightOffer.fromJson(e as Map<String, dynamic>))
      .toList(),
  dictionaries: json['dictionaries'] == null
      ? null
      : Dictionaries.fromJson(json['dictionaries'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$FlightSearchOutImplToJson(
  _$FlightSearchOutImpl instance,
) => <String, dynamic>{
  'meta': instance.meta,
  'data': instance.data,
  'dictionaries': instance.dictionaries,
};

_$MetaImpl _$$MetaImplFromJson(Map<String, dynamic> json) => _$MetaImpl(
  count: (json['count'] as num?)?.toInt(),
  links: json['links'] == null
      ? null
      : MetaLinks.fromJson(json['links'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$MetaImplToJson(_$MetaImpl instance) =>
    <String, dynamic>{'count': instance.count, 'links': instance.links};

_$MetaLinksImpl _$$MetaLinksImplFromJson(Map<String, dynamic> json) =>
    _$MetaLinksImpl(self: json['self'] as String?);

Map<String, dynamic> _$$MetaLinksImplToJson(_$MetaLinksImpl instance) =>
    <String, dynamic>{'self': instance.self};

_$FlightOfferImpl _$$FlightOfferImplFromJson(Map<String, dynamic> json) =>
    _$FlightOfferImpl(
      type: json['type'] as String?,
      id: json['id'] as String?,
      source: json['source'] as String?,
      instantTicketingRequired: json['instantTicketingRequired'] as bool?,
      nonHomogeneous: json['nonHomogeneous'] as bool?,
      oneWay: json['oneWay'] as bool?,
      isUpsellOffer: json['isUpsellOffer'] as bool?,
      lastTicketingDate: json['lastTicketingDate'] as String?,
      lastTicketingDateTime: json['lastTicketingDateTime'] as String?,
      numberOfBookableSeats: (json['numberOfBookableSeats'] as num?)?.toInt(),
      itineraries: (json['itineraries'] as List<dynamic>?)
          ?.map((e) => Itinerary.fromJson(e as Map<String, dynamic>))
          .toList(),
      price: json['price'] == null
          ? null
          : Price.fromJson(json['price'] as Map<String, dynamic>),
      pricingOptions: json['pricingOptions'] == null
          ? null
          : PricingOptions.fromJson(
              json['pricingOptions'] as Map<String, dynamic>,
            ),
      validatingAirlineCodes: (json['validatingAirlineCodes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      travelerPricings: (json['travelerPricings'] as List<dynamic>?)
          ?.map((e) => TravelerPricing.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$FlightOfferImplToJson(_$FlightOfferImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'id': instance.id,
      'source': instance.source,
      'instantTicketingRequired': instance.instantTicketingRequired,
      'nonHomogeneous': instance.nonHomogeneous,
      'oneWay': instance.oneWay,
      'isUpsellOffer': instance.isUpsellOffer,
      'lastTicketingDate': instance.lastTicketingDate,
      'lastTicketingDateTime': instance.lastTicketingDateTime,
      'numberOfBookableSeats': instance.numberOfBookableSeats,
      'itineraries': instance.itineraries,
      'price': instance.price,
      'pricingOptions': instance.pricingOptions,
      'validatingAirlineCodes': instance.validatingAirlineCodes,
      'travelerPricings': instance.travelerPricings,
    };

_$ItineraryImpl _$$ItineraryImplFromJson(Map<String, dynamic> json) =>
    _$ItineraryImpl(
      duration: json['duration'] as String?,
      segments: (json['segments'] as List<dynamic>?)
          ?.map((e) => Segment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ItineraryImplToJson(_$ItineraryImpl instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      'segments': instance.segments,
    };

_$SegmentImpl _$$SegmentImplFromJson(Map<String, dynamic> json) =>
    _$SegmentImpl(
      departure: json['departure'] == null
          ? null
          : DepartureArrival.fromJson(
              json['departure'] as Map<String, dynamic>,
            ),
      arrival: json['arrival'] == null
          ? null
          : DepartureArrival.fromJson(json['arrival'] as Map<String, dynamic>),
      carrierCode: json['carrierCode'] as String?,
      number: json['number'] as String?,
      aircraft: json['aircraft'] == null
          ? null
          : Aircraft.fromJson(json['aircraft'] as Map<String, dynamic>),
      operating: json['operating'] == null
          ? null
          : Operating.fromJson(json['operating'] as Map<String, dynamic>),
      duration: json['duration'] as String?,
      id: json['id'] as String?,
      numberOfStops: (json['numberOfStops'] as num?)?.toInt(),
      blacklistedInEU: json['blacklistedInEU'] as bool?,
    );

Map<String, dynamic> _$$SegmentImplToJson(_$SegmentImpl instance) =>
    <String, dynamic>{
      'departure': instance.departure,
      'arrival': instance.arrival,
      'carrierCode': instance.carrierCode,
      'number': instance.number,
      'aircraft': instance.aircraft,
      'operating': instance.operating,
      'duration': instance.duration,
      'id': instance.id,
      'numberOfStops': instance.numberOfStops,
      'blacklistedInEU': instance.blacklistedInEU,
    };

_$DepartureArrivalImpl _$$DepartureArrivalImplFromJson(
  Map<String, dynamic> json,
) => _$DepartureArrivalImpl(
  iataCode: json['iataCode'] as String?,
  terminal: json['terminal'] as String?,
  at: json['at'] as String?,
);

Map<String, dynamic> _$$DepartureArrivalImplToJson(
  _$DepartureArrivalImpl instance,
) => <String, dynamic>{
  'iataCode': instance.iataCode,
  'terminal': instance.terminal,
  'at': instance.at,
};

_$AircraftImpl _$$AircraftImplFromJson(Map<String, dynamic> json) =>
    _$AircraftImpl(code: json['code'] as String?);

Map<String, dynamic> _$$AircraftImplToJson(_$AircraftImpl instance) =>
    <String, dynamic>{'code': instance.code};

_$OperatingImpl _$$OperatingImplFromJson(Map<String, dynamic> json) =>
    _$OperatingImpl(carrierCode: json['carrierCode'] as String?);

Map<String, dynamic> _$$OperatingImplToJson(_$OperatingImpl instance) =>
    <String, dynamic>{'carrierCode': instance.carrierCode};

_$PriceImpl _$$PriceImplFromJson(Map<String, dynamic> json) => _$PriceImpl(
  currency: json['currency'] as String?,
  total: json['total'] as String?,
  base: json['base'] as String?,
  fees: (json['fees'] as List<dynamic>?)
      ?.map((e) => Fee.fromJson(e as Map<String, dynamic>))
      .toList(),
  grandTotal: json['grandTotal'] as String?,
  additionalServices: (json['additionalServices'] as List<dynamic>?)
      ?.map((e) => AdditionalService.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$PriceImplToJson(_$PriceImpl instance) =>
    <String, dynamic>{
      'currency': instance.currency,
      'total': instance.total,
      'base': instance.base,
      'fees': instance.fees,
      'grandTotal': instance.grandTotal,
      'additionalServices': instance.additionalServices,
    };

_$FeeImpl _$$FeeImplFromJson(Map<String, dynamic> json) =>
    _$FeeImpl(amount: json['amount'] as String?, type: json['type'] as String?);

Map<String, dynamic> _$$FeeImplToJson(_$FeeImpl instance) => <String, dynamic>{
  'amount': instance.amount,
  'type': instance.type,
};

_$AdditionalServiceImpl _$$AdditionalServiceImplFromJson(
  Map<String, dynamic> json,
) => _$AdditionalServiceImpl(
  amount: json['amount'] as String?,
  type: json['type'] as String?,
);

Map<String, dynamic> _$$AdditionalServiceImplToJson(
  _$AdditionalServiceImpl instance,
) => <String, dynamic>{'amount': instance.amount, 'type': instance.type};

_$PricingOptionsImpl _$$PricingOptionsImplFromJson(Map<String, dynamic> json) =>
    _$PricingOptionsImpl(
      fareType: (json['fareType'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      includedCheckedBagsOnly: json['includedCheckedBagsOnly'] as bool?,
    );

Map<String, dynamic> _$$PricingOptionsImplToJson(
  _$PricingOptionsImpl instance,
) => <String, dynamic>{
  'fareType': instance.fareType,
  'includedCheckedBagsOnly': instance.includedCheckedBagsOnly,
};

_$TravelerPricingImpl _$$TravelerPricingImplFromJson(
  Map<String, dynamic> json,
) => _$TravelerPricingImpl(
  travelerId: json['travelerId'] as String?,
  fareOption: json['fareOption'] as String?,
  travelerType: json['travelerType'] as String?,
  price: json['price'] == null
      ? null
      : Price.fromJson(json['price'] as Map<String, dynamic>),
  fareDetailsBySegment: (json['fareDetailsBySegment'] as List<dynamic>?)
      ?.map((e) => FareDetailsBySegment.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$TravelerPricingImplToJson(
  _$TravelerPricingImpl instance,
) => <String, dynamic>{
  'travelerId': instance.travelerId,
  'fareOption': instance.fareOption,
  'travelerType': instance.travelerType,
  'price': instance.price,
  'fareDetailsBySegment': instance.fareDetailsBySegment,
};

_$FareDetailsBySegmentImpl _$$FareDetailsBySegmentImplFromJson(
  Map<String, dynamic> json,
) => _$FareDetailsBySegmentImpl(
  segmentId: json['segmentId'] as String?,
  cabin: json['cabin'] as String?,
  fareBasis: json['fareBasis'] as String?,
  class_: json['class'] as String?,
  includedCheckedBags: json['includedCheckedBags'] == null
      ? null
      : IncludedBags.fromJson(
          json['includedCheckedBags'] as Map<String, dynamic>,
        ),
  includedCabinBags: json['includedCabinBags'] == null
      ? null
      : IncludedBags.fromJson(
          json['includedCabinBags'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$$FareDetailsBySegmentImplToJson(
  _$FareDetailsBySegmentImpl instance,
) => <String, dynamic>{
  'segmentId': instance.segmentId,
  'cabin': instance.cabin,
  'fareBasis': instance.fareBasis,
  'class': instance.class_,
  'includedCheckedBags': instance.includedCheckedBags,
  'includedCabinBags': instance.includedCabinBags,
};

_$IncludedCheckedBagsImpl _$$IncludedCheckedBagsImplFromJson(
  Map<String, dynamic> json,
) => _$IncludedCheckedBagsImpl(
  quantity: (json['quantity'] as num?)?.toInt(),
  weight: (json['weight'] as num?)?.toInt(),
  weightUnit: json['weightUnit'] as String?,
);

Map<String, dynamic> _$$IncludedCheckedBagsImplToJson(
  _$IncludedCheckedBagsImpl instance,
) => <String, dynamic>{
  'quantity': instance.quantity,
  'weight': instance.weight,
  'weightUnit': instance.weightUnit,
};

_$DictionariesImpl _$$DictionariesImplFromJson(Map<String, dynamic> json) =>
    _$DictionariesImpl(
      locations: (json['locations'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, Location.fromJson(e as Map<String, dynamic>)),
      ),
      aircraft: (json['aircraft'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      currencies: (json['currencies'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      carriers: (json['carriers'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$$DictionariesImplToJson(_$DictionariesImpl instance) =>
    <String, dynamic>{
      'locations': instance.locations,
      'aircraft': instance.aircraft,
      'currencies': instance.currencies,
      'carriers': instance.carriers,
    };

_$LocationImpl _$$LocationImplFromJson(Map<String, dynamic> json) =>
    _$LocationImpl(
      cityCode: json['cityCode'] as String?,
      countryCode: json['countryCode'] as String?,
    );

Map<String, dynamic> _$$LocationImplToJson(_$LocationImpl instance) =>
    <String, dynamic>{
      'cityCode': instance.cityCode,
      'countryCode': instance.countryCode,
    };

_$IncludedBagsImpl _$$IncludedBagsImplFromJson(Map<String, dynamic> json) =>
    _$IncludedBagsImpl(
      quantity: (json['quantity'] as num?)?.toInt(),
      weight: (json['weight'] as num?)?.toInt(),
      weightUnit: json['weightUnit'] as String?,
    );

Map<String, dynamic> _$$IncludedBagsImplToJson(_$IncludedBagsImpl instance) =>
    <String, dynamic>{
      'quantity': instance.quantity,
      'weight': instance.weight,
      'weightUnit': instance.weightUnit,
    };
