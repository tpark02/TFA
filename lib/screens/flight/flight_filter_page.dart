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

  String formatTime(double minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    final isAm = hours < 12;
    final displayHour = (hours % 12 == 0) ? 12 : (hours % 12);
    final displayMins = mins.toInt().toString().padLeft(2, '0');
    return "$displayHour:$displayMins ${isAm ? 'a' : 'p'}";
  }

  final List<Widget> _sections = [];

  Widget _padded(Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: child,
    );
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Container(
      color: Theme.of(
        context,
      ).colorScheme.secondaryContainer, // Light gray background
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

  Widget _rangeSlider(
    RangeValues values,
    void Function(RangeValues) onChanged,
  ) {
    return RangeSlider(
      values: values,
      onChanged: onChanged,
      min: 0,
      max: 1439,
      divisions: 1439,
      labels: RangeLabels(formatTime(values.start), formatTime(values.end)),
      activeColor: Colors.lightBlue,
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
        _rangeSlider(takeoffRange, (r) => setState(() => takeoffRange = r)),
      ),

      _buildSectionTitle("Landing", context),
      _padded(
        _rangeSlider(landingRange, (r) => setState(() => landingRange = r)),
      ),
    ];

    return SafeArea(
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
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
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
