import 'package:TFA/l10n/app_localizations.dart';
import 'package:TFA/providers/flight/flight_search_controller.dart';
import 'package:TFA/widgets/counter_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TravelerSelectorSheet extends ConsumerStatefulWidget {
  const TravelerSelectorSheet({super.key, required this.cabinIdx});
  final int cabinIdx;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TravelerSelectorState();
}

class _TravelerSelectorState extends ConsumerState<TravelerSelectorSheet> {
  int _selectedIndex = 0; // 0: travelers, 1: cabin
  late int _cabinIdx;

  @override
  void initState() {
    super.initState();
    _cabinIdx = widget.cabinIdx; // mutable copy
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final double maxHeight = MediaQuery.of(context).size.height * 0.40;
    final controller = ref.read(flightSearchProvider.notifier);
    final state = ref.watch(flightSearchProvider);
    final text = AppLocalizations.of(context)!;

    Widget _tabButton(String label, int idx) {
      final bool sel = _selectedIndex == idx;
      return TextButton(
        onPressed: () => setState(() => _selectedIndex = idx),
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          foregroundColor: sel ? cs.primary : cs.onSurfaceVariant,
        ),
        child: Text(
          label,
          style: tt.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: sel ? cs.primary : cs.onSurface,
          ),
        ),
      );
    }

    Widget _rowLabel(String label, {String? hint}) {
      return Row(
        children: [
          Text(
            label,
            style: tt.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
          ),
          if (hint != null) ...[
            const SizedBox(width: 8),
            Text(
              hint,
              style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
            ),
          ],
        ],
      );
    }

    Widget _cabinOption(String label, int idx) {
      final bool sel = _cabinIdx == idx;
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  alignment: Alignment.centerLeft,
                  foregroundColor: sel ? cs.primary : cs.onSurfaceVariant,
                ),
                onPressed: () => setState(() => _cabinIdx = idx),
                child: Text(
                  label,
                  style: tt.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: sel ? cs.primary : cs.onSurface,
                  ),
                ),
              ),
            ),
          ),
          if (sel) Icon(Icons.check, color: cs.primary),
        ],
      );
    }

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Material(
          color: cs.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Tabs
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      _tabButton(text.travelers, 0),
                      const SizedBox(width: 8),
                      _tabButton(text.c_class, 1),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: _selectedIndex == 0
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            // Adults
                            Row(
                              children: <Widget>[
                                Expanded(child: _rowLabel(text.adults)),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: CounterControl(
                                      count: state.adultCnt,
                                      onChanged: (val) =>
                                          controller.adultCnt = val,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Children
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: _rowLabel(text.children, hint: "2-11"),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: CounterControl(
                                      count: state.childrenCnt,
                                      onChanged: (val) =>
                                          controller.childrenCnt = val,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Infant (lap)
                            Row(
                              children: <Widget>[
                                Expanded(child: _rowLabel(text.infant_lap)),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: CounterControl(
                                      count: state.infantLapCnt,
                                      onChanged: (val) =>
                                          controller.infantLapCnt = val,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Infant (seat)
                            Row(
                              children: <Widget>[
                                Expanded(child: _rowLabel(text.infant_seat)),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: CounterControl(
                                      count: state.infantSeatCnt,
                                      onChanged: (val) =>
                                          controller.infantSeatCnt = val,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            _cabinOption(text.economy, 0),
                            _cabinOption(text.premium_economy, 1),
                            _cabinOption(text.business, 2),
                            _cabinOption(text.first, 3),
                          ],
                        ),
                ),

                // Done button
                Padding(
                  padding: const EdgeInsets.only(bottom: 12, top: 8),
                  child: ElevatedButton(
                    onPressed: () {
                      final int total =
                          state.adultCnt +
                          state.childrenCnt +
                          state.infantLapCnt +
                          state.infantSeatCnt;

                      controller.setPassengers(
                        count: total,
                        cabinIndex: _cabinIdx,
                        adult: state.adultCnt,
                        children: state.childrenCnt,
                        infantLap: state.infantLapCnt,
                        infantSeat: state.infantSeatCnt,
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: cs.onPrimary,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      minimumSize: const Size.fromHeight(44),
                      elevation: 1,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          text.done,
                          style: tt.labelLarge?.copyWith(color: cs.onPrimary),
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
