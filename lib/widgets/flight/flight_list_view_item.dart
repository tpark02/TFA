import 'package:flutter/material.dart';

class FlightListViewItem extends StatelessWidget {
  const FlightListViewItem({
    super.key,
    required this.onClick,
    required this.index,
    required this.flight,
  });

  final void Function() onClick;
  final int index;
  final Map<String, dynamic> flight;

  Widget _timeCell(
    String time,
    double fontSize, {
    int? plusDay,
    String? arrAirport,
    double? fs,
  }) {
    final double h = plusDay != null && plusDay > 0 ? 52.0 : 55.0;
    return SizedBox(
      width: 85,
      height: h,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 11,
            left: 0,
            right: 0,
            child: RichText(
              text: TextSpan(
                children: <InlineSpan>[
                  TextSpan(
                    text: time,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  if (plusDay != null && plusDay > 0)
                    WidgetSpan(
                      // 🟢 FIX: align to alphabetic baseline
                      alignment: PlaceholderAlignment.baseline,
                      baseline: TextBaseline.alphabetic,
                      child: Transform.translate(
                        // small upward nudge (proportional to font size)
                        offset: Offset(-5, -fontSize * 0.7),
                        child: Text(
                          '+$plusDay',
                          style: TextStyle(
                            fontSize: fontSize * 0.55,
                            color: Colors.red,
                            height: 1, // keep tight
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              // 🟢 FIX: normalize line metrics so left/right line up
              strutStyle: StrutStyle(
                forceStrutHeight: true,
                fontSize: fontSize,
                height: 1.0,
              ),
              textHeightBehavior: const TextHeightBehavior(
                applyHeightToFirstAscent: false,
                applyHeightToLastDescent: false,
              ),
            ),
          ),
          Positioned(
            top: 30,
            left: 0,
            right: 0,
            child: Text(
              arrAirport ?? 'N/A',
              style: TextStyle(fontSize: fs, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget layoverTimeline(BuildContext context, List<String> middleAirports) {
    const double totalHeight = 48; // more room vertically
    const double dotSize = 10;
    const double lineY = 16; // push line higher
    const double labelTop = lineY + dotSize / 2 + 4; // push label below dot

    return SizedBox(
      height: totalHeight,
      child: Stack(
        children: <Widget>[
          // Connector line
          Positioned(
            top: lineY,
            left: 0,
            right: 0,
            child: Container(height: 1, color: Colors.grey[400]),
          ),

          // Dots + labels
          Row(
            children: List.generate(
              middleAirports.isEmpty ? 0 : middleAirports.length,
              (int i) {
                final String code = middleAirports.isEmpty
                    ? ''
                    : middleAirports[i];
                return Expanded(
                  child: Stack(
                    children: <Widget>[
                      // Dot
                      Positioned(
                        top: lineY - dotSize / 2,
                        left: 0,
                        right: 0,
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: dotSize,
                            height: dotSize,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      // Label
                      if (code.isNotEmpty)
                        Positioned(
                          top: labelTop,
                          left: 0,
                          right: 0,
                          child: Text(
                            code,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.fontSize,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final depTime = flight['depTime'] ?? '';
    final arrTime = flight['arrTime'] ?? '';
    final plusDayStr = flight['plusDay'] ?? '';
    final depAirport = flight['depAirport'] ?? '';
    final arrAirport = flight['arrAirport'] ?? '';
    final airportPath = flight['airportPath'] ?? '';
    final duration = flight['duration'] ?? '';
    final stops = flight['stops'] ?? '';
    final airline = flight['airline'] ?? '';
    final price = flight['price'] ?? '';

    final int plusDay = plusDayStr == ''
        ? 0
        : int.parse(flight['plusDay'] as String);

    final double? headlineMedium = Theme.of(
      context,
    ).textTheme.headlineMedium?.fontSize;
    // final double? bodyLarge = Theme.of(context).textTheme.bodyLarge?.fontSize;
    // Extract intermediate airport codes if needed
    final pathParts = airportPath.split('→').map((s) => s.trim()).toList();

    final List<String> middleAirports = pathParts.length > 2
        ? List<String>.from(pathParts.sublist(1, pathParts.length - 1))
        : <String>[];
    final double? fs = headlineMedium;

    Color textColor = Theme.of(context).colorScheme.primary;
    Color labelColor = Colors.transparent;
    Color frontLabelColor = Colors.transparent;
    String label = "";

    if (flight['isHiddenCityFlight']) {
      label = "Skip Lagging";
      labelColor = Colors.grey.shade200;
      frontLabelColor = Theme.of(context).colorScheme.primary;
    } else if (flight['pricingMode'] == 'perleg') {
      label = "Seperate Tickets";
      labelColor = Colors.grey.shade200;
      frontLabelColor = Theme.of(context).colorScheme.primary;
    }

    bool isSeperateTicket = flight['pricingMode'] == 'perleg' ? true : false;

    return Material(
      color: flight['pricingMode'] == 'perleg'
          ? flight['isHiddenCityFlight']
                ? Colors.amber
                : Colors.red
          : Colors.blue,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                left: BorderSide(color: frontLabelColor, width: 6),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isSeperateTicket) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: labelColor, // light blue background
                      borderRadius: BorderRadius.zero,
                    ),
                    child: Text(
                      label,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                InkWell(
                  onTap: onClick,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        /// Top Row — Departure & Arrival Times and Airports
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            SizedBox(
                              width: 75,
                              height: 62,
                              child: Stack(
                                children: <Widget>[
                                  Positioned(
                                    top: 11,
                                    left: 0,
                                    right: 0,
                                    child: Text(
                                      depTime,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: fs,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 35,
                                    left: 0,
                                    right: 0,
                                    child: Text(
                                      depAirport,
                                      style: TextStyle(
                                        fontSize: fs,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  0,
                                  15,
                                  10,
                                  0,
                                ),
                                child: layoverTimeline(context, middleAirports),
                              ),
                            ),
                            _timeCell(
                              arrTime,
                              fs!,
                              plusDay: plusDay > 0 ? plusDay : null,
                              arrAirport: arrAirport,
                              fs: fs,
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        /// Duration, stops, airline, price
                        // Keep meta on the left (ellipsis), keep PRICE on one line at the right.
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "$duration | $stops | $airline",
                                style: TextStyle(color: Colors.grey[700]),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              price, // e.g., €1,100.72
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: headlineMedium,
                              ),
                              maxLines: 1,
                              softWrap: false,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
