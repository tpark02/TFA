import 'package:freezed_annotation/freezed_annotation.dart';

part 'flight_search_out.freezed.dart';
part 'flight_search_out.g.dart';

@freezed
class FlightSearchOut with _$FlightSearchOut {
  const factory FlightSearchOut({
    required Meta meta,
    required List<FlightOffer> data,
    required Dictionaries dictionaries,
  }) = _FlightSearchOut;

  factory FlightSearchOut.fromJson(Map<String, dynamic> json) =>
      _$FlightSearchOutFromJson(json);
}

@freezed
class Meta with _$Meta {
  const factory Meta({int? count, MetaLinks? links}) = _Meta;

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);
}

@freezed
class MetaLinks with _$MetaLinks {
  const factory MetaLinks({String? self}) = _MetaLinks;

  factory MetaLinks.fromJson(Map<String, dynamic> json) =>
      _$MetaLinksFromJson(json);
}

@freezed
class FlightOffer with _$FlightOffer {
  const factory FlightOffer({
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
  }) = _FlightOffer;

  factory FlightOffer.fromJson(Map<String, dynamic> json) =>
      _$FlightOfferFromJson(json);
}

@freezed
class Itinerary with _$Itinerary {
  const factory Itinerary({String? duration, List<Segment>? segments}) =
      _Itinerary;

  factory Itinerary.fromJson(Map<String, dynamic> json) =>
      _$ItineraryFromJson(json);
}

@freezed
class Segment with _$Segment {
  const factory Segment({
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
  }) = _Segment;

  factory Segment.fromJson(Map<String, dynamic> json) =>
      _$SegmentFromJson(json);
}

@freezed
class DepartureArrival with _$DepartureArrival {
  const factory DepartureArrival({
    String? iataCode,
    String? terminal,
    String? at,
  }) = _DepartureArrival;

  factory DepartureArrival.fromJson(Map<String, dynamic> json) =>
      _$DepartureArrivalFromJson(json);
}

@freezed
class Aircraft with _$Aircraft {
  const factory Aircraft({String? code}) = _Aircraft;

  factory Aircraft.fromJson(Map<String, dynamic> json) =>
      _$AircraftFromJson(json);
}

@freezed
class Operating with _$Operating {
  const factory Operating({String? carrierCode}) = _Operating;

  factory Operating.fromJson(Map<String, dynamic> json) =>
      _$OperatingFromJson(json);
}

@freezed
class Price with _$Price {
  const factory Price({
    String? currency,
    String? total,
    String? base,
    List<Fee>? fees,
    String? grandTotal,
    List<AdditionalService>? additionalServices,
  }) = _Price;

  factory Price.fromJson(Map<String, dynamic> json) => _$PriceFromJson(json);
}

@freezed
class Fee with _$Fee {
  const factory Fee({String? amount, String? type}) = _Fee;

  factory Fee.fromJson(Map<String, dynamic> json) => _$FeeFromJson(json);
}

@freezed
class AdditionalService with _$AdditionalService {
  const factory AdditionalService({String? amount, String? type}) =
      _AdditionalService;

  factory AdditionalService.fromJson(Map<String, dynamic> json) =>
      _$AdditionalServiceFromJson(json);
}

@freezed
class PricingOptions with _$PricingOptions {
  const factory PricingOptions({
    List<String>? fareType,
    bool? includedCheckedBagsOnly,
  }) = _PricingOptions;

  factory PricingOptions.fromJson(Map<String, dynamic> json) =>
      _$PricingOptionsFromJson(json);
}

@freezed
class TravelerPricing with _$TravelerPricing {
  const factory TravelerPricing({
    String? travelerId,
    String? fareOption,
    String? travelerType,
    Price? price,
    List<FareDetailsBySegment>? fareDetailsBySegment,
  }) = _TravelerPricing;

  factory TravelerPricing.fromJson(Map<String, dynamic> json) =>
      _$TravelerPricingFromJson(json);
}

@freezed
class FareDetailsBySegment with _$FareDetailsBySegment {
  const factory FareDetailsBySegment({
    String? segmentId,
    String? cabin,
    String? fareBasis,
    @JsonKey(name: 'class') String? class_,
    IncludedBags? includedCheckedBags,
    IncludedBags? includedCabinBags,
  }) = _FareDetailsBySegment;

  factory FareDetailsBySegment.fromJson(Map<String, dynamic> json) =>
      _$FareDetailsBySegmentFromJson(json);
}

@freezed
class IncludedCheckedBags with _$IncludedCheckedBags {
  const factory IncludedCheckedBags({
    int? quantity,
    int? weight,
    String? weightUnit,
  }) = _IncludedCheckedBags;

  factory IncludedCheckedBags.fromJson(Map<String, dynamic> json) =>
      _$IncludedCheckedBagsFromJson(json);
}

@freezed
class Dictionaries with _$Dictionaries {
  const factory Dictionaries({
    required Map<String, Location> locations,
    required Map<String, String> aircraft,
    required Map<String, String> currencies,
    required Map<String, String> carriers,
  }) = _Dictionaries;

  factory Dictionaries.fromJson(Map<String, dynamic> json) =>
      _$DictionariesFromJson(json);
}

@freezed
class Location with _$Location {
  const factory Location({String? cityCode, String? countryCode}) = _Location;

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
}

@freezed
class IncludedBags with _$IncludedBags {
  const factory IncludedBags({int? quantity, int? weight, String? weightUnit}) =
      _IncludedBags;

  factory IncludedBags.fromJson(Map<String, dynamic> json) =>
      _$IncludedBagsFromJson(json);
}
