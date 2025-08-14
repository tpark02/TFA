int parseIsoDurationToMin(String iso) {
  // "PT9H44M" => minutes
  final RegExp re = RegExp(
    r'^P(?:\d+Y)?(?:\d+M)?(?:\d+D)?T?(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?$',
  );
  final RegExpMatch? m = re.firstMatch(iso);
  if (m == null) return 0;
  final int h = int.tryParse(m.group(1) ?? '0') ?? 0;
  final int min = int.tryParse(m.group(2) ?? '0') ?? 0;
  final int s = int.tryParse(m.group(3) ?? '0') ?? 0;
  return h * 60 + min + (s > 0 ? 1 : 0); // round up if seconds present
}
