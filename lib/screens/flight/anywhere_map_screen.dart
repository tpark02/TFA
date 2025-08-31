import 'dart:math' as math;
import 'package:TFA/models/anywhere_destination.dart';
import 'package:TFA/providers/flight/anywhere_provider.dart';
import 'package:TFA/providers/flight/flight_search_controller.dart';
import 'package:TFA/screens/flight/anywhere_destination_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:TFA/screens/flight/anywhere_list_page.dart' show SkeletonCard;

class AnywhereMapScreen extends ConsumerStatefulWidget {
  const AnywhereMapScreen({super.key});
  @override
  ConsumerState<AnywhereMapScreen> createState() => _AnywhereMapState();
}

class _AnywhereMapState extends ConsumerState<AnywhereMapScreen>
    with TickerProviderStateMixin {
  late final ScrollController _scrollController;
  final MapController _mapController = MapController();
  final ValueNotifier<String?> _selectedCode = ValueNotifier<String?>(null);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _selectedCode.dispose();
    super.dispose();
  }

  void _animateMapMove(LatLng dest, double toZoom) {
    final beginCenter = _mapController.center;
    final beginZoom = _mapController.camera.zoom;
    final latTween = Tween<double>(
      begin: beginCenter.latitude,
      end: dest.latitude,
    );
    final lngTween = Tween<double>(
      begin: beginCenter.longitude,
      end: dest.longitude,
    );
    final zoomTween = Tween<double>(begin: beginZoom, end: toZoom);
    final controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    final curve = CurvedAnimation(parent: controller, curve: Curves.easeInOut);
    controller.addListener(() {
      _mapController.move(
        LatLng(latTween.evaluate(curve), lngTween.evaluate(curve)),
        zoomTween.evaluate(curve),
      );
    });
    controller.addStatusListener((s) {
      if (s == AnimationStatus.completed || s == AnimationStatus.dismissed)
        controller.dispose();
    });
    controller.forward();
  }

  static const _pricePoints =
      <({double lat, double lng, String price, String code})>[
        (lat: 37.5665, lng: 126.9780, price: '₩380,000', code: 'SEL'),
        (lat: 35.6895, lng: 139.6917, price: '₩639,500', code: 'TYO'),
        (lat: 40.7128, lng: -74.0060, price: '₩1,175,000', code: 'NYC'),
        (lat: 34.6937, lng: 135.5023, price: '₩159,183', code: 'OSA'),
        (lat: 1.3521, lng: 103.8198, price: '₩328,055', code: 'SIN'),
        (lat: 22.3193, lng: 114.1694, price: '₩336,360', code: 'HKG'),
        (lat: 31.2304, lng: 121.4737, price: '₩349,990', code: 'SHA'),
      ];

  void _onPinTap({
    required String code,
    required List<AnywhereDestination> destinations,
    required double screenWidth,
  }) {
    final idx = destinations.indexWhere((d) => d.code == code);
    if (idx == -1) return;
    const spacing = 30.0;
    final tileWidth = screenWidth * 0.9;
    final target = math.max(0.0, idx * (tileWidth + spacing));
    _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    _selectedCode.value = code;
    final pin = _pricePoints.firstWhere((p) => p.code == code);
    _animateMapMove(LatLng(pin.lat, pin.lng), _mapController.camera.zoom);
  }

  @override
  Widget build(BuildContext context) {
    final tiles = ref.watch(anywhereDestinationsProvider);
    final destinations = tiles.asData?.value ?? const <AnywhereDestination>[];
    final controller = ref.read(flightSearchProvider.notifier);
    final w = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: const MapOptions(
                  center: LatLng(20.0, 100.0),
                  zoom: 2.5,
                  maxZoom: 10,
                  minZoom: 1.5,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.tfa',
                  ),
                  ValueListenableBuilder<String?>(
                    valueListenable: _selectedCode,
                    builder: (_, selected, __) {
                      final ordered = [
                        ..._pricePoints.where((p) => p.code != selected),
                        ..._pricePoints.where((p) => p.code == selected),
                      ];
                      return MarkerLayer(
                        markers: ordered.map((p) {
                          final isSelected = p.code == selected;
                          return Marker(
                            point: LatLng(p.lat, p.lng),
                            width: 120,
                            height: 40,
                            child: GestureDetector(
                              onTap: () => _onPinTap(
                                code: p.code,
                                destinations: destinations,
                                screenWidth: w,
                              ),
                              child: _PriceTag(
                                text: p.price,
                                selected: isSelected,
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: SizedBox(
                  height: AnywhereDestinationTile.height,
                  child: tiles.when(
                    data: (items) => ListView.separated(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 30),
                      itemBuilder: (_, i) => SizedBox(
                        width: w * 0.9,
                        child: AnywhereDestinationTile(
                          item: items[i],
                          onTap: () => controller.setArrivalCode(
                            items[i].iata,
                            items[i].name,
                          ),
                        ),
                      ),
                    ),
                    loading: () => ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.zero,
                      itemCount: 6,
                      separatorBuilder: (_, __) => const SizedBox(width: 30),
                      itemBuilder: (_, __) => const SkeletonCard(),
                    ),
                    error: (e, _) => Center(child: Text('Failed to load: $e')),
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

class _PriceTag extends StatelessWidget {
  const _PriceTag({required this.text, required this.selected});
  final String text;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? Colors.blue : Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(blurRadius: 2, color: Colors.black26)],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 14,
          color: selected ? Colors.white : Colors.black87,
        ),
      ),
    );
  }
}
