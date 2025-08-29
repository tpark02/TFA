import 'package:TFA/l10n/app_localizations.dart';
import 'package:TFA/providers/airport/airport_lookup.dart';
import 'package:TFA/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class FlightTripDetailsItem extends ConsumerWidget {
  const FlightTripDetailsItem({
    super.key,
    required this.flightData,
    required this.isReturnPage,
  });

  final Map<String, dynamic> flightData;
  final bool isReturnPage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final textTheme = theme.textTheme;
    final double titleSize = textTheme.headlineMedium?.fontSize ?? 18;
    final text = AppLocalizations.of(context)!;

    if (flightData.isEmpty) return const SizedBox.shrink();

    // ── Top/meta parsing ───────────────────────────────────────────────────────
    final String depAirport = (flightData['depAirport'] ?? '') as String;
    final String arrAirport = (flightData['arrAirport'] ?? '') as String;

    final String depCity = ref.watch(cityByIataProvider(depAirport)) ?? 'N/A';
    final String arrCity = ref.watch(cityByIataProvider(arrAirport)) ?? 'N/A';

    final String? depRawTop = (flightData['depRaw'] as String?);

    final List<Map<String, dynamic>> segments =
        (flightData['segments'] as List<dynamic>? ?? const [])
            .cast<Map<String, dynamic>>();

    final List<Map<String, dynamic>> connections =
        (flightData['connections'] as List<dynamic>? ?? const [])
            .cast<Map<String, dynamic>>();

    final String? depAtForHeader =
        depRawTop ??
        (() {
          if (segments.isNotEmpty) {
            final Map<String, dynamic>? dep =
                segments.first['dep'] as Map<String, dynamic>?;
            return dep?['at'] as String?;
          }
          return null;
        }());

    final String headerDate =
        (depAtForHeader != null && depAtForHeader.isNotEmpty)
        ? _formatHeaderDate(depAtForHeader)
        : '';

    final String metaAir =
        (flightData['air'] ?? flightData['duration'] ?? '') as String;
    final String metaStops = (flightData['stops'] ?? '') as String;
    final int passengerTotal = (flightData['passengerTotal'] ?? 0) as int;
    final String cabin = (flightData['cabinClass'] ?? '') as String;
    final String airlineName = (flightData['airline'] ?? '') as String;

    final String passengerLabel =
        "$passengerTotal${passengerTotal > 1 ? ' ${text.travelers}' : ' ${text.travelers}'}";

    // ── Build segment tiles + layovers ─────────────────────────────────────────
    final List<Widget> sectionChildren = <Widget>[
      _AirlineLabel(name: airlineName),
    ];

    for (int i = 0; i < segments.length; i++) {
      final Map<String, dynamic> seg = segments[i];

      final Map<String, dynamic> dep =
          (seg['dep'] as Map?)?.cast<String, dynamic>() ?? const {};
      final Map<String, dynamic> arr =
          (seg['arr'] as Map?)?.cast<String, dynamic>() ?? const {};

      final String depCode = (dep['code'] ?? '') as String;
      final String arrCode = (arr['code'] ?? '') as String;

      final String depAt = (dep['at'] ?? '') as String;
      final String arrAt = (arr['at'] ?? '') as String;

      final String depTime = depAt.isNotEmpty ? _fmtTime(depAt) : '';
      final String arrTime = arrAt.isNotEmpty ? _fmtTime(arrAt) : '';

      final String plusDayStr = (flightData['plusDay'] ?? '') as String;
      final int plusDay = plusDayStr.isEmpty ? 0 : int.parse(plusDayStr);

      final String segDuration = (seg['duration'] ?? '') as String;

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

      if (i < connections.length) {
        final String layText = (connections[i]['duration'] ?? '') as String;
        if (layText.isNotEmpty)
          sectionChildren.add(_LayoverChip(text: layText));
      }

      sectionChildren.add(const SizedBox(height: 12));
    }

    // ── UI ─────────────────────────────────────────────────────────────────────
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Header line
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: cs.outlineVariant)),
            ),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    // keep symmetrical padding
                    const SizedBox(width: 48, height: 40),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            '$depCity - $arrCity',
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: cs.primary,
                              fontSize: titleSize,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 48,
                      height: 40,
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                if (headerDate.isNotEmpty)
                  Text(
                    headerDate,
                    style: textTheme.bodyMedium?.copyWith(
                      color: cs.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                const SizedBox(height: 2),
                Text(
                  '$metaAir | $metaStops | $passengerLabel | $cabin',
                  style: textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),

          const SizedBox(height: 16),
          ...sectionChildren,

          if (flightData['pricingMode'] == 'perleg' &&
              isReturnPage) ...<Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cs.primaryContainer,
                        foregroundColor: cs.onPrimaryContainer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        debugPrint("Book button clicked");
                      },
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          '${text.book_departing_for} ${flightData['price']}',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: cs.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _fmtTime(String iso) {
    final DateTime dt = DateTime.parse(iso);
    return DateFormat('HH:mm').format(dt);
  }

  String _formatHeaderDate(String iso) {
    final DateTime dt = DateTime.parse(iso);
    return DateFormat('EEEE, MMMM d').format(dt);
  }
}

class _AirlineLabel extends StatelessWidget {
  const _AirlineLabel({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 6),
      child: Text(
        name.toUpperCase(),
        style: tt.labelLarge?.copyWith(
          color: cs.onSurfaceVariant,
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
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final double timeSize = tt.headlineSmall?.fontSize ?? 20;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: <Widget>[
          // Times row
          Row(
            children: <Widget>[
              _timeCell(context, depTime, timeSize),
              const SizedBox(width: 8),
              Expanded(child: Divider(height: 1, color: cs.outlineVariant)),
              const SizedBox(width: 8),
              _timeCell(
                context,
                arrTime,
                timeSize,
                plusDays: plusDay > 0 ? plusDay : null,
                alignEnd: true,
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Codes row
          Row(
            children: <Widget>[
              Text(
                depCode,
                style: tt.bodyLarge?.copyWith(color: cs.onSurfaceVariant),
              ),
              const Spacer(),
              Text(
                arrCode,
                style: tt.bodyLarge?.copyWith(color: cs.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Meta row
          Row(
            children: <Widget>[
              Flexible(
                child: Text(
                  '${formatDuration(durationText)} | $flightNo',
                  style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _timeCell(
    BuildContext context,
    String time,
    double fontSize, {
    int? plusDays,
    bool alignEnd = false,
  }) {
    final cs = Theme.of(context).colorScheme;

    return SizedBox(
      width: 96,
      child: RichText(
        textAlign: alignEnd ? TextAlign.right : TextAlign.left,
        text: TextSpan(
          children: <InlineSpan>[
            TextSpan(
              text: time,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w800,
                color: cs.onSurface,
                height: 1.0,
              ),
            ),
            if (plusDays != null)
              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: Transform.translate(
                  offset: Offset(2, -fontSize * 0.55),
                  child: Text(
                    '+$plusDays',
                    style: TextStyle(
                      fontSize: fontSize * 0.55,
                      color: cs.error,
                      fontWeight: FontWeight.w700,
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
    );
  }
}

class _LayoverChip extends StatelessWidget {
  const _LayoverChip({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cs.outlineVariant, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.schedule, size: 18, color: cs.onSurfaceVariant),
          const SizedBox(width: 8),
          Text(
            text,
            style: tt.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: cs.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
