// flight_page_trigger_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum MenuTab { home, search, travel, account }

final StateProvider<MenuTab> menuTabProvider = StateProvider<MenuTab>((StateProviderRef<MenuTab> ref) => MenuTab.home);
