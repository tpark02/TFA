import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:TFA/models/booking_out.dart';

class BookingCard extends StatelessWidget {
  const BookingCard({super.key, required this.booking, this.onTap});

  final BookingOut booking;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final sub = onSurface.withOpacity(0.7);

    final String route = '${booking.departCode} → ${booking.arrivalCode}';

    final String dates = _fmtDateRange(booking.departDate, booking.returnDate);

    final String pax = _paxSummary(
      adults: booking.adult,
      children: booking.children,
      infantLap: booking.infantLap,
      infantSeat: booking.infantSeat,
    );

    // final String price = _fmtCurrency(booking.prices);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: onSurface.withOpacity(0.12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Route + price row
            Row(
              children: [
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
            // Dates
            Text(dates, style: TextStyle(color: sub)),
            const SizedBox(height: 6),
            // Pax + cabin
            Text(
              'Passengers: $pax  •  Cabin idx: ${booking.cabinIdx}',
              style: TextStyle(color: sub),
            ),
            const SizedBox(height: 6),
            // Created at (optional)
            // Text(
            //   'Booked: ${_fmtDateTime(booking.createdAt)}',
            //   style: TextStyle(color: sub, fontSize: 12),
            // ),
          ],
        ),
      ),
    );
  }

  // ---- helpers ----

  String _fmtDateRange(String depart, String? ret) {
    final String out = _fmtDate(depart);
    if (ret == null || ret.isEmpty) return out; // one-way
    return '$out — ${_fmtDate(ret)}';
  }

  String _fmtDate(String s) {
    try {
      final d = DateTime.parse(s).toLocal();
      return DateFormat('yMMMd').format(d); // e.g. Jan 5, 2025
    } catch (_) {
      return s;
    }
  }

  String _fmtDateTime(DateTime d) {
    return DateFormat('yMMMd • HH:mm').format(d.toLocal());
  }

  String _fmtCurrency(num amount) {
    // adjust currency if you have it; BookingOut.prices is int per your model
    // Using no symbol to avoid wrong symbol; swap with NumberFormat.currency if you know it
    return NumberFormat.decimalPattern().format(amount);
  }

  String _paxSummary({
    required int adults,
    required int children,
    required int infantLap,
    required int infantSeat,
  }) {
    final parts = <String>[];
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
