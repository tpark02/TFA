// lib/screens/flight/trip_details_page.dart

import 'package:TFA/constants/colors.dart';
import 'package:flutter/material.dart';

class FlightTripDetailsPage extends StatelessWidget {
  const FlightTripDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final onPrimary = Theme.of(context).colorScheme.onPrimary;
    final textSize = Theme.of(context).textTheme.displaySmall?.fontSize;

    return Scaffold(
      backgroundColor: appBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primary,
        leading: IconButton(
          icon: Icon(Icons.close, color: onPrimary),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        centerTitle: true,
        title: Column(
          children: [
            Text(
              'Trip Details',
              style: TextStyle(color: onPrimary, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 2),
            Text(
              'ICN - JFK',
              style: TextStyle(
                color: onPrimary.withValues(alpha: 0.7),
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.ios_share, color: onPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header card
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(0),
              ),
              border: BoxBorder.fromLTRB(
                left: BorderSide.none,
                top: BorderSide.none,
                right: BorderSide.none,
                bottom: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        'Seoul - New York',
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
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Wednesday, August 20',
                    style: TextStyle(
                      color: primaryFontColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    '22h30m | 1 stop | 1 traveler | Economy',
                    style: TextStyle(color: secondaryFontColor, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          const _AirlineLabel(name: 'HAWAIIAN AIRLINES'),
          const _SegmentTile(
            depTime: '9:25p',
            depCode: 'ICN',
            arrTime: '11:30a',
            arrCode: 'HNL',
            durationText: '9h05m',
            flightNo: 'HA 460',
          ),
          const _LayoverChip(text: '4h Layover'),
          const _AirlineLabel(name: 'HAWAIIAN AIRLINES'),
          const _SegmentTile(
            depTime: '3:30p',
            depCode: 'HNL',
            arrTime: '6:55a',
            arrCode: 'JFK',
            plusDay: true,
            durationText: '9h25m',
            flightNo: 'HA 50',
          ),

          const SizedBox(height: 20),
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
                  margin: EdgeInsets.all(0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ), // 🟢 Inner spacing
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
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'a few seconds ago',
                          style: TextStyle(color: primaryFontColor),
                        ),
                      ),
                      Text(
                        '₩1,228,361',
                        style: TextStyle(
                          fontSize: textSize,
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
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(0, 12, 0, 20),
        decoration: BoxDecoration(
          color: primary,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(0)),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '₩1,228,361',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: textSize,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text('1 Adult', style: TextStyle(color: Colors.white70)),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primaryContainer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {},
                      child: Text(
                        'Book Now',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: primary,
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

// The other classes (_AirlineLabel, _SegmentTile, _LayoverChip) stay unchanged

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
    final textSize = Theme.of(context).textTheme.displaySmall?.fontSize;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),

      child: Column(
        children: [
          Row(
            children: [
              _timeCell(depTime, textSize!),
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
                style: TextStyle(
                  fontSize: textSize,
                  color: secondaryFontColor,
                  // fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                arrCode,
                style: TextStyle(
                  fontSize: textSize,
                  color: secondaryFontColor,
                  // fontWeight: FontWeight.w600,
                ),
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
