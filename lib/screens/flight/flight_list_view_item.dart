import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlightListViewItem extends ConsumerWidget {
  const FlightListViewItem({
    super.key,
    required this.onClick,
    required this.index,
    required this.flight,
    required this.hasReturnFlights,
  });

  final void Function() onClick;
  final int index;
  final Map<String, dynamic> flight;
  final bool hasReturnFlights;

  Widget _timeCell(
    String time,
    double fontSize, {
    int? plusDay,
    String? arrAirport,
    double? fs,
    required ColorScheme cs,
    required TextTheme tt,
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
                    style: tt.bodyLarge?.copyWith(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: cs.onSurface,
                    ),
                  ),
                  if (plusDay != null && plusDay > 0)
                    WidgetSpan(
                      alignment: PlaceholderAlignment.baseline,
                      baseline: TextBaseline.alphabetic,
                      child: Transform.translate(
                        offset: Offset(-5, -fontSize * 0.7),
                        child: Text(
                          '+$plusDay',
                          style: tt.labelSmall?.copyWith(
                            fontSize: fontSize * 0.55,
                            color: cs.error,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
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
              style: tt.labelMedium?.copyWith(color: cs.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }

  Widget layoverTimeline(
    BuildContext context,
    List<String> middleAirports,
    ColorScheme cs,
    TextTheme tt,
  ) {
    const double totalHeight = 48;
    const double dotSize = 10;
    const double lineY = 16;
    const double labelTop = lineY + dotSize / 2 + 4;

    return SizedBox(
      height: totalHeight,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: lineY,
            left: 0,
            right: 0,
            child: Container(height: 1, color: cs.outlineVariant),
          ),
          Row(
            children: List.generate(middleAirports.length, (int i) {
              final String code = middleAirports[i];
              return Expanded(
                child: Stack(
                  children: <Widget>[
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
                            color: cs.surface,
                            shape: BoxShape.circle,
                            border: Border.all(color: cs.outline),
                          ),
                        ),
                      ),
                    ),
                    if (code.isNotEmpty)
                      Positioned(
                        top: labelTop,
                        left: 0,
                        right: 0,
                        child: Text(
                          code,
                          textAlign: TextAlign.center,
                          style: tt.labelSmall?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

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

    final int plusDay = plusDayStr == '' ? 0 : int.parse(plusDayStr);
    final pathParts = airportPath.split('→').map((s) => s.trim()).toList();
    final List<String> middleAirports = pathParts.length > 2
        ? List<String>.from(pathParts.sublist(1, pathParts.length - 1))
        : <String>[];

    // Label logic
    Color labelBg = Colors.transparent;
    Color leftStripe = Colors.transparent;
    String label = '';

    if (flight['isHiddenCityFlight'] == true) {
      label = "Hidden-City Ticket";
      labelBg = cs.secondaryContainer;
      leftStripe = cs.primary;
    } else if (flight['pricingMode'] == 'perleg' && hasReturnFlights) {
      label = "Separate Tickets";
      labelBg = cs.secondaryContainer;
      leftStripe = cs.primary;
    }

    final bool isSeparate = flight['pricingMode'] == 'perleg';

    return Material(
      color: cs.surface,
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: cs.surface,
              border: Border(left: BorderSide(color: leftStripe, width: 6)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (isSeparate || flight['isHiddenCityFlight'] == true) ...<Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: labelBg,
                      borderRadius: BorderRadius.zero,
                    ),
                    child: Text(
                      label,
                      style: tt.labelSmall?.copyWith(
                        color: cs.onSecondaryContainer,
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
                        bottom: BorderSide(
                          color: cs.outlineVariant,
                          width: 0.7,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        /// Top Row — Times and Airports
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
                                      style: tt.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 35,
                                    left: 0,
                                    right: 0,
                                    child: Text(
                                      depAirport,
                                      style: tt.labelMedium?.copyWith(
                                        color: cs.onSurfaceVariant,
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
                                child: layoverTimeline(
                                  context,
                                  middleAirports,
                                  cs,
                                  tt,
                                ),
                              ),
                            ),
                            _timeCell(
                              arrTime,
                              tt.bodyLarge?.fontSize ?? 16,
                              plusDay: plusDay > 0 ? plusDay : null,
                              arrAirport: arrAirport,
                              fs: tt.bodyLarge?.fontSize,
                              cs: cs,
                              tt: tt,
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        /// Duration, stops, airline, price
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "$duration | $stops | $airline",
                                style: tt.bodySmall?.copyWith(
                                  color: cs.onSurfaceVariant,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              price,
                              style: tt.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: cs.onSurface,
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
