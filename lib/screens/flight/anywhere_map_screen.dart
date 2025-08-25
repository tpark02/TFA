// lib/screens/anywhere_map_screen.dart
import 'package:TFA/models/anywhere_destination.dart';
import 'package:TFA/providers/flight/anywhere_provider.dart';
import 'package:TFA/providers/flight/flight_search_controller.dart';
import 'package:TFA/providers/flight/flight_search_state.dart';
import 'package:TFA/screens/flight/anywhere_list_page.dart';
import 'package:TFA/widgets/flight/anywhere_destination_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

class AnywhereMapScreen extends ConsumerStatefulWidget {
  const AnywhereMapScreen({super.key});
  @override
  ConsumerState<AnywhereMapScreen> createState() {
    return _AnyWhereMapState();
  }
}

class _AnyWhereMapState extends ConsumerState<AnywhereMapScreen>
    with TickerProviderStateMixin {
  late final ScrollController _scrollController;
  final MapController _mapController = MapController();
  String? _selectedCode;

  void animatedMapMove(LatLng dest, double zoom) {
    final Tween<double> latTween = Tween<double>(
      begin: _mapController.center.latitude,
      end: dest.latitude,
    );
    final Tween<double> lngTween = Tween<double>(
      begin: _mapController.center.longitude,
      end: dest.longitude,
    );
    final Tween<double> zoomTween = Tween<double>(
      begin: _mapController.camera.zoom,
      end: zoom,
    );

    final AnimationController controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    final Animation<double> animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );

    controller.addListener(() {
      _mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
      );
    });

    controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, Object>> pricePoints = <Map<String, Object>>[
      <String, Object>{
        "lat": 37.5665,
        "lng": 126.9780,
        "price": "₩380,000",
        "code": "SEL", // Seoul
      },
      <String, Object>{
        "lat": 35.6895,
        "lng": 139.6917,
        "price": "₩639,500",
        "code": "TYO", // Tokyo
      },
      <String, Object>{
        "lat": 40.7128,
        "lng": -74.0060,
        "price": "₩1,175,000",
        "code": "NYC", // New York City
      },
      <String, Object>{
        "lat": 34.6937,
        "lng": 135.5023,
        "price": "₩159,183",
        "code": "OSA", // Osaka
      },
      <String, Object>{
        "lat": 1.3521,
        "lng": 103.8198,
        "price": "₩328,055",
        "code": "SIN", // Singapore
      },
      <String, Object>{
        "lat": 22.3193,
        "lng": 114.1694,
        "price": "₩336,360",
        "code": "HKG", // Hong Kong
      },
      <String, Object>{
        "lat": 31.2304,
        "lng": 121.4737,
        "price": "₩349,990",
        "code": "SHA", // Shanghai
      },
    ];

    final FlightSearchState flightState = ref.watch(flightSearchProvider);
    final AsyncValue<List<AnywhereDestination>> tiles = ref.watch(
      anywhereDestinationsProvider,
    );
    final List<AnywhereDestination> destinations =
        tiles.asData?.value ?? <AnywhereDestination>[];
    final FlightSearchController controller = ref.read(
      flightSearchProvider.notifier,
    );

    return Column(
      children: <Widget>[
        // 🔹 Top Summary Row (Back + SummaryCard + Icons)
        // Container(
        //   color: Theme.of(context).colorScheme.primary,
        //   padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //     children: <Widget>[
        //       InkWell(
        //         onTap: () => Navigator.of(context).pop(),
        //         child: const Icon(Icons.arrow_back_ios, color: Colors.white),
        //       ),
        //       SizedBox(
        //         width: 250,
        //         child: SearchSummaryCard(
        //           from: flightState.departureAirportCode,
        //           to: flightState.arrivalAirportCode,
        //           dateRange: flightState.displayDate ?? '',
        //           passengerCount: flightState.passengerCount,
        //           cabinClass: flightState.cabinClass,
        //         ),
        //       ),
        //       InkWell(
        //         onTap: () => Navigator.of(context).push(
        //           MaterialPageRoute<void>(
        //             builder: (_) => const AnywhereMapScreen(),
        //           ),
        //         ),
        //         child: const Icon(Icons.list, color: Colors.white),
        //       ),
        //       const Icon(Icons.share, color: Colors.white),
        //     ],
        //   ),
        // ),

        // 🔹 Expanded Map
        Expanded(
          child: Stack(
            children: <Widget>[
              FlutterMap(
                mapController: _mapController,
                options: const MapOptions(
                  center: LatLng(20.0, 100.0),
                  zoom: 2.5,
                  maxZoom: 10,
                  minZoom: 1.5,
                ),
                children: <Widget>[
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.tfa',
                  ),
                  MarkerLayer(
                    markers:
                        <Map<String, Object>>[
                          ...pricePoints.where(
                            (Map<String, Object> p) =>
                                p['code'] != _selectedCode,
                          ),
                          ...pricePoints.where(
                            (Map<String, Object> p) =>
                                p['code'] == _selectedCode,
                          ),
                        ].map((Map<String, Object> point) {
                          final bool isSelected =
                              _selectedCode == point['code'];

                          return Marker(
                            point: LatLng(
                              point['lat'] as double,
                              point['lng'] as double,
                            ),
                            width: 120,
                            height: 40,
                            child: GestureDetector(
                              onTap: () {
                                final int index = destinations.indexWhere(
                                  (AnywhereDestination d) =>
                                      d.code == point['code'],
                                );
                                if (index != -1) {
                                  final double tileWidth =
                                      MediaQuery.of(context).size.width * 0.9;
                                  const double spacing = 30;
                                  _scrollController.animateTo(
                                    index * (tileWidth + spacing),
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                  setState(
                                    () =>
                                        _selectedCode = point['code'] as String,
                                  );
                                  final double lat = point['lat'] as double;
                                  final double lng = point['lng'] as double;

                                  final LatLng dest = LatLng(lat, lng);

                                  animatedMapMove(
                                    dest,
                                    _mapController.camera.zoom,
                                  ); // 🟢 smooth pan
                                  _mapController.move(
                                    LatLng(lat, lng),
                                    _mapController
                                        .camera
                                        .zoom, // 🟢 Keep current zoom
                                  );
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.blue
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: const <BoxShadow>[
                                    BoxShadow(
                                      blurRadius: 2,
                                      color: Colors.black26,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  point['price'] as String,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ],
              ),

              // 🟦 Destination Tile Overlay (bottom of map)
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                // child: Container(
                //   padding: const EdgeInsets.all(12),
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.circular(16),
                //     boxShadow: const [
                //       BoxShadow(blurRadius: 6, color: Colors.black26),
                //     ],
                //   ),
                //   child: Row(
                //     children: [
                //       // 🖼 Destination image
                //       ClipRRect(
                //         borderRadius: BorderRadius.circular(12),
                //         child: Image.network(
                //           'https://picsum.photos/seed/hyderabad/120/80',
                //           width: 100,
                //           height: 80,
                //           fit: BoxFit.cover,
                //         ),
                //       ),
                //       const SizedBox(width: 12),

                //       // 📍 Destination name + price
                //       const Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Text(
                //             'Hyderabad',
                //             style: TextStyle(
                //               fontWeight: FontWeight.bold,
                //               fontSize: 16,
                //             ),
                //           ),
                //           SizedBox(height: 4),
                //           Text(
                //             'FROM ₩860,972',
                //             style: TextStyle(
                //               fontSize: 14,
                //               color: Colors.blue,
                //               fontWeight: FontWeight.w500,
                //             ),
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
                child: SizedBox(
                  height: AnywhereDestinationTile.height,
                  child: tiles.when(
                    data: (List<AnywhereDestination> items) => ListView.separated(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 8,
                      ),
                      itemCount: items.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 30),
                      itemBuilder: (BuildContext context, int i) => SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: AnywhereDestinationTile(
                          item: items[i],
                          onTap: () {
                            debugPrint(
                              '☘️ anywhere_map_screen.dart - Tapped: ${items[i].name}',
                            );
                            controller.setArrivalCode(
                              items[i].iata,
                              items[i].name,
                            );
                            // controller.setArrivalCity(items[i].name);
                          },
                        ),
                      ),
                    ),
                    loading: () => ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 8,
                      ),
                      itemCount: 6,
                      separatorBuilder: (_, _) => const SizedBox(width: 30),
                      itemBuilder: (_, _) => const SkeletonCard(),
                    ),
                    error: (Object e, _) =>
                        Center(child: Text('Failed to load: $e')),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
