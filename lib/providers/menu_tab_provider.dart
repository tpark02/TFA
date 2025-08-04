// flight_page_trigger_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum MenuTab { home, search, travel, account }

final menuTabProvider = StateProvider<MenuTab>((ref) => MenuTab.home);
