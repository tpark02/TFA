// lib/utils/dev_logger.dart
import 'dart:convert';
import 'dart:developer' as dev;

/// RFC 5424-ish numeric levels (same values as package:logging)
class LogLevel {
  static const int FINEST = 300;
  static const int FINER = 400;
  static const int FINE = 500;
  static const int CONFIG = 700;
  static const int INFO = 800;
  static const int WARNING = 900;
  static const int SEVERE = 1000;
  static const int SHOUT = 1200;
}

void logInfo(
  String message, {
  String name = 'app',
  Object? error,
  StackTrace? stackTrace,
  int? seq,
}) => dev.log(
  message,
  name: name,
  level: LogLevel.INFO,
  error: error,
  stackTrace: stackTrace,
  sequenceNumber: seq,
);

void logWarn(
  String message, {
  String name = 'app',
  Object? error,
  StackTrace? stackTrace,
  int? seq,
}) => dev.log(
  message,
  name: name,
  level: LogLevel.WARNING,
  error: error,
  stackTrace: stackTrace,
  sequenceNumber: seq,
);

void logErr(
  String message, {
  String name = 'app',
  Object? error,
  StackTrace? stackTrace,
  int? seq,
}) => dev.log(
  message,
  name: name,
  level: LogLevel.SEVERE,
  error: error,
  stackTrace: stackTrace,
  sequenceNumber: seq,
);

void logFine(String message, {String name = 'app', int? seq}) =>
    dev.log(message, name: name, level: LogLevel.FINE, sequenceNumber: seq);

/// Pretty JSON (auto-chunks to avoid truncation in some consoles)
void logJson(
  Object? data, {
  String name = 'app.json',
  String headline = 'payload',
  int chunk = 800,
}) {
  final String s = const JsonEncoder.withIndent('  ').convert(data);
  if (s.length <= chunk) {
    dev.log('$headline:\n$s', name: name, level: LogLevel.FINE);
    return;
  }
  dev.log(
    '$headline (len=${s.length}) — chunked',
    name: name,
    level: LogLevel.FINE,
  );
  for (int i = 0; i < s.length; i += chunk) {
    dev.log(
      s.substring(i, i + chunk > s.length ? s.length : i + chunk),
      name: name,
      level: LogLevel.FINEST,
      sequenceNumber: i ~/ chunk,
    );
  }
}

/// HTTP helpers
void logHttpStart(Uri uri, {String name = 'http'}) =>
    logInfo('→ GET $uri', name: name);

void logHttpDone(int status, {String name = 'http'}) =>
    (status >= 200 && status < 300)
    ? logInfo('← $status OK', name: name)
    : logWarn('← $status', name: name);
