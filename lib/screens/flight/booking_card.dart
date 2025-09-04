import 'package:TFA/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:TFA/models/booking_out.dart';

class BookingCard extends StatelessWidget {
  const BookingCard({super.key, required this.booking, this.onTap});

  final BookingOut booking;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Color onSurface = Theme.of(context).colorScheme.onSurface;
    final Color sub = onSurface.withValues(alpha: 0.7);
    final String route = '${booking.departCode} → ${booking.arrivalCode}';
    final String dates = _fmtDateRange(booking.departDate, booking.returnDate);
    final String pax = _paxSummary(
      adults: booking.adult,
      children: booking.children,
      infantLap: booking.infantLap,
      infantSeat: booking.infantSeat,
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: onSurface.withValues(alpha: 0.12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    route,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
                Text(
                  booking.prices,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(dates, style: TextStyle(color: sub)),
            const SizedBox(height: 6),
            Text(
              'Passengers: $pax  •  ${getTravelClassByIdx(cabinIndex: booking.cabinIdx)}',
              style: TextStyle(color: sub),
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }

  String _fmtDateRange(String depart, String? ret) {
    final String out = _fmtDate(depart);
    if (ret == null || ret.isEmpty) return out;
    return '$out — ${_fmtDate(ret)}';
  }

  String _fmtDate(String s) {
    try {
      final DateTime d = DateTime.parse(s).toLocal();
      return DateFormat('yMMMd').format(d);
    } catch (_) {
      return s;
    }
  }

  String _paxSummary({
    required int adults,
    required int children,
    required int infantLap,
    required int infantSeat,
  }) {
    final List<String> parts = <String>[];
    if (adults > 0) parts.add('$adults ${adults == 1 ? "adult" : "adults"}');
    if (children > 0) {
      parts.add('$children ${children == 1 ? "child" : "children"}');
    }
    if (infantLap > 0) {
      parts.add('$infantLap ${infantLap == 1 ? "infant" : "infants"} (lap)');
    }
    if (infantSeat > 0) {
      parts.add('$infantSeat ${infantSeat == 1 ? "infant" : "infants"} (seat)');
    }
    return parts.join(', ');
  }
}
