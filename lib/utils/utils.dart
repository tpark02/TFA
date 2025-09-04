import 'dart:io';

import 'package:TFA/models/flight_search_out.dart';
import 'package:TFA/screens/shared/calendar_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

int depMinutesOfDay(dynamic depRaw) {
  if (depRaw == null) return -1;
  final DateTime? dt = DateTime.tryParse(depRaw.toString());
  if (dt == null) return -1;
  return dt.hour * 60 + dt.minute;
}

double parsePrice(dynamic v) {
  if (v is num) return v.toDouble();
  if (v is String) {
    final String numeric = v.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(numeric) ?? double.infinity;
  }
  return double.infinity;
}

int parseDurationMins(dynamic v) {
  if (v == null) return 1 << 30;
  if (v is int) return v;
  if (v is num) return v.toInt();
  final String s = v.toString().trim().toUpperCase();

  final RegExp iso = RegExp(r'^PT(?:(\d+)H)?(?:(\d+)M)?$');
  final RegExpMatch? mIso = iso.firstMatch(s);
  if (mIso != null) {
    final int h = int.tryParse(mIso.group(1) ?? '0') ?? 0;
    final int m = int.tryParse(mIso.group(2) ?? '0') ?? 0;
    return h * 60 + m;
  }

  final RegExp hm = RegExp(r'(?:(\d+)\s*H)?\s*(?:(\d+)\s*M)?');
  final RegExpMatch? mHm = hm.firstMatch(s);
  if (mHm != null && (mHm.group(1) != null || mHm.group(2) != null)) {
    final int h = int.tryParse(mHm.group(1) ?? '0') ?? 0;
    final int m = int.tryParse(mHm.group(2) ?? '0') ?? 0;
    return h * 60 + m;
  }

  return int.tryParse(s) ?? (1 << 30);
}

double valueScore(Map f) {
  final double p = parsePrice(f['price']);
  final double d = parseDurationMins(f['duration']).toDouble();
  final double priceNorm = p;
  final double durNorm = d / 60.0;
  return 0.7 * priceNorm + 0.3 * durNorm;
}

int maxStopsFor(String stopsLabel) {
  switch (stopsLabel) {
    case 'Nonstop':
      return 0;
    case 'Up to 1 stop':
      return 1;
    case 'Up to 2 stops':
      return 2;
    default:
      return 2;
  }
}

int parseIsoDurMin(String? iso) {
  if (iso == null || iso.isEmpty) return 0;
  final RegExp re = RegExp(r'^PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?$');
  final RegExpMatch? m = re.firstMatch(iso);
  if (m == null) return 0;
  final int h = int.tryParse(m.group(1) ?? '0') ?? 0;
  final int min = int.tryParse(m.group(2) ?? '0') ?? 0;
  final int s = int.tryParse(m.group(3) ?? '0') ?? 0;
  return h * 60 + min + (s ~/ 60);
}

String fmtTime(String iso) {
  final DateTime dt = DateTime.parse(iso);
  return DateFormat('HH:mm').format(dt);
}

String formatHeaderDate(String iso) {
  final DateTime dt = DateTime.parse(iso);
  return DateFormat('EEEE, MMMM d').format(dt);
}

String fmtHM(int minutes) {
  final int m = minutes < 0 ? 0 : minutes;
  final int h = m ~/ 60;
  final int mm = m % 60;
  if (h == 0) return '${mm}m';
  if (mm == 0) return '${h}h';
  return '${h}h ${mm}m';
}

String formatTime(String iso) {
  final DateTime? dt = DateTime.tryParse(iso);
  if (dt == null) return iso;
  return DateFormat.Hm().format(dt.toLocal());
}

String formatDuration(String isoDuration) {
  final RegExp regex = RegExp(r'PT(?:(\d+)H)?(?:(\d+)M)?');
  final RegExpMatch? match = regex.firstMatch(isoDuration);
  if (match != null) {
    final int hours = int.tryParse(match.group(1) ?? '0') ?? 0;
    final int minutes = int.tryParse(match.group(2) ?? '0') ?? 0;
    return '${hours}h ${minutes}m';
  }
  return '';
}

int parseIsoDurationToMin(String iso) {
  final RegExp re = RegExp(
    r'^P(?:\d+Y)?(?:\d+M)?(?:\d+D)?T?(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?$',
  );
  final RegExpMatch? m = re.firstMatch(iso);
  if (m == null) return 0;
  final int h = int.tryParse(m.group(1) ?? '0') ?? 0;
  final int min = int.tryParse(m.group(2) ?? '0') ?? 0;
  final int s = int.tryParse(m.group(3) ?? '0') ?? 0;
  return h * 60 + min + (s > 0 ? 1 : 0);
}

String formatTimeFromMinutes(int minutes) {
  final int hours = minutes ~/ 60;
  final int mins = minutes % 60;
  final String period = hours < 12 ? 'a' : 'p';
  final int displayHour = hours % 12 == 0 ? 12 : hours % 12;
  final String displayMin = mins.toString().padLeft(2, '0');
  return '$displayHour:$displayMin$period';
}

String formatDurationFromMinutes(int minutes) {
  final int hours = minutes ~/ 60;
  final int mins = minutes % 60;
  return '${hours}h ${mins}m';
}

Future<Map<String, DateTime?>?> showCalender(
  BuildContext context,
  WidgetRef ref,
  String firstTitle,
  String secondTitle,
  bool isOnlyTab,
  bool isRange,
  int stDays,
  int edDays,
) {
  if (Platform.isAndroid) {
    return showModalBottomSheet<Map<String, DateTime?>>(
      context: context,
      isScrollControlled: true,
      builder: (_) => CalendarSheet(
        key: UniqueKey(),
        firstTitle: firstTitle,
        secondTitle: secondTitle,
        isOnlyTab: isOnlyTab,
        isRange: isRange,
        startDays: stDays,
        endDays: edDays,
      ),
    );
  } else {
    return CupertinoScaffold.showCupertinoModalBottomSheet<
      Map<String, DateTime?>
    >(
      context: context,
      useRootNavigator: true,
      expand: true,
      builder: (_) => CalendarSheet(
        key: UniqueKey(),
        firstTitle: firstTitle,
        secondTitle: secondTitle,
        isOnlyTab: isOnlyTab,
        isRange: isRange,
        startDays: stDays,
        endDays: edDays,
      ),
    );
  }
}

String formatCurrency(
  int amount, {
  String currencySymbol = '₩',
  bool addPlusForMax = false,
  int? maxValue,
}) {
  final String formatted = NumberFormat('#,###').format(amount);
  final bool showPlus = addPlusForMax && maxValue != null && amount == maxValue;
  return '$currencySymbol$formatted${showPlus ? '+' : ''}';
}

String getCabinClassByIdx({required int cabinIndex}) {
  String cabin = 'Economy';
  switch (cabinIndex) {
    case 0:
      cabin = 'Economy';
      break;
    case 1:
      cabin = 'Premium Economy';
      break;
    case 2:
      cabin = 'Business';
      break;
    case 3:
      cabin = 'First';
      break;
    default:
      cabin = 'Economy';
  }
  return cabin;
}

String getTravelClassByIdx({required int cabinIndex}) {
  String cabin = 'Economy';
  switch (cabinIndex) {
    case 0:
      cabin = 'ECONOMY';
      break;
    case 1:
      cabin = 'PREMIUM_ECONOMY';
      break;
    case 2:
      cabin = 'BUSINESS';
      break;
    case 3:
      cabin = 'FIRST';
      break;
    default:
      cabin = 'ECONOMY';
  }
  return cabin;
}

const Map<String, String> cabinMap = <String, String>{
  'PREMIUM_ECONOMY': 'Premium Economy',
  'ECONOMY': 'Economy',
  'BUSINESS': 'Business',
  'FIRST': 'First',
};

String pluralize(String word, int n, {String? irregularPlural}) =>
    n == 1 ? word : (irregularPlural ?? '${word}s');

double parseCurrencyString(
  String s, {
  String locale = 'en_US',
  String? currencyName,
  String? currencySymbol,
}) {
  try {
    final NumberFormat f = NumberFormat.currency(
      locale: locale,
      name: currencyName,
      symbol: currencySymbol,
    );
    return f.parse(s).toDouble();
  } catch (_) {
    final NumberFormat dp = NumberFormat.decimalPattern(locale);
    final String dec = dp.symbols.DECIMAL_SEP;
    final String grp = dp.symbols.GROUP_SEP;

    String t = s.replaceAll(
      RegExp(r'[^0-9\-\Q' + dec + r'\E\Q' + grp + r'\E]'),
      '',
    );
    if (grp.isNotEmpty) t = t.replaceAll(grp, '');
    if (dec != '.') t = t.replaceAll(dec, '.');

    return double.tryParse(t) ?? 0.0;
  }
}

String _ts(String? iso) {
  if (iso == null || iso.isEmpty) return '';
  final DateTime dt = DateTime.parse(iso);
  return DateFormat('yyyyMMddHHmm').format(dt);
}

String _segKey(Segment s) {
  final String op = (s.operating?.carrierCode ?? s.carrierCode ?? '')
      .toUpperCase();
  final String num = (s.number ?? '').trim();
  final String dep = s.departure?.iataCode ?? '';
  final String arr = s.arrival?.iataCode ?? '';
  final String depAt = _ts(s.departure?.at);
  final String arrAt = _ts(s.arrival?.at);
  return '$op/$num $dep-$depAt->$arr-$arrAt';
}

String itineraryKey(List<Segment> segs) =>
    (segs.isEmpty) ? '' : segs.map(_segKey).join('|');

String outboundKey(FlightOffer offer) =>
    itineraryKey(offer.itineraries?.first.segments ?? const <Segment>[]);

List<double> saturationMatrix(double s) {
  final double inv = 1 - s;
  final double r = 0.2126 * inv;
  final double g = 0.7152 * inv;
  final double b = 0.0722 * inv;
  return <double>[
    r + s,
    g,
    b,
    0,
    0,
    r,
    g + s,
    b,
    0,
    0,
    r,
    g,
    b + s,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ];
}
