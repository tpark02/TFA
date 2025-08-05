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

  RangeValues takeoffRange = const RangeValues(0, 1439); // 12:00 AM - 11:59 PM
  RangeValues landingRange = const RangeValues(0, 1439);

  String formatTime(double minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    final isAm = hours < 12;
    final displayHour = (hours % 12 == 0) ? 12 : (hours % 12);
    final displayMins = mins.toInt().toString().padLeft(2, '0');
    return "$displayHour:$displayMins ${isAm ? 'a' : 'p'}";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          children: [
            // Top bar: "Filters" + close icon
            Row(
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
            const SizedBox(height: 8),

            // Content area with scroll
            Expanded(
              child: SingleChildScrollView(
                controller: widget.scrollController,
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sort",
                      style: TextStyle(
                        fontSize: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    RadioListTile(
                      value: 'duration',
                      groupValue: selectedSort,
                      onChanged: (value) =>
                          setState(() => selectedSort = value!),
                      title: const Text("Duration"),
                    ),
                    RadioListTile(
                      value: 'cost',
                      groupValue: selectedSort,
                      onChanged: (value) =>
                          setState(() => selectedSort = value!),
                      title: const Text("Cost"),
                    ),
                    RadioListTile(
                      value: 'value',
                      groupValue: selectedSort,
                      onChanged: (value) =>
                          setState(() => selectedSort = value!),
                      title: const Text("Value"),
                    ),

                    const SizedBox(height: 16),
                    Text(
                      "Travel Hacks",
                      style: TextStyle(
                        fontSize: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CheckboxListTile(
                      value: selfTransferEnabled,
                      onChanged: (value) =>
                          setState(() => selfTransferEnabled = value!),
                      title: const Text("Self - Transfer"),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),

                    const SizedBox(height: 16),
                    Text(
                      "Stops",
                      style: TextStyle(
                        fontSize: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    RadioListTile(
                      value: 1,
                      groupValue: selectedStops,
                      onChanged: (value) =>
                          setState(() => selectedStops = value!),
                      title: const Text("Up to 1 stop"),
                    ),
                    RadioListTile(
                      value: 2,
                      groupValue: selectedStops,
                      onChanged: (value) =>
                          setState(() => selectedStops = value!),
                      title: const Text("Up to 2 stops"),
                    ),

                    const SizedBox(height: 16),
                    Text(
                      "Take Off",
                      style: TextStyle(
                        fontSize: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    RangeSlider(
                      values: takeoffRange,
                      onChanged: (range) =>
                          setState(() => takeoffRange = range),
                      min: 0,
                      max: 1439,
                      divisions: 1439,
                      labels: RangeLabels(
                        formatTime(takeoffRange.start),
                        formatTime(takeoffRange.end),
                      ),
                      activeColor: Colors.lightBlue,
                    ),

                    const SizedBox(height: 16),
                    Text(
                      "Landing",
                      style: TextStyle(
                        fontSize: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    RangeSlider(
                      values: landingRange,
                      onChanged: (range) =>
                          setState(() => landingRange = range),
                      min: 0,
                      max: 1439,
                      divisions: 1439,
                      labels: RangeLabels(
                        formatTime(landingRange.start),
                        formatTime(landingRange.end),
                      ),
                      activeColor: Colors.lightBlue,
                    ),
                    RangeSlider(
                      values: landingRange,
                      onChanged: (range) =>
                          setState(() => landingRange = range),
                      min: 0,
                      max: 1439,
                      divisions: 1439,
                      labels: RangeLabels(
                        formatTime(landingRange.start),
                        formatTime(landingRange.end),
                      ),
                      activeColor: Colors.lightBlue,
                    ),
                    RangeSlider(
                      values: landingRange,
                      onChanged: (range) =>
                          setState(() => landingRange = range),
                      min: 0,
                      max: 1439,
                      divisions: 1439,
                      labels: RangeLabels(
                        formatTime(landingRange.start),
                        formatTime(landingRange.end),
                      ),
                      activeColor: Colors.lightBlue,
                    ),
                    RangeSlider(
                      values: landingRange,
                      onChanged: (range) =>
                          setState(() => landingRange = range),
                      min: 0,
                      max: 1439,
                      divisions: 1439,
                      labels: RangeLabels(
                        formatTime(landingRange.start),
                        formatTime(landingRange.end),
                      ),
                      activeColor: Colors.lightBlue,
                    ),
                    RangeSlider(
                      values: landingRange,
                      onChanged: (range) =>
                          setState(() => landingRange = range),
                      min: 0,
                      max: 1439,
                      divisions: 1439,
                      labels: RangeLabels(
                        formatTime(landingRange.start),
                        formatTime(landingRange.end),
                      ),
                      activeColor: Colors.lightBlue,
                    ),
                    RangeSlider(
                      values: landingRange,
                      onChanged: (range) =>
                          setState(() => landingRange = range),
                      min: 0,
                      max: 1439,
                      divisions: 1439,
                      labels: RangeLabels(
                        formatTime(landingRange.start),
                        formatTime(landingRange.end),
                      ),
                      activeColor: Colors.lightBlue,
                    ),
                    RangeSlider(
                      values: landingRange,
                      onChanged: (range) =>
                          setState(() => landingRange = range),
                      min: 0,
                      max: 1439,
                      divisions: 1439,
                      labels: RangeLabels(
                        formatTime(landingRange.start),
                        formatTime(landingRange.end),
                      ),
                      activeColor: Colors.lightBlue,
                    ),
                    RangeSlider(
                      values: landingRange,
                      onChanged: (range) =>
                          setState(() => landingRange = range),
                      min: 0,
                      max: 1439,
                      divisions: 1439,
                      labels: RangeLabels(
                        formatTime(landingRange.start),
                        formatTime(landingRange.end),
                      ),
                      activeColor: Colors.lightBlue,
                    ),
                    RangeSlider(
                      values: landingRange,
                      onChanged: (range) =>
                          setState(() => landingRange = range),
                      min: 0,
                      max: 1439,
                      divisions: 1439,
                      labels: RangeLabels(
                        formatTime(landingRange.start),
                        formatTime(landingRange.end),
                      ),
                      activeColor: Colors.lightBlue,
                    ),
                    RangeSlider(
                      values: landingRange,
                      onChanged: (range) =>
                          setState(() => landingRange = range),
                      min: 0,
                      max: 1439,
                      divisions: 1439,
                      labels: RangeLabels(
                        formatTime(landingRange.start),
                        formatTime(landingRange.end),
                      ),
                      activeColor: Colors.lightBlue,
                    ),
                    RangeSlider(
                      values: landingRange,
                      onChanged: (range) =>
                          setState(() => landingRange = range),
                      min: 0,
                      max: 1439,
                      divisions: 1439,
                      labels: RangeLabels(
                        formatTime(landingRange.start),
                        formatTime(landingRange.end),
                      ),
                      activeColor: Colors.lightBlue,
                    ),
                  ],
                ),
              ),
            ),

            // Done button fixed at bottom
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                ),
                child: const Text("Done", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
