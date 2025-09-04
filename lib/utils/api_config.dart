import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

const String _envApiUrl = String.fromEnvironment('API_URL');

String get baseUrl {
  if (_envApiUrl.isNotEmpty) {
    String s = _envApiUrl.trim();
    if (!s.startsWith('http')) s = 'https://$s';
    return s.endsWith('/') ? s.substring(0, s.length - 1) : s;
  }
  if (kIsWeb) return 'http://localhost:8000';
  if (Platform.isAndroid) return 'http://10.0.2.2:8000';
  return 'http://localhost:8000';
}

Uri apiUri(String path, {Map<String, dynamic>? query}) {
  final Uri root = Uri.parse(baseUrl);
  return Uri(
    scheme: root.scheme,
    host: root.host,
    port: root.hasPort ? root.port : null,
    path: path.startsWith('/') ? path : '/$path',
    queryParameters: query?.map((String k, v) => MapEntry(k, '$v')),
  );
}
