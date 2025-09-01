import 'dart:ui';

import 'package:TFA/l10n/app_localizations.dart';
import 'package:TFA/providers/flight/flight_search_controller.dart';
import 'package:TFA/providers/menu_tab_provider.dart';
import 'package:TFA/screens/flight/guarantee_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeState();
}

class _HomeState extends ConsumerState<HomeScreen> {
  late FlightSearchController controller;

  @override
  void initState() {
    super.initState();
    controller = ref.read(flightSearchProvider.notifier);
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

    final locale = PlatformDispatcher.instance.locale.toString(); // e.g. en_US
    final format = NumberFormat.simpleCurrency(locale: locale);

    print('Locale: $locale');
    print('Symbol: ${format.currencySymbol}');
    print('Code: ${format.currencyName}');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 5,
        title: SizedBox(
          height: 36,
          child: TextField(
            onTap: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ref.read(menuTabProvider.notifier).state = MenuTab.search;
              });
            },
            style: TextStyle(fontSize: 14, color: cs.onSurface),
            decoration: InputDecoration(
              isDense: true, // Compact mode
              filled: true,
              fillColor: cs.surface,
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Icon(Icons.search, size: 18, color: cs.onSurface),
              hintText: text.where_do_you_want_to_go,
              hintStyle: TextStyle(fontSize: 14, color: cs.onSurface),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // 🟦 Horizontal destination categories
              SizedBox(
                height: 90,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: <Widget>[
                    // categoryChip(context, "Spotlight"),
                    categoryChip(context, "New York", "JFK"),
                    categoryChip(context, "Osaka", "KIX"),
                    categoryChip(context, "Singapore", "SIN"),
                    categoryChip(context, "Hong Kong", "HKG"),
                    categoryChip(context, "Shanghai", "SHA"),
                  ],
                ),
              ),

              // 🟦 Promotion Box
              Container(
                padding: const EdgeInsets.all(16),
                child: Material(
                  color: cs.primaryContainer, // Adaptive surface color
                  elevation: 5, // Theme-aware shadow
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                text.our_guarantee,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                text.automatic,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: cs.primary,
                                  foregroundColor: cs.onPrimary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (_) => const GuaranteeSheet(),
                                  );
                                },
                                child: Text(text.learn_more),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Material(
                          color: cs.primaryContainer, // Theme-aware surface
                          elevation: 5,
                          borderRadius: BorderRadius.circular(12),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.network(
                              'https://picsum.photos/seed/airplane/100/100',
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return Container(color: cs.surfaceVariant);
                              },
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.image_not_supported),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 🟦 Deals Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Material(
                  color: cs
                      .primaryContainer, // theme surface color (adapts to dark mode)
                  elevation: 5, // subtle theme-aware shadow
                  borderRadius: BorderRadius.circular(4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Text(
                          text.great_deals,
                          style: TextStyle(
                            fontSize: Theme.of(
                              context,
                            ).textTheme.headlineMedium?.fontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                        child: SizedBox(
                          height: 200,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.only(left: 16),
                            children: <Widget>[
                              Align(
                                alignment: Alignment.topLeft,
                                heightFactor: 1.0,
                                child: dealCard(
                                  context: context,
                                  title: 'NYC',
                                  seed: "JFK",
                                  date: 'Mon, Sep 22',
                                  imageUrl: '',
                                  originalPrice:
                                      '${format.currencySymbol}${format.format(325808)}',
                                  discountPrice:
                                      '${format.currencySymbol}${format.format(255101)}',
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                heightFactor: 1.0,
                                child: dealCard(
                                  context: context,
                                  title: 'Tokyo',
                                  date: 'Tue, Oct 16',
                                  seed: "HND",
                                  imageUrl: '',
                                  originalPrice:
                                      '${format.currencySymbol}${format.format(412000)}',
                                  discountPrice:
                                      '${format.currencySymbol}'
                                      '${format.format(322800)}',
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                heightFactor: 1.0,
                                child: dealCard(
                                  context: context,
                                  title: 'Shanghai',
                                  date: 'Tue, Oct 16',
                                  seed: "Shanghai",
                                  imageUrl: '',
                                  originalPrice:
                                      '${format.currencySymbol}${format.format(412000)}',
                                  discountPrice:
                                      '${format.currencySymbol}'
                                      '${format.format(322800)}',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget categoryChip(BuildContext context, String label, String iata) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () {
        controller.setArrivalCode(iata, label);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(menuTabProvider.notifier).state = MenuTab.search;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        width: 72,
        child: Column(
          children: <Widget>[
            Material(
              color: cs.surface, // theme surface color (adapts to dark mode)
              elevation: 5, // subtle theme-aware shadow
              borderRadius: BorderRadius.circular(90),
              child: CircleAvatar(
                radius: 28,
                backgroundColor: cs.surfaceContainerHighest,
                child: ClipOval(
                  child: Image.network(
                    'https://picsum.photos/seed/${label}/100/100',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.person),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget dealCard({
    required BuildContext context,
    required String title,
    required String date,
    required String imageUrl,
    required String originalPrice,
    required String discountPrice,
    required String seed,
  }) {
    final cs = Theme.of(context).colorScheme;

    return TextButton(
      onPressed: () {
        controller.setArrivalCode(seed, title);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(menuTabProvider.notifier).state = MenuTab.search;
        });
      },
      child: Material(
        color: cs.surface, // theme surface color (adapts to dark mode)
        elevation: 5, // subtle theme-aware shadow
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    'https://picsum.photos/seed/${seed}/200/150',
                    fit: BoxFit.cover,
                    // shows a simple loader color while fetching
                    loadingBuilder:
                        (
                          BuildContext context,
                          Widget child,
                          ImageChunkEvent? progress,
                        ) {
                          if (progress == null) return child;
                          return Container(color: Colors.black12);
                        },
                    // graceful fallback if 404/timeout/etc
                    errorBuilder: (_, __, ___) => const Icon(Icons.person),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.transparent, width: 1),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12, // subtle shadow color
                          blurRadius: 8, // softness of shadow
                          spreadRadius: 1, // how far it spreads
                          offset: Offset(0, 3), // x,y shift of shadow
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    child: Text(
                      title,
                      style: TextStyle(
                        color: cs.surface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.transparent, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: cs.errorContainer, // subtle shadow color
                          blurRadius: 8, // softness of shadow
                          spreadRadius: 1, // how far it spreads
                          offset: const Offset(0, 3), // x,y shift of shadow
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 0,
                    ),
                    child: Text(
                      '$originalPrice → $discountPrice',
                      style: TextStyle(
                        fontSize: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.fontSize,
                        fontWeight: FontWeight.bold,
                        color: cs.surface,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
