import 'package:TFA/providers/flight/flight_search_controller.dart';
import 'package:TFA/providers/flight/flight_search_state.dart';
import 'package:TFA/providers/menu_tab_provider.dart';
import 'package:TFA/screens/flight/flight_list_page.dart';
import 'package:TFA/screens/flight/flight_page.dart';
import 'package:TFA/widgets/flight/flight_list_view.dart';
import 'package:TFA/widgets/flight/guarantee_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        title: SizedBox(
          height: 36,
          child: TextField(
            onTap: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ref.read(menuTabProvider.notifier).state = MenuTab.search;
              });
            },
            style: const TextStyle(fontSize: 14, color: Colors.white),
            decoration: InputDecoration(
              isDense: true, // Compact mode
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(
                Icons.search,
                size: 18,
                color: Colors.black54,
              ),
              hintText: 'Where do you want to go?',
              hintStyle: const TextStyle(fontSize: 14, color: Colors.black54),
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
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
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

                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Introducing',
                            style: TextStyle(
                              fontSize: Theme.of(
                                context,
                              ).textTheme.bodySmall?.fontSize,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Our Guarantee',
                            style: TextStyle(
                              fontSize: Theme.of(
                                context,
                              ).textTheme.headlineMedium?.fontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Automatic protection included with every ticket at no extra cost.',
                            style: TextStyle(
                              fontSize: Theme.of(
                                context,
                              ).textTheme.bodySmall?.fontSize,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors
                                    .transparent, // rounded corners visible
                                builder: (_) => const GuaranteeSheet(),
                              );
                            },
                            child: const Text(
                              'Learn More',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          'https://picsum.photos/seed/airplane/100/100',
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
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.person),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 🟦 Deals Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Text(
                          'Great Deals',
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
                                  originalPrice: '₩325,808',
                                  discountPrice: '₩255,101',
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
                                  originalPrice: '₩412,000',
                                  discountPrice: '₩322,800',
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
                                  originalPrice: '₩412,000',
                                  discountPrice: '₩322,800',
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
    return InkWell(
      onTap: () {
        controller.setArrivalCode(iata, label);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        width: 72,
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(90),
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
              child: CircleAvatar(
                radius: 28,
                backgroundColor: Colors.grey.shade200,
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
    return TextButton(
      onPressed: () {
        controller.setArrivalCode(seed, title);
        // WidgetsBinding.instance.addPostFrameCallback((_) {
        // Navigator.of(context).push(
        //   MaterialPageRoute<void>(builder: (_) => const FlightListPage()),
        // );
        // });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.transparent, width: 1),
          boxShadow: [
            const BoxShadow(
              color: Colors.black12, // subtle shadow color
              blurRadius: 8, // softness of shadow
              spreadRadius: 1, // how far it spreads
              offset: Offset(0, 3), // x,y shift of shadow
            ),
          ],
        ),
        width: 200,
        margin: const EdgeInsets.only(right: 16),
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
                      style: const TextStyle(
                        color: Colors.white,
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
                      vertical: 0,
                    ),
                    child: Text(
                      '$originalPrice → $discountPrice',
                      style: TextStyle(
                        fontSize: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.fontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
