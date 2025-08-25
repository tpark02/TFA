// lib/providers/anywhere_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:TFA/models/anywhere_destination.dart';

final FutureProvider<List<AnywhereDestination>> anywhereDestinationsProvider =
    FutureProvider<List<AnywhereDestination>>((
      FutureProviderRef<List<AnywhereDestination>> ref,
    ) async {
      // TODO: replace with your backend call
      await Future.delayed(const Duration(milliseconds: 200));
      // lib/providers/flight/anywhere_provider.dart
      // 🟢 FIX: swap to picsum.photos seeds (stable)
      return const <AnywhereDestination>[
        AnywhereDestination(
          id: 'osa',
          name: 'Osaka',
          imageUrl: 'https://picsum.photos/seed/osaka/800/800',
          minPriceKrw: 159183,
          code: "OSA", // Osaka
          iata: "KIX", // Kansai International
        ),
        AnywhereDestination(
          id: 'nyc',
          name: 'New York City',
          imageUrl: 'https://picsum.photos/seed/manila/800/800',
          minPriceKrw: 251924,
          code: "NYC",
          iata: "JFK", // John F. Kennedy
        ),
        AnywhereDestination(
          id: 'sin',
          name: 'Singapore',
          imageUrl: 'https://picsum.photos/seed/singapore/800/800',
          minPriceKrw: 328055,
          code: "SIN",
          iata: "SIN", // Singapore Changi
        ),
        AnywhereDestination(
          id: 'hkg',
          name: 'Hong Kong',
          imageUrl: 'https://picsum.photos/seed/hongkong/800/800',
          minPriceKrw: 336360,
          code: "HKG",
          iata: "HKG", // Hong Kong Intl
        ),
        AnywhereDestination(
          id: 'sha',
          name: 'Shanghai',
          imageUrl: 'https://picsum.photos/seed/shanghai/800/800',
          minPriceKrw: 349990,
          code: "SHA",
          iata: "PVG", // Shanghai Pudong
        ),
        AnywhereDestination(
          id: 'tyo',
          name: 'Tokyo',
          imageUrl: 'https://picsum.photos/seed/tokyo/800/800',
          minPriceKrw: 639500,
          code: "TYO",
          iata: "HND", // Haneda
        ),
        AnywhereDestination(
          id: 'sel',
          name: 'Seoul',
          imageUrl: 'https://picsum.photos/seed/seoul/800/800',
          minPriceKrw: 380000,
          code: "SEL",
          iata: "ICN", // Incheon
        ),
      ];
    });
