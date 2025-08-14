/// Converts total minutes (0–1439) to formatted time like `12:45p`.
String formatTime(int minutes) {
  final int hours = minutes ~/ 60;
  final int mins = minutes % 60;
  final String period = hours < 12 ? 'a' : 'p';
  final int displayHour = hours % 12 == 0 ? 12 : hours % 12;
  final String displayMin = mins.toString().padLeft(2, '0');
  return '$displayHour:$displayMin$period';
}

/// Converts total minutes to duration format like `5h 30m`.
String formatDuration(int minutes) {
  final int hours = minutes ~/ 60;
  final int mins = minutes % 60;
  return '${hours}h ${mins}m';
}
