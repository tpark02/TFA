// lib/utils/api_config.dart
import 'dart:io';

String get baseUrl {
  if (Platform.isAndroid) {
    return "http://10.0.2.2:8000"; // Android Emulator
  } else {
    return "http://localhost:8000"; // iOS Simulator, macOS
  }
}
