import 'package:TFA/l10n/app_localizations.dart';
import 'package:TFA/providers/menu_tab_provider.dart';
import 'package:TFA/screens/flight/my_trips_page.dart';
import 'package:TFA/screens/profiile/profile_settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:TFA/screens/search.dart';
import 'package:TFA/screens/home.dart';

class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MenuTab currentTab = ref.watch(menuTabProvider);
    final text = AppLocalizations.of(context)!;

    Widget body;
    switch (currentTab) {
      case MenuTab.home:
        body = const HomeScreen();
        break;
      case MenuTab.search:
        body = const SearchScreen();
        break;
      case MenuTab.travel:
        body = const MyTripsPage();
        break;
      case MenuTab.account:
        body = const ProfileSettingsPage();
        break;
    }

    return Scaffold(
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex:
            <MenuTab>[
              MenuTab.home,
              MenuTab.search,
              MenuTab.travel,
              MenuTab.account,
            ].contains(currentTab)
            ? <MenuTab>[
                MenuTab.home,
                MenuTab.search,
                MenuTab.travel,
                MenuTab.account,
              ].indexOf(currentTab)
            : 0,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (int index) {
          ref.read(menuTabProvider.notifier).state = MenuTab.values[index];
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: text.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            label: text.search,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.watch_later_outlined),
            label: text.my_trip,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: text.account,
          ),
        ],
      ),
    );
  }
}
