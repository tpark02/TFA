// ✅ Fully corrected version to match your JSON parser output
// - `flightData` is ONE itinerary (Map<String, dynamic>)
// - Renders all segments (stops) with their own times & flight numbers
// - Inserts layover chips between segments using `connections[]`
// - Safe null handling everywhere

import 'package:TFA/providers/airport/airport_lookup.dart';
import 'package:flutter/material.dart';
import 'package:TFA/constants/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class FlightTripDetailsItem extends ConsumerWidget {
  const FlightTripDetailsItem({super.key, required this.flightData});
  final Map<String, dynamic> flightData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color primary = Theme.of(context).colorScheme.primary;
    final double textSize =
        Theme.of(context).textTheme.headlineMedium?.fontSize ?? 16.0;

    if (flightData.isEmpty) {
      return const SizedBox.shrink();
    }

    // ── Parse top-level fields from one itinerary object ────────────────────────
    final String depAirport = (flightData['depAirport'] ?? '') as String;
    final String arrAirport = (flightData['arrAirport'] ?? '') as String;

    final String depCity = ref.watch(cityByIataProvider(depAirport)) ?? 'N/A';
    final String arrCity = ref.watch(cityByIataProvider(arrAirport)) ?? 'N/A';

    // Prefer depRaw from parser; otherwise use the first segment dep.at
    final String? depRawTop = (flightData['depRaw'] as String?);
    final List<Map<String, dynamic>> segments =
        (flightData['segments'] as List<dynamic>? ?? const <dynamic>[])
            .cast<Map<String, dynamic>>();
    final List<Map<String, dynamic>> connections =
        (flightData['connections'] as List<dynamic>? ?? const <dynamic>[])
            .cast<Map<String, dynamic>>();

    final String? depAtForHeader =
        depRawTop ??
        (() {
          if (segments.isNotEmpty) {
            final Map<String, dynamic>? depMap =
                segments.first['dep'] as Map<String, dynamic>?;
            return depMap?['at'] as String?;
          }
          return null;
        }());

    final String headerDate =
        depAtForHeader != null && depAtForHeader.isNotEmpty
        ? _formatHeaderDate(depAtForHeader)
        : '';

    final String metaAir =
        (flightData['air'] ?? flightData['duration'] ?? '') as String;
    final String metaStops = (flightData['stops'] ?? '') as String;
    final int paxCount = (flightData['passengerCount'] ?? 1) as int;
    final String cabin = (flightData['cabinClass'] ?? '') as String;
    final String airlineName = (flightData['airline'] ?? '') as String;

    // ── Build segment tiles + layovers ─────────────────────────────────────────
    final List<Widget> sectionChildren = <Widget>[
      _AirlineLabel(name: airlineName),
    ];

    for (int i = 0; i < segments.length; i++) {
      final Map<String, dynamic> seg = segments[i];

      final Map<String, dynamic> dep =
          (seg['dep'] as Map?)?.cast<String, dynamic>() ??
          const <String, dynamic>{};
      final Map<String, dynamic> arr =
          (seg['arr'] as Map?)?.cast<String, dynamic>() ??
          const <String, dynamic>{};

      final String depCode = (dep['code'] ?? '') as String;
      final String arrCode = (arr['code'] ?? '') as String;

      final String depAt = (dep['at'] ?? '') as String;
      final String arrAt = (arr['at'] ?? '') as String;

      final String depTime = depAt.isNotEmpty ? _fmtTime(depAt) : '';
      final String arrTime = arrAt.isNotEmpty ? _fmtTime(arrAt) : '';

      // +day indicator for this segment
      // bool plusDay = false;
      // if (depAt.isNotEmpty && arrAt.isNotEmpty) {
      //   final DateTime depDT = DateTime.parse(depAt);
      //   final DateTime arrDT = DateTime.parse(arrAt);
      //   plusDay = arrDT.difference(depDT).inDays > 0;
      // }
      final String plusDayStr = flightData['plusDay'];

      final int plusDay = plusDayStr == ''
          ? 0
          : int.parse(flightData['plusDay'] as String);

      final String segDuration = (seg['duration'] ?? '') as String;

      // Prefer nicely assembled marketing flight if present
      final String flightNo =
          (seg['marketingFlight'] as String?) ??
          '${seg['marketingCarrier'] ?? ''} ${seg['flightNumber'] ?? ''}';

      sectionChildren.add(
        _SegmentTile(
          depTime: depTime,
          depCode: depCode,
          arrTime: arrTime,
          arrCode: arrCode,
          durationText: segDuration,
          flightNo: flightNo.trim(),
          plusDay: plusDay,
        ),
      );

      // Insert layover after segment if there’s a corresponding connection
      if (i < connections.length) {
        final Map<String, dynamic> conn = connections[i];
        final String layText = (conn['duration'] ?? '') as String;
        if (layText.isNotEmpty) {
          sectionChildren.add(_LayoverChip(text: layText));
        }
      }

      sectionChildren.add(const SizedBox(height: 12));
    }

    // ── UI ─────────────────────────────────────────────────────────────────────
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 50),
              Expanded(
                child: Center(
                  child: Text(
                    '$depCity - $arrCity',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: primary,
                      fontSize: textSize,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 40, 0),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: secondaryFontColor,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Date
          if (headerDate.isNotEmpty)
            Align(
              alignment: Alignment.center,
              child: Text(
                headerDate,
                style: const TextStyle(
                  color: primaryFontColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          const SizedBox(height: 6),

          // Meta line
          Align(
            alignment: Alignment.center,
            child: Text(
              '$metaAir | $metaStops | $paxCount | $cabin',
              style: TextStyle(color: secondaryFontColor, fontSize: 12),
            ),
          ),
          const SizedBox(height: 16),
          ...sectionChildren,

          if (flightData['pricingMode'] == 'perleg') ...<Widget>[
            const SizedBox(height: 20),
            // (Optional) Price History placeholder — keep or remove as you wish
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(0),
                ),
                border: BoxBorder.fromLTRB(
                  left: BorderSide.none,
                  top: BorderSide(color: Colors.grey.shade300),
                  right: BorderSide.none,
                  bottom: BorderSide.none,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey.shade200,
                    margin: EdgeInsets.zero,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 10,
                    ),
                    child: Text(
                      'Price History',
                      style: TextStyle(
                        backgroundColor: Colors.grey.shade200,
                        fontWeight: FontWeight.w700,
                        fontSize: textSize,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        const Expanded(
                          child: Text(
                            'a few seconds ago',
                            style: TextStyle(color: primaryFontColor),
                          ),
                        ),
                        Text(
                          '${flightData['price']}',
                          style: const TextStyle(
                            color: primaryFontColor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 64,
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 88),
          ],
        ],
      ),
    );
  }

  // HH:mm from ISO string
  String _fmtTime(String iso) {
    final DateTime dt = DateTime.parse(iso);
    return DateFormat('HH:mm').format(dt);
  }

  // Header date: Tuesday, August 19
  String _formatHeaderDate(String iso) {
    final DateTime dt = DateTime.parse(iso);
    return DateFormat('EEEE, MMMM d').format(dt);
  }
}

// ── Supporting widgets (unchanged except minor null-safety defaults) ──────────

class _AirlineLabel extends StatelessWidget {
  const _AirlineLabel({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 6),
      child: Text(
        name.toUpperCase(),
        style: TextStyle(
          color: secondaryFontColor,
          fontWeight: FontWeight.w700,
          letterSpacing: .3,
        ),
      ),
    );
  }
}

class _SegmentTile extends StatelessWidget {
  const _SegmentTile({
    required this.depTime,
    required this.depCode,
    required this.arrTime,
    required this.arrCode,
    required this.durationText,
    required this.flightNo,
    required this.plusDay,
  });

  final String depTime;
  final String depCode;
  final String arrTime;
  final String arrCode;
  final String durationText;
  final String flightNo;
  final int plusDay;

  @override
  Widget build(BuildContext context) {
    final double textSize =
        Theme.of(context).textTheme.displaySmall?.fontSize ?? 16;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              _timeCell(depTime, textSize),
              const SizedBox(width: 5),
              Expanded(child: Divider(height: 1, color: Colors.grey.shade500)),
              const SizedBox(width: 5),
              _timeCell(
                arrTime,
                textSize,
                suffix: plusDay > 0 ? plusDay.toString() : null,
                alignEnd: true,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: <Widget>[
              Text(
                depCode,
                style: TextStyle(fontSize: textSize, color: secondaryFontColor),
              ),
              const Spacer(),
              Text(
                arrCode,
                style: TextStyle(fontSize: textSize, color: secondaryFontColor),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Text(
                '$durationText | $flightNo',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _timeCell(
    String time,
    double textSize, {
    String? suffix,
    bool alignEnd = false,
  }) {
    return Text.rich(
      TextSpan(
        children: <InlineSpan>[
          TextSpan(
            text: time,
            style: TextStyle(fontSize: textSize, color: Colors.black),
          ),
          if (suffix != null)
            WidgetSpan(
              child: Transform.translate(
                offset: const Offset(1, -16), // move right and up
                child: Text(
                  '+$suffix',
                  style: const TextStyle(fontSize: 14, color: Colors.red),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
//   Widget _timeCell(
//     String t,
//     double textSize, {
//     String? suffix,
//     bool alignEnd = false,
//   }) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: <Widget>[
//         Text(
//           t,
//           textAlign: alignEnd ? TextAlign.right : TextAlign.left,
//           style: TextStyle(
//             fontSize: textSize,
//             fontWeight: FontWeight.w800,
//             color: Colors.red,
//           ),
//         ),
//         if (suffix != null)
//           Padding(
//             padding: const EdgeInsets.only(left: 2, top: 8),
//             child: Text(
//               suffix,
//               style: TextStyle(
//                 offset: const Offset(1, -4),
//                 fontSize: textSize,
//                 fontWeight: FontWeight.w700,
//                 color: Colors.red,
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }

class _LayoverChip extends StatelessWidget {
  const _LayoverChip({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: appGreyColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(Icons.schedule, size: 18),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
