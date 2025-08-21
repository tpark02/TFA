int depMinutesOfDay(dynamic depRaw) {
  if (depRaw == null) return -1;
  final DateTime? dt = DateTime.tryParse(depRaw.toString());
  if (dt == null) return -1;
  return dt.hour * 60 + dt.minute; // 0..1439
}

// ---- helpers ----
double parsePrice(dynamic v) {
  if (v is num) return v.toDouble();
  if (v is String) {
    final String numeric = v.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(numeric) ?? double.infinity;
  }
  return double.infinity;
}

// Accepts "PT12H30M", "12h 30m", "12h30m", "750" (mins) etc.
int parseDurationMins(dynamic v) {
  if (v == null) return 1 << 30;
  if (v is int) return v;
  if (v is num) return v.toInt();
  final String s = v.toString().trim().toUpperCase();

  // ISO-8601 like PT12H30M
  final RegExp iso = RegExp(r'^PT(?:(\d+)H)?(?:(\d+)M)?$');
  final RegExpMatch? mIso = iso.firstMatch(s);
  if (mIso != null) {
    final int h = int.tryParse(mIso.group(1) ?? '0') ?? 0;
    final int m = int.tryParse(mIso.group(2) ?? '0') ?? 0;
    return h * 60 + m;
  }

  // "12H 30M" or "12H30M"
  final RegExp hm = RegExp(r'(?:(\d+)\s*H)?\s*(?:(\d+)\s*M)?');
  final RegExpMatch? mHm = hm.firstMatch(s);
  if (mHm != null && (mHm.group(1) != null || mHm.group(2) != null)) {
    final int h = int.tryParse(mHm.group(1) ?? '0') ?? 0;
    final int m = int.tryParse(mHm.group(2) ?? '0') ?? 0;
    return h * 60 + m;
  }

  // plain minutes string like "750"
  return int.tryParse(s) ?? (1 << 30);
}

// Lower is better: balances cheap + short (tweak weights if you want)
double valueScore(Map f) {
  final double p = parsePrice(f['price']);
  final double d = parseDurationMins(f['duration']).toDouble();
  // weights: 0.7 price, 0.3 duration (per hour)
  final double priceNorm = p; // already in currency units
  final double durNorm = d / 60.0; // hours
  return 0.7 * priceNorm + 0.3 * durNorm;
}

// ---- sort ALL flights, then split ----
// int compareFlights(String sortKey, Map a, Map b) {
//   switch (sortKey) {
//     case 'duration':
//       return parseDurationMins(
//         a['duration'],
//       ).compareTo(parseDurationMins(b['duration']));
//     case 'value':
//       return valueScore(a).compareTo(valueScore(b));
//     case 'cost':
//     default:
//       return parsePrice(a['price']).compareTo(parsePrice(b['price']));
//   }
// }

// Map label to max stops allowed
int maxStopsFor(String stopsLabel) {
  switch (stopsLabel) {
    case 'Nonstop':
      return 0;
    case 'Up to 1 stop':
      return 1;
    case 'Up to 2 stops':
    default:
      return 2;
  }
}

// --- helpers for filters ---
Set<String> layoverCityCodesOf(Map f) {
  final String path = (f['airportPath'] as String? ?? '');
  final List<String> parts = path
      .split('→')
      .map((String s) => s.trim())
      .toList();
  if (parts.length <= 2) return <String>{}; // nonstop

  final List<String> middleIATAs = parts.sublist(1, parts.length - 1);
  final Map<String, dynamic> locMap =
      (f['locations'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{};

  final Set<String> out = <String>{};
  for (final String iata in middleIATAs) {
    final Map<String, dynamic>? details = (locMap[iata] as Map?)
        ?.cast<String, dynamic>();
    final String? city = details?['cityCode'] as String?;
    if (city != null && city.isNotEmpty) out.add(city);
  }
  return out;
}

bool passesAirlineFilter(Map f, Set<String> selected) {
  if (selected.isEmpty) return true; // or false, depending on your UX

  String norm(String s) => s.toUpperCase().trim();

  final Set<String> flightAir =
      ((f['airlines'] as Iterable?) ?? const <dynamic>[])
          .map((e) => norm(e.toString()))
          .toSet();

  final Set<String> selectedNorm = selected.map(norm).toSet();

  // ✅ Show only if EVERY carrier in the itinerary is selected
  return selectedNorm.containsAll(flightAir);
  // (equivalent: return flightAir.difference(selectedNorm).isEmpty;)
}

bool passesLayoverCityFilter(Map f, Set<String> selected) {
  if (selected.isEmpty) return true;
  final Set<String> layoverCities = layoverCityCodesOf(f);
  return layoverCities.any(selected.contains);
}
