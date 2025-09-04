// lib/screens/menu.dart  (replace your current MenuScreen)
import 'package:TFA/l10n/app_localizations.dart';
import 'package:TFA/providers/menu_tab_provider.dart';
import 'package:TFA/providers/navigation.dart';
import 'package:TFA/screens/flight/my_trips_page.dart';
import 'package:TFA/screens/profiile/profile_settings_page.dart';
import 'package:TFA/screens/search.dart';
import 'package:TFA/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MenuTab currentTab = ref.watch(menuTabProvider);
    final AppLocalizations text = AppLocalizations.of(context)!;

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: currentTab.index,
        children: <Widget>[
          // Each tab gets its own Navigator
          _TabNavigator(navKey: homeTabNavKey, child: const HomeScreen()),
          _TabNavigator(navKey: searchTabNavKey, child: const SearchScreen()),
          _TabNavigator(navKey: travelTabNavKey, child: const MyTripsPage()),
          _TabNavigator(
            navKey: accountTabNavKey,
            child: const ProfileSettingsPage(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentTab.index,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (int i) =>
            ref.read(menuTabProvider.notifier).state = MenuTab.values[i],
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

class _TabNavigator extends StatelessWidget {
  const _TabNavigator({required this.navKey, required this.child});
  final GlobalKey<NavigatorState> navKey;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navKey,
      onGenerateRoute: (RouteSettings settings) => MaterialPageRoute(builder: (_) => child),
    );
  }
}
