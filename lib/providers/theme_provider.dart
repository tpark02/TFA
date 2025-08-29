// providers/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeModeProvider = StateNotifierProvider<ThemeModeController, ThemeMode>(
  (ref) {
    return ThemeModeController()..load();
  },
);

class ThemeModeController extends StateNotifier<ThemeMode> {
  ThemeModeController() : super(ThemeMode.system);

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    final v = p.getString('themeMode') ?? 'system';
    state = _from(v);
  }

  Future<void> set(ThemeMode m) async {
    state = m;
    final p = await SharedPreferences.getInstance();
    await p.setString('themeMode', _to(m));
  }

  ThemeMode _from(String v) => v == 'light'
      ? ThemeMode.light
      : v == 'dark'
      ? ThemeMode.dark
      : ThemeMode.system;
  String _to(ThemeMode m) => m == ThemeMode.light
      ? 'light'
      : m == ThemeMode.dark
      ? 'dark'
      : 'system';
}
