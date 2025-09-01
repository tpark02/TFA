import 'dart:async';

import 'package:TFA/l10n/app_localizations.dart';
import 'package:TFA/providers/flight/anywhere_provider.dart';
import 'package:TFA/providers/flight/flight_search_controller.dart';
import 'package:TFA/screens/flight/anywhere_map_screen.dart';
import 'package:TFA/screens/flight/anywhere_destination_tile.dart';
import 'package:TFA/screens/flight/flight_search_summary_card.dart';
import 'package:TFA/widgets/search_summary_loading_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnywhereListPage extends ConsumerStatefulWidget {
  const AnywhereListPage({super.key});
  @override
  ConsumerState<AnywhereListPage> createState() => _AnywhereListState();
}

class _AnywhereListState extends ConsumerState<AnywhereListPage> {
  Timer? _hideLoadingTimer;
  bool _showLoadingOverlay = false;
  bool _isMapSelected = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _hideLoadingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<bool>(flightSearchProvider.select((s) => s.isLoading), (
      _,
      isLoading,
    ) {
      _hideLoadingTimer?.cancel();
      if (isLoading) {
        setState(() => _showLoadingOverlay = true);
        _hideLoadingTimer = Timer(const Duration(seconds: 2), () {
          if (!mounted) return;
          ref.read(flightSearchProvider.notifier).setLoading(false);
        });
      } else {
        setState(() => _showLoadingOverlay = false);
      }
    });

    final tiles = ref.watch(anywhereDestinationsProvider);
    final flightState = ref.watch(flightSearchProvider);
    final controller = ref.read(flightSearchProvider.notifier);
    final text = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: _TopBar(
          title: FlightSearchSummaryCard(
            from: flightState.departureAirportCode,
            to: flightState.arrivalAirportCode,
            dateRange: flightState.displayDate ?? '',
            passengerCount: flightState.passengerCount.toString(),
            cabinClass: flightState.cabinClass,
          ),
          isMap: _isMapSelected,
          onBack: () => Navigator.of(context).pop(),
          onToggleMap: () => setState(() => _isMapSelected = !_isMapSelected),
        ),
      ),
      body: Column(
        children: [
          ColoredBox(
            color: cs.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Center(child: Text(text.prices_are_not)),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              child: _showLoadingOverlay
                  ? SearchSummaryLoadingCard(
                      key: const ValueKey('loading'),
                      routeText:
                          '${flightState.departureAirportCode} - Anywhere',
                      dateText: flightState.displayDate ?? '',
                    )
                  : _isMapSelected
                  ? const AnywhereMapScreen(key: ValueKey('map'))
                  : tiles.when(
                      data: (items) => ListView.separated(
                        key: const ValueKey('list'),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (_, i) => AnywhereDestinationTile(
                          item: items[i],
                          onTap: () {
                            controller.setArrivalCode(
                              items[i].iata,
                              items[i].name,
                            );
                          },
                        ),
                      ),
                      loading: () => ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        itemCount: 6,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (_, __) => const SkeletonCard(),
                      ),
                      error: (e, _) => Center(
                        child: Text(
                          'Failed to load: $e',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.error,
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    super.key,
    required this.title,
    required this.onBack,
    required this.onToggleMap,
    required this.isMap,
  });

  final Widget title;
  final VoidCallback onBack;
  final VoidCallback onToggleMap;
  final bool isMap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      // Makes status bar icons white
      value: SystemUiOverlayStyle.light,
      child: Container(
        color: cs.primary, // Color extends under status bar
        child: SafeArea(
          bottom: false, // only pad for top
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                const SizedBox(width: 8),
                IconButton(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back_ios),
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      height: 60,
                      child: FittedBox(
                        alignment: Alignment.centerLeft,
                        fit: BoxFit.scaleDown,
                        child: SizedBox(width: 250, child: title),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onToggleMap,
                  icon: Icon(isMap ? Icons.list : Icons.map_outlined),
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      height: AnywhereDestinationTile.height,
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _bar(width: 140, height: 18),
                const SizedBox(height: 10),
                _bar(width: 90, height: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bar({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
