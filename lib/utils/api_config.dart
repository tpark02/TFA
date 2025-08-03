// lib/utils/api_config.dart
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

String get baseUrl {
  if (Platform.isAndroid) {
    return "http://10.0.2.2:8000"; // Android Emulator
  } else {
    return "http://localhost:8000"; // iOS Simulator, macOS
  }
}

Uri getBackendUri() {
  if (kIsWeb) {
    return Uri.parse('http://localhost:8000/api/v1/auth/me');
  }

  if (Platform.isAndroid) {
    return Uri.parse('http://10.0.2.2:8000/api/v1/auth/me');
  }

  return Uri.parse('http://localhost:8000/api/v1/auth/me');
}
