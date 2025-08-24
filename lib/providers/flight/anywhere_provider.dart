// lib/providers/anywhere_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:TFA/models/anywhere_destination.dart';

final anywhereDestinationsProvider = FutureProvider<List<AnywhereDestination>>((
  ref,
) async {
  // TODO: replace with your backend call
  await Future.delayed(const Duration(milliseconds: 200));
  // lib/providers/flight/anywhere_provider.dart
  // 🟢 FIX: swap to picsum.photos seeds (stable)
  return const [
    AnywhereDestination(
      id: 'osa',
      name: 'Osaka',
      imageUrl: 'https://picsum.photos/seed/osaka/800/800',
      minPriceKrw: 159183,
    ),
    AnywhereDestination(
      id: 'mnl',
      name: 'Manila Pasay',
      imageUrl: 'https://picsum.photos/seed/manila/800/800',
      minPriceKrw: 251924,
    ),
    AnywhereDestination(
      id: 'sin',
      name: 'Singapore',
      imageUrl: 'https://picsum.photos/seed/singapore/800/800',
      minPriceKrw: 328055,
    ),
    AnywhereDestination(
      id: 'hkg',
      name: 'Hong Kong',
      imageUrl: 'https://picsum.photos/seed/hongkong/800/800',
      minPriceKrw: 336360,
    ),
    AnywhereDestination(
      id: 'sha',
      name: 'Shanghai Minhang',
      imageUrl: 'https://picsum.photos/seed/shanghai/800/800',
      minPriceKrw: 349990,
    ),
  ];
});
