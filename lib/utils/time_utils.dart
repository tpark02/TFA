/// Converts total minutes (0–1439) to formatted time like `12:45p`.
String formatTime(int minutes) {
  final hours = minutes ~/ 60;
  final mins = minutes % 60;
  final period = hours < 12 ? 'a' : 'p';
  final displayHour = hours % 12 == 0 ? 12 : hours % 12;
  final displayMin = mins.toString().padLeft(2, '0');
  return '$displayHour:$displayMin$period';
}

/// Converts total minutes to duration format like `5h 30m`.
String formatDuration(int minutes) {
  final hours = minutes ~/ 60;
  final mins = minutes % 60;
  return '${hours}h ${mins}m';
}
