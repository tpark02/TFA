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
    final primary = Theme.of(context).colorScheme.primary;
    final textSize = Theme.of(context).textTheme.displaySmall?.fontSize ?? 16.0;

    if (flightData.isEmpty) {
      return const SizedBox.shrink();
    }

    // ── Parse top-level fields from one itinerary object ────────────────────────
    final depAirport = (flightData['depAirport'] ?? '') as String;
    final arrAirport = (flightData['arrAirport'] ?? '') as String;

    final depCity = ref.watch(cityByIataProvider(depAirport)) ?? 'N/A';
    final arrCity = ref.watch(cityByIataProvider(arrAirport)) ?? 'N/A';

    // Prefer depRaw from parser; otherwise use the first segment dep.at
    final depRawTop = (flightData['depRaw'] as String?);
    final segments = (flightData['segments'] as List<dynamic>? ?? const [])
        .cast<Map<String, dynamic>>();
    final connections =
        (flightData['connections'] as List<dynamic>? ?? const [])
            .cast<Map<String, dynamic>>();

    final depAtForHeader =
        depRawTop ??
        (() {
          if (segments.isNotEmpty) {
            final depMap = segments.first['dep'] as Map<String, dynamic>?;
            return depMap?['at'] as String?;
          }
          return null;
        }());

    final headerDate = depAtForHeader != null && depAtForHeader.isNotEmpty
        ? _formatHeaderDate(depAtForHeader)
        : '';

    final metaAir =
        (flightData['air'] ?? flightData['duration'] ?? '') as String;
    final metaStops = (flightData['stops'] ?? '') as String;
    final paxCount = (flightData['passengerCount'] ?? 1) as int;
    final cabin = (flightData['cabinClass'] ?? '') as String;
    final airlineName = (flightData['airline'] ?? '') as String;

    // ── Build segment tiles + layovers ─────────────────────────────────────────
    final sectionChildren = <Widget>[_AirlineLabel(name: airlineName)];

    for (int i = 0; i < segments.length; i++) {
      final seg = segments[i];

      final dep = (seg['dep'] as Map?)?.cast<String, dynamic>() ?? const {};
      final arr = (seg['arr'] as Map?)?.cast<String, dynamic>() ?? const {};

      final depCode = (dep['code'] ?? '') as String;
      final arrCode = (arr['code'] ?? '') as String;

      final depAt = (dep['at'] ?? '') as String;
      final arrAt = (arr['at'] ?? '') as String;

      final depTime = depAt.isNotEmpty ? _fmtTime(depAt) : '';
      final arrTime = arrAt.isNotEmpty ? _fmtTime(arrAt) : '';

      // +day indicator for this segment
      bool plusDay = false;
      if (depAt.isNotEmpty && arrAt.isNotEmpty) {
        final depDT = DateTime.parse(depAt);
        final arrDT = DateTime.parse(arrAt);
        plusDay = arrDT.difference(depDT).inDays > 0;
      }

      final segDuration = (seg['duration'] ?? '') as String;

      // Prefer nicely assembled marketing flight if present
      final flightNo =
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
        final conn = connections[i];
        final layText = (conn['duration'] ?? '') as String;
        if (layText.isNotEmpty) {
          sectionChildren.add(_LayoverChip(text: layText));
        }
      }

      sectionChildren.add(const SizedBox(height: 12));
    }

    // ── UI ─────────────────────────────────────────────────────────────────────
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cities header
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                '$depCity - $arrCity',
                style: TextStyle(
                  color: primary,
                  fontSize: textSize,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Icon(Icons.keyboard_arrow_down, color: secondaryFontColor),
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
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.grey.shade200,
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
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
                  children: const [
                    Expanded(
                      child: Text(
                        'a few seconds ago',
                        style: TextStyle(color: primaryFontColor),
                      ),
                    ),
                    Text(
                      '₩1,228,361',
                      style: TextStyle(
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
    );
  }

  // HH:mm from ISO string
  String _fmtTime(String iso) {
    final dt = DateTime.parse(iso);
    return DateFormat('HH:mm').format(dt);
  }

  // Header date: Tuesday, August 19
  String _formatHeaderDate(String iso) {
    final dt = DateTime.parse(iso);
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
    this.plusDay = false,
  });

  final String depTime;
  final String depCode;
  final String arrTime;
  final String arrCode;
  final String durationText;
  final String flightNo;
  final bool plusDay;

  @override
  Widget build(BuildContext context) {
    final textSize = Theme.of(context).textTheme.displaySmall?.fontSize ?? 16;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        children: [
          Row(
            children: [
              _timeCell(depTime, textSize),
              const SizedBox(width: 5),
              Expanded(child: Divider(height: 1, color: Colors.grey.shade500)),
              const SizedBox(width: 5),
              _timeCell(
                arrTime,
                textSize,
                suffix: plusDay ? ' +1' : null,
                alignEnd: true,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
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
            children: [
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
    String t,
    double textSize, {
    String? suffix,
    bool alignEnd = false,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          t,
          textAlign: alignEnd ? TextAlign.right : TextAlign.left,
          style: TextStyle(fontSize: textSize, fontWeight: FontWeight.w800),
        ),
        if (suffix != null)
          Padding(
            padding: const EdgeInsets.only(left: 2, top: 8),
            child: Text(
              suffix,
              style: TextStyle(fontSize: textSize, fontWeight: FontWeight.w700),
            ),
          ),
      ],
    );
  }
}

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
        children: [
          const Icon(Icons.schedule, size: 18),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
