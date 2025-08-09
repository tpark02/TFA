import 'package:TFA/constants/filter_data.dart';
import 'package:TFA/utils/time_utils.dart';
import 'package:flutter/material.dart';

class FlightFilterPage extends StatefulWidget {
  const FlightFilterPage({super.key, required this.scrollController});
  final ScrollController scrollController;

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
  Set<String> selectedAirlines = cloneSet(kDefaultSelectedAirlines);
  Set<String> selectedLayovers = cloneSet(kDefaultSelectedLayovers);

  static const int _visibleItemsCount = 7;
  bool _showAllAirlines = false;
  bool _showAllCities = false;

  final List<Widget> _sections = [];

  Widget _padded(Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: child,
    );
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Container(
      color: Colors.grey[100],
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _radio(String value, String title) {
    return Container(
      color: Colors.white,
      child: RadioListTile(
        value: value,
        groupValue: selectedSort,
        onChanged: (v) => setState(() => selectedSort = v!),
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
      onChanged: (v) => setState(() => selectedStops = v!),
      title: Text(title),
    );
  }

  Widget _checkbox(String title, bool current, void Function(bool) onChanged) {
    return Container(
      color: Colors.white,
      child: CheckboxListTile(
        value: current,
        onChanged: (v) => onChanged(v!),
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
      children: [
        // const SizedBox(height: 20),
        // Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(leftLabel), Text(rightLabel)],
        ),
        RangeSlider(
          min: min,
          max: max,
          values: values,
          onChanged: (v) => onChanged(
            RangeValues(v.start.clamp(min, max), v.end.clamp(min, max)),
          ),
        ),
      ],
    );
  }

  Widget _airlineTile(String airline) {
    final isSelected = selectedAirlines.contains(airline);
    return Container(
      color: Colors.white,
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        leading: Checkbox(
          value: isSelected,
          onChanged: (v) {
            setState(() {
              if (v == true) {
                selectedAirlines.add(airline);
              } else {
                selectedAirlines.remove(airline);
              }
            });
          },
        ),
        title: Text(airline),
        trailing: GestureDetector(
          onTap: () {
            setState(() {
              selectedAirlines
                ..clear()
                ..add(airline);
            });
          },
          child: const Text("only", style: TextStyle(color: Colors.lightBlue)),
        ),
      ),
    );
  }

  Widget _cityTiles(String city) {
    final isSelected = selectedLayovers.contains(city);
    return Container(
      color: Colors.white,
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        leading: Checkbox(
          value: isSelected,
          onChanged: (v) {
            setState(() {
              if (v == true) {
                selectedLayovers.add(city);
              } else {
                selectedLayovers.remove(city);
              }
            });
          },
        ),
        title: Text(city),
        trailing: GestureDetector(
          onTap: () {
            setState(() {
              selectedLayovers
                ..clear()
                ..add(city);
            });
          },
          child: const Text("only", style: TextStyle(color: Colors.lightBlue)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sections = [
      _buildSectionTitle("Sort", context),
      _padded(_radio("duration", "Duration")),
      _padded(_radio("cost", "Cost")),
      _padded(_radio("value", "Value")),

      _buildSectionTitle("Travel Hacks", context),
      _padded(
        _checkbox("Self - Transfer", selfTransferEnabled, (v) {
          setState(() => selfTransferEnabled = v);
        }),
      ),

      _buildSectionTitle("Stops", context),
      _padded(_radioInt(1, "Up to 1 stop")),
      _padded(_radioInt(2, "Up to 2 stops")),

      _buildSectionTitle("Take Off", context),
      _padded(
        _buildSlider(
          leftLabel: formatTime(takeoffRange.start.toInt()),
          rightLabel: formatTime(takeoffRange.end.toInt()),
          values: takeoffRange,
          min: 0,
          max: 1439,
          onChanged: (r) => setState(() => takeoffRange = r),
        ),
      ),

      _buildSectionTitle("Landing", context),
      _padded(
        _buildSlider(
          leftLabel: formatTime(landingRange.start.toInt()),
          rightLabel: formatTime(landingRange.end.toInt()),
          values: landingRange,
          min: 0,
          max: 1439,
          onChanged: (r) => setState(() => landingRange = r),
        ),
      ),
      _buildSectionTitle("Flight Duration", context),
      _padded(
        _buildSlider(
          leftLabel: formatDuration(flightDuration.start.toInt()),
          rightLabel: formatDuration(flightDuration.end.toInt()),
          values: flightDuration,
          min: 0,
          max: 1440,
          onChanged: (r) => setState(() => flightDuration = r),
        ),
      ),
      _buildSectionTitle("Layover Duration", context),
      _padded(
        _buildSlider(
          leftLabel: formatDuration(layoverDuration.start.toInt()),
          rightLabel: formatDuration(layoverDuration.end.toInt()),
          values: layoverDuration,
          min: 0,
          max: 1470,
          onChanged: (r) => setState(() => layoverDuration = r),
        ),
      ),

      // --- Airlines with Show More ---
      _buildSectionTitle("Airlines", context),
      ...(() {
        final list = _showAllAirlines
            ? kAirlines
            : kAirlines.take(_visibleItemsCount).toList();
        return [
          ...list.map((a) => _padded(_airlineTile(a))),
          if (kAirlines.length > _visibleItemsCount)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Center(
                child: TextButton(
                  onPressed: () => setState(() {
                    _showAllAirlines = !_showAllAirlines;
                  }),
                  child: Text(_showAllAirlines ? "Show Less" : "Show More"),
                ),
              ),
            ),
        ];
      }()),
      _buildSectionTitle("Layover Cities", context),
      ...(() {
        final list = _showAllCities
            ? kLayoverCities
            : kLayoverCities.take(_visibleItemsCount).toList();
        return [
          ...list.map((a) => _padded(_cityTiles(a))),
          if (kLayoverCities.length > _visibleItemsCount)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Center(
                child: TextButton(
                  onPressed: () => setState(() {
                    _showAllCities = !_showAllCities;
                  }),
                  child: Text(_showAllCities ? "Show Less" : "Show More"),
                ),
              ),
            ),
        ];
      }()),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Scaffold(
        body: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Filters",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  // IconButton(
                  //   icon: const Icon(Icons.close),
                  //   onPressed: () => Navigator.pop(context),
                  // ),
                ],
              ),
            ),

            // Scrollable SliverList
            Expanded(
              child: CustomScrollView(
                controller: widget.scrollController,
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => sections[index],
                      childCount: sections.length,
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              ),
            ),

            // Done button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
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
          ],
        ),
      ),
    );
  }
}
