import 'dart:ui';
import 'package:TFA/l10n/app_localizations.dart';
import 'package:TFA/providers/flight/flight_search_controller.dart';
import 'package:TFA/providers/menu_tab_provider.dart';
import 'package:TFA/screens/flight/category_chip.dart';
import 'package:TFA/screens/flight/deal_card.dart';
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations text = AppLocalizations.of(context)!;
    final ColorScheme cs = Theme.of(context).colorScheme;

    final String locale = PlatformDispatcher.instance.locale.toString(); // e.g. en_US
    final NumberFormat format = NumberFormat.simpleCurrency(locale: locale);

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
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 0),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
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
                      const CategoryChip(label: "New York", iata: "JFK"),
                      const CategoryChip(label: "Osaka", iata: "KIX"),
                      const CategoryChip(label: "Singapore", iata: "SIN"),
                      const CategoryChip(label: "Hong Kong", iata: "HKG"),
                      const CategoryChip(label: "Shanghai", iata: "SHA"),
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
                                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? progress) {
                                  if (progress == null) return child;
                                  return Container(color: cs.surfaceContainerHighest);
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
                      children: <Widget>[
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
                                  child: DealCard(
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
                                  child: DealCard(
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
                                  child: DealCard(
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
      ),
    );
  }
}
