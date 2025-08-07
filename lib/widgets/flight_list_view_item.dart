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

    // Extract intermediate airport codes if needed
    final pathParts = airportPath.split('→').map((s) => s.trim()).toList();

    final middle1 = pathParts.length > 2 ? pathParts[1] : '';
    final middle2 = pathParts.length > 3 ? pathParts[2] : '';

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
                        "$index  $depTime",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.fontSize,
                        ),
                      ),
                      Text(
                        depAirport,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),

                  /// Middle Path
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(child: Divider(color: Colors.grey)),
                              Icon(
                                Icons.circle_outlined,
                                size: 12,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                width: 90,
                                child: Divider(color: Colors.grey),
                              ),
                              Icon(
                                Icons.circle_outlined,
                                size: 12,
                                color: Colors.grey,
                              ),
                              Expanded(child: Divider(color: Colors.grey)),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Divider(color: Colors.transparent),
                              ),
                              Text(
                                middle1,
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.fontSize,
                                ),
                              ),
                              const SizedBox(
                                width: 70,
                                child: Divider(color: Colors.transparent),
                              ),
                              Text(
                                middle2,
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.fontSize,
                                ),
                              ),
                              Expanded(
                                child: Divider(color: Colors.transparent),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// Arrival
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: arrTime,
                                  style: TextStyle(
                                    fontSize: Theme.of(
                                      context,
                                    ).textTheme.headlineMedium?.fontSize,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (plusDay.isNotEmpty)
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.top,
                                    child: Transform.translate(
                                      offset: const Offset(-8, -13),
                                      child: Text(
                                        plusDay,
                                        style: TextStyle(
                                          fontSize: Theme.of(
                                            context,
                                          ).textTheme.bodySmall?.fontSize,
                                          color: Colors.red[800],
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Text(
                        arrAirport,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 8),

              /// Duration, stops, airline, price
              Row(
                children: [
                  Text(
                    "$duration | $stops | $airline",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        price,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.fontSize,
                        ),
                      ),
                    ),
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
