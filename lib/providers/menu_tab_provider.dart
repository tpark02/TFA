import 'package:flutter_riverpod/flutter_riverpod.dart';

enum MenuTab { home, search, travel, account }

final menuTabProvider = StateProvider<MenuTab>((ref) => MenuTab.home);
