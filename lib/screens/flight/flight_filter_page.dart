import 'package:TFA/utils/utils.dart';
import 'package:TFA/widgets/silvers/section_header.dart';
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
  RangeValues flightDuration = const RangeValues(0, 1395); // 8h40m to 23h15m
  RangeValues layoverDuration = const RangeValues(0, 1470); // 0 to 24h30m
  // --- Airlines state ---

  static const int _visibleItemsCount = 7;
  bool _showAllAirlines = false;
  bool _showAllCities = false;

  Widget _padded(Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: child,
    );
  }

  Widget _radio(String value, String title) {
    return Container(
      color: Colors.white,
      child: RadioListTile(
        value: value,
        groupValue: selectedSort,
        onChanged: (String? v) => setState(() => selectedSort = v!),
        title: Text(title),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        dense: true,
      ),
    );
  }

  Widget _radioInt(int value, String title) {
    return RadioListTile(
      value: value,
      groupValue: selectedStops,
      onChanged: (int? v) => setState(() => selectedStops = v!),
      title: Text(title),
    );
  }

  Widget _checkbox(String title, bool current, void Function(bool) onChanged) {
    return Container(
      color: Colors.white,
      child: CheckboxListTile(
        value: current,
        onChanged: (bool? v) => onChanged(v!),
        title: Text(title),
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        dense: true,
      ),
    );
  }

  Widget _buildSlider({
    // required String title,
    required String leftLabel,
    required String rightLabel,
    required RangeValues values,
    required double min,
    required double max,
    required ValueChanged<RangeValues> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // const SizedBox(height: 20),
        // Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[Text(leftLabel), Text(rightLabel)],
        ),
        RangeSlider(
          min: min,
          max: max,
          values: values,
          onChanged: (RangeValues v) => onChanged(
            RangeValues(v.start.clamp(min, max), v.end.clamp(min, max)),
          ),
        ),
      ],
    );
  }

  Widget _airlineTile(String airlineName) {
    final bool isSelected = _airlinesSel.contains(airlineName);
    return Container(
      color: Colors.white,
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        leading: Checkbox(
          value: isSelected,
          onChanged: (bool? v) {
            setState(() {
              if (v == true) {
                _airlinesSel.add(airlineName);
              } else {
                _airlinesSel.remove(airlineName);
              }
            });
          },
        ),
        title: Text(airlineName),
        trailing: GestureDetector(
          onTap: () {
            setState(() {
              _airlinesSel
                ..clear()
                ..add(airlineName);
            });
          },
          child: const Text("only", style: TextStyle(color: Colors.lightBlue)),
        ),
      ),
    );
  }

  Widget _cityTiles(String city) {
    final bool isSelected = _layoversSel.contains(city);
    return Container(
      color: Colors.white,
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        leading: Checkbox(
          value: isSelected,
          onChanged: (bool? v) {
            setState(() {
              if (v == true) {
                _layoversSel.add(city);
              } else {
                _layoversSel.remove(city);
              }
            });
          },
        ),
        title: Text(city),
        trailing: GestureDetector(
          onTap: () {
            setState(() {
              _layoversSel
                ..clear()
                ..add(city);
            });
          },
          child: const Text("only", style: TextStyle(color: Colors.lightBlue)),
        ),
      ),
    );
  }

  late Set<String> _airlinesSel;
  late Set<String> _layoversSel;

  @override
  void initState() {
    super.initState();
    _airlinesSel = <String>{...widget.selectedAirlines}; // local copy
    _layoversSel = <String>{...widget.selectedLayovers};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: widget.scrollController,
        slivers: <Widget>[
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                "Filters",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          SliverPersistentHeader(pinned: true, delegate: SectionHeader('Sort')),
          SliverList(
            delegate: SliverChildListDelegate(<Widget>[
              _padded(_radio('duration', 'Duration')),
              _padded(_radio('cost', 'Cost')),
              _padded(_radio('value', 'Value')),
            ]),
          ),

          SliverPersistentHeader(
            pinned: true,
            delegate: SectionHeader('Travel Hacks'),
          ),
          SliverList(
            delegate: SliverChildListDelegate(<Widget>[
              _padded(
                _checkbox('Self - Transfer', selfTransferEnabled, (bool v) {
                  setState(() => selfTransferEnabled = v);
                }),
              ),
            ]),
          ),

          SliverPersistentHeader(
            pinned: true,
            delegate: SectionHeader('Stops'),
          ),
          SliverList(
            delegate: SliverChildListDelegate(<Widget>[
              _padded(_radioInt(1, 'Up to 1 stop')),
              _padded(_radioInt(2, 'Up to 2 stops')),
            ]),
          ),

          SliverPersistentHeader(
            pinned: true,
            delegate: SectionHeader('Take Off'),
          ),
          SliverToBoxAdapter(
            child: _padded(
              _buildSlider(
                leftLabel: formatTimeFromMinutes(takeoffRange.start.toInt()),
                rightLabel: formatTimeFromMinutes(takeoffRange.end.toInt()),
                values: takeoffRange,
                min: 0,
                max: 1439,
                onChanged: (RangeValues r) => setState(() => takeoffRange = r),
              ),
            ),
          ),

          SliverPersistentHeader(
            pinned: true,
            delegate: SectionHeader('Landing'),
          ),
          SliverToBoxAdapter(
            child: _padded(
              _buildSlider(
                leftLabel: formatTimeFromMinutes(landingRange.start.toInt()),
                rightLabel: formatTimeFromMinutes(landingRange.end.toInt()),
                values: landingRange,
                min: 0,
                max: 1439,
                onChanged: (RangeValues r) => setState(() => landingRange = r),
              ),
            ),
          ),

          SliverPersistentHeader(
            pinned: true,
            delegate: SectionHeader('Flight Duration'),
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
                onChanged: (RangeValues r) =>
                    setState(() => flightDuration = r),
              ),
            ),
          ),

          SliverPersistentHeader(
            pinned: true,
            delegate: SectionHeader('Layover Duration'),
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
                onChanged: (RangeValues r) =>
                    setState(() => layoverDuration = r),
              ),
            ),
          ),

          SliverPersistentHeader(
            pinned: true,
            delegate: SectionHeader('Airlines'),
          ),
          SliverList(
            delegate: SliverChildListDelegate(<Widget>[
              ...((_showAllAirlines
                      ? widget.kAirlines
                      : widget.kAirlines.take(_visibleItemsCount)))
                  .map((String a) => _padded(_airlineTile(a))),
              if (widget.kAirlines.length > _visibleItemsCount)
                Center(
                  child: TextButton(
                    onPressed: () =>
                        setState(() => _showAllAirlines = !_showAllAirlines),
                    child: Text(_showAllAirlines ? 'Show Less' : 'Show More'),
                  ),
                ),
            ]),
          ),

          SliverPersistentHeader(
            pinned: true,
            delegate: SectionHeader('Layover Cities'),
          ),
          SliverList(
            delegate: SliverChildListDelegate(<Widget>[
              ...((_showAllCities
                      ? widget.kLayoverCities
                      : widget.kLayoverCities.take(_visibleItemsCount)))
                  .map((String c) => _padded(_cityTiles(c))),
              if (widget.kLayoverCities.length > _visibleItemsCount)
                Center(
                  child: TextButton(
                    onPressed: () =>
                        setState(() => _showAllCities = !_showAllCities),
                    child: Text(_showAllCities ? 'Show Less' : 'Show More'),
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
                    backgroundColor: Colors.lightBlue,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: Text(
                    "Done",
                    style: TextStyle(
                      fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
