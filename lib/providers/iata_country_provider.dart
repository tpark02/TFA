import 'package:TFA/providers/airport/airport_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:TFA/models/airport.dart';

/// Enum for round trip pricing mode.
enum PricingMode {
  combined, // sum outbound + return price
  perLeg, // separate prices for each leg
}

// ✅ make it a FutureProvider so it waits for the CSV
final FutureProvider<Map<String, String>> iataCountryResolverProvider = FutureProvider<Map<String, String>>((
  FutureProviderRef<Map<String, String>> ref,
) async {
  final List<Airport> airports = await ref.watch(
    airportDataProvider.future,
  ); // wait
  final Map<String, String> map = <String, String>{};
  for (final Airport a in airports) {
    final String iata = a.iataCode.toUpperCase() ?? "";
    final String country = a.country.toUpperCase() ?? "";
    if (iata.isNotEmpty && country.isNotEmpty) map[iata] = country;
  }
  return map;
});

/// Provider to decide round trip pricing mode based on countries.
final FutureProviderFamily<PricingMode, (String, String)> roundTripModeProvider =
    FutureProvider.family<PricingMode, (String, String)>((FutureProviderRef<PricingMode> ref, (String, String) pair) async {
      final (String originIata, String destIata) = pair;
      final Map<String, String> iataToCountry = await ref.watch(
        iataCountryResolverProvider.future,
      );

      final String originCountry =
          (iataToCountry[originIata.toUpperCase()] ?? "");
      final String destCountry = (iataToCountry[destIata.toUpperCase()] ?? "");

      // Unknown => default to combined
      if (originCountry.isEmpty || destCountry.isEmpty) {
        return PricingMode.combined;
      }

      const Set<String> euCountries = <String>{
        "austria",
        "belgium",
        "bulgaria",
        "croatia",
        "cyprus",
        "czech republic",
        "denmark",
        "estonia",
        "finland",
        "france",
        "germany",
        "greece",
        "hungary",
        "ireland",
        "italy",
        "latvia",
        "lithuania",
        "luxembourg",
        "malta",
        "netherlands",
        "poland",
        "portugal",
        "romania",
        "slovakia",
        "slovenia",
        "spain",
        "sweden",
      };

      if (originCountry.toLowerCase().contains("united states") &&
          destCountry.toLowerCase().contains("united states")) {
        return PricingMode.perLeg;
      }
      if (euCountries.contains(originCountry.toLowerCase()) &&
          euCountries.contains(destCountry.toLowerCase())) {
        return PricingMode.perLeg;
      }

      return PricingMode.combined;
    });
