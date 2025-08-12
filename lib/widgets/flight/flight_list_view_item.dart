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

  Widget layoverTimeline(BuildContext context, List<String> middleAirports) {
    const double totalHeight = 48; // more room vertically
    const double dotSize = 10;
    const double lineY = 16; // push line higher
    const double labelTop = lineY + dotSize / 2 + 4; // push label below dot

    return SizedBox(
      height: totalHeight,
      child: Stack(
        children: [
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
              (i) {
                final code = middleAirports.isEmpty ? '' : middleAirports[i];
                return Expanded(
                  child: Stack(
                    children: [
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
    final plusDay = flight['plusDay'] ?? '';
    final depAirport = flight['depAirport'] ?? '';
    final arrAirport = flight['arrAirport'] ?? '';
    final airportPath = flight['airportPath'] ?? '';
    final duration = flight['duration'] ?? '';
    final stops = flight['stops'] ?? '';
    final airline = flight['airline'] ?? '';
    final price = flight['price'] ?? '';

    final headlineMedium = Theme.of(context).textTheme.headlineMedium?.fontSize;
    final bodyLarge = Theme.of(context).textTheme.bodyLarge?.fontSize;
    // Extract intermediate airport codes if needed
    final pathParts = airportPath.split('→').map((s) => s.trim()).toList();

    final middleAirports = pathParts.length > 2
        ? List<String>.from(pathParts.sublist(1, pathParts.length - 1))
        : <String>[];

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onClick,
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 15, 10, 10),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Top Row — Departure & Arrival Times and Airports
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Departure
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        depTime,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: headlineMedium,
                        ),
                      ),
                      Text(depAirport, style: TextStyle(fontSize: bodyLarge)),
                    ],
                  ),

                  // Middle path with circles + labels
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: layoverTimeline(context, middleAirports),
                    ),
                  ),

                  // Arrival
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        arrTime,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: headlineMedium,
                        ),
                      ),
                      Text(arrAirport, style: TextStyle(fontSize: bodyLarge)),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 8),

              /// Duration, stops, airline, price
              // Keep meta on the left (ellipsis), keep PRICE on one line at the right.
              Row(
                children: [
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
    );
  }
}
