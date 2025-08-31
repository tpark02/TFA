import 'package:TFA/l10n/app_localizations.dart';
import 'package:TFA/utils/utils.dart';
import 'package:TFA/widgets/section_header.dart';
import 'package:flutter/material.dart';

class FlightFilterPage extends StatefulWidget {
  const FlightFilterPage({
    super.key,
    required this.scrollController,
    required this.selectedAirlines,
    required this.selectedLayovers,
    required this.kAirlines,
    required this.kLayoverCities,
    required this.carriersDict,
  });

  final ScrollController scrollController;
  final Set<String> selectedAirlines;
  final Set<String> selectedLayovers;
  final List<String> kAirlines;
  final List<String> kLayoverCities;
  final Map<String, String> carriersDict;

  @override
  State<FlightFilterPage> createState() => _FlightFilterPageState();
}

class _FlightFilterPageState extends State<FlightFilterPage> {
  String selectedSort = 'cost';
  bool selfTransferEnabled = true;
  int selectedStops = 2;

  RangeValues takeoffRange = const RangeValues(0, 1439);
  RangeValues landingRange = const RangeValues(0, 1439);
  RangeValues flightDuration = const RangeValues(0, 1395);
  RangeValues layoverDuration = const RangeValues(0, 1470);

  static const int _visibleItemsCount = 7;
  bool _showAllAirlines = false;
  bool _showAllCities = false;

  late Set<String> _airlinesSel;
  late Set<String> _layoversSel;

  @override
  void initState() {
    super.initState();
    _airlinesSel = {...widget.selectedAirlines};
    _layoversSel = {...widget.selectedLayovers};
  }

  Widget _padded(Widget child) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: child,
  );

  Widget _radio(String value, String title) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Material(
      color: cs.surface,
      child: RadioListTile<String>(
        value: value,
        groupValue: selectedSort,
        onChanged: (v) => setState(() => selectedSort = v!),
        title: Text(title, style: tt.bodyMedium?.copyWith(color: cs.onSurface)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        dense: true,
        activeColor: cs.primary,
      ),
    );
  }

  Widget _radioInt(int value, String title) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return RadioListTile<int>(
      value: value,
      groupValue: selectedStops,
      onChanged: (v) => setState(() => selectedStops = v!),
      title: Text(title, style: tt.bodyMedium?.copyWith(color: cs.onSurface)),
      activeColor: cs.primary,
    );
  }

  Widget _checkbox(String title, bool current, void Function(bool) onChanged) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Material(
      color: cs.surface,
      child: CheckboxListTile(
        value: current,
        onChanged: (v) => onChanged(v!),
        title: Text(title, style: tt.bodyMedium?.copyWith(color: cs.onSurface)),
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        dense: true,
        activeColor: cs.primary,
        checkColor: cs.onPrimary,
      ),
    );
  }

  Widget _buildSlider({
    required String leftLabel,
    required String rightLabel,
    required RangeValues values,
    required double min,
    required double max,
    required ValueChanged<RangeValues> onChanged,
  }) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              leftLabel,
              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),
            Text(
              rightLabel,
              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),
          ],
        ),
        RangeSlider(
          min: min,
          max: max,
          values: values,
          onChanged: (v) => onChanged(
            RangeValues(v.start.clamp(min, max), v.end.clamp(min, max)),
          ),
          activeColor: cs.primary,
          inactiveColor: cs.outlineVariant,
        ),
      ],
    );
  }

  Widget _airlineTile(BuildContext context, String airlineName) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final bool isSelected = _airlinesSel.contains(airlineName);

    return Material(
      color: cs.surface,
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        leading: Checkbox(
          value: isSelected,
          onChanged: (v) {
            setState(() {
              if (v == true) {
                _airlinesSel.add(airlineName);
              } else {
                _airlinesSel.remove(airlineName);
              }
            });
          },
          activeColor: cs.primary,
          checkColor: cs.onPrimary,
        ),
        title: Text(
          airlineName,
          style: tt.bodyMedium?.copyWith(color: cs.onSurface),
        ),
        trailing: GestureDetector(
          onTap: () {
            setState(() {
              _airlinesSel
                ..clear()
                ..add(airlineName);
            });
          },
          child: Text(
            AppLocalizations.of(context)!.only,
            style: tt.bodyMedium?.copyWith(color: cs.primary),
          ),
        ),
      ),
    );
  }

  Widget _cityTile(String city) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final bool isSelected = _layoversSel.contains(city);

    return Material(
      color: cs.surface,
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        leading: Checkbox(
          value: isSelected,
          onChanged: (v) {
            setState(() {
              if (v == true) {
                _layoversSel.add(city);
              } else {
                _layoversSel.remove(city);
              }
            });
          },
          activeColor: cs.primary,
          checkColor: cs.onPrimary,
        ),
        title: Text(city, style: tt.bodyMedium?.copyWith(color: cs.onSurface)),
        trailing: GestureDetector(
          onTap: () {
            setState(() {
              _layoversSel
                ..clear()
                ..add(city);
            });
          },
          child: Text(
            AppLocalizations.of(context)!.only,
            style: tt.bodyMedium?.copyWith(color: cs.primary),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final text = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: cs.surface,
      body: CustomScrollView(
        controller: widget.scrollController,
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                text.sort,
                style: tt.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: SectionHeader(text.sort),
          ),
          SliverList(
            delegate: SliverChildListDelegate(<Widget>[
              _padded(_radio('duration', text.duration)),
              _padded(_radio('cost', text.total_cost)),
              _padded(_radio('value', text.value)),
            ]),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: SectionHeader('Travel Hacks'),
          ),
          SliverList(
            delegate: SliverChildListDelegate(<Widget>[
              _padded(
                _checkbox(
                  'Self - Transfer',
                  selfTransferEnabled,
                  (v) => setState(() => selfTransferEnabled = v),
                ),
              ),
            ]),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: SectionHeader(text.stops),
          ),
          SliverList(
            delegate: SliverChildListDelegate(<Widget>[
              _padded(_radioInt(1, text.up_to_1_stop)),
              _padded(_radioInt(2, text.up_to_2_stops)),
            ]),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: SectionHeader(text.take_off),
          ),
          SliverToBoxAdapter(
            child: _padded(
              _buildSlider(
                leftLabel: formatTimeFromMinutes(takeoffRange.start.toInt()),
                rightLabel: formatTimeFromMinutes(takeoffRange.end.toInt()),
                values: takeoffRange,
                min: 0,
                max: 1439,
                onChanged: (r) => setState(() => takeoffRange = r),
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: SectionHeader(text.landing),
          ),
          SliverToBoxAdapter(
            child: _padded(
              _buildSlider(
                leftLabel: formatTimeFromMinutes(landingRange.start.toInt()),
                rightLabel: formatTimeFromMinutes(landingRange.end.toInt()),
                values: landingRange,
                min: 0,
                max: 1439,
                onChanged: (r) => setState(() => landingRange = r),
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: SectionHeader(text.flight_duration),
          ),
          SliverToBoxAdapter(
            child: _padded(
              _buildSlider(
                leftLabel: formatDurationFromMinutes(
                  flightDuration.start.toInt(),
                ),
                rightLabel: formatDurationFromMinutes(
                  flightDuration.end.toInt(),
                ),
                values: flightDuration,
                min: 0,
                max: 1440,
                onChanged: (r) => setState(() => flightDuration = r),
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: SectionHeader(text.layover_duration),
          ),
          SliverToBoxAdapter(
            child: _padded(
              _buildSlider(
                leftLabel: formatDurationFromMinutes(
                  layoverDuration.start.toInt(),
                ),
                rightLabel: formatDurationFromMinutes(
                  layoverDuration.end.toInt(),
                ),
                values: layoverDuration,
                min: 0,
                max: 1470,
                onChanged: (r) => setState(() => layoverDuration = r),
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: SectionHeader(text.airlines),
          ),
          SliverList(
            delegate: SliverChildListDelegate(<Widget>[
              ...((_showAllAirlines
                      ? widget.kAirlines
                      : widget.kAirlines.take(_visibleItemsCount)))
                  .map((a) => _padded(_airlineTile(context, a))),
              if (widget.kAirlines.length > _visibleItemsCount)
                Center(
                  child: TextButton(
                    onPressed: () =>
                        setState(() => _showAllAirlines = !_showAllAirlines),
                    child: Text(
                      _showAllAirlines ? 'Show Less' : 'Show More',
                      style: TextStyle(color: cs.primary),
                    ),
                  ),
                ),
            ]),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: SectionHeader(text.layover_cities),
          ),
          SliverList(
            delegate: SliverChildListDelegate(<Widget>[
              ...((_showAllCities
                      ? widget.kLayoverCities
                      : widget.kLayoverCities.take(_visibleItemsCount)))
                  .map((c) => _padded(_cityTile(c))),
              if (widget.kLayoverCities.length > _visibleItemsCount)
                Center(
                  child: TextButton(
                    onPressed: () =>
                        setState(() => _showAllCities = !_showAllCities),
                    child: Text(
                      _showAllCities ? 'Show Less' : 'Show More',
                      style: TextStyle(color: cs.primary),
                    ),
                  ),
                ),
            ]),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.pop(context, <String, List<String>>{
                        "airlines": _airlinesSel.toList(),
                        "layovers": _layoversSel.toList(),
                      }),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,
                    foregroundColor: cs.onPrimary,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    elevation: 1,
                  ),
                  child: Text(
                    text.done,
                    style: TextStyle(
                      fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
                      fontWeight: FontWeight.bold,
                      color: cs.onPrimary,
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
