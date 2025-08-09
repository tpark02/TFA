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

    final middleAirports = pathParts.length > 2
        ? pathParts.sublist(1, pathParts.length - 1)
        : [];

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
                        // "$index  $depTime",
                        "$depTime",
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
                          /// Connector line: dots and dividers
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ...(middleAirports.isNotEmpty
                                  ? [
                                      Expanded(
                                        child: Divider(color: Colors.grey),
                                      ),
                                      ...List.generate(middleAirports.length, (
                                        i,
                                      ) {
                                        return Row(
                                          children: [
                                            Icon(
                                              Icons.circle_outlined,
                                              size: 12,
                                              color: Colors.grey,
                                            ),
                                            if (i != middleAirports.length - 1)
                                              SizedBox(
                                                width: 40,
                                                child: Divider(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                          ],
                                        );
                                      }),
                                      Expanded(
                                        child: Divider(color: Colors.grey),
                                      ),
                                    ]
                                  : [
                                      Expanded(
                                        child: Divider(color: Colors.grey),
                                      ),
                                    ]),
                            ],
                          ),

                          /// Airport codes
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: middleAirports.map<Widget>((airport) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Text(
                                  airport,
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.fontSize,
                                  ),
                                ),
                              );
                            }).toList(),
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
