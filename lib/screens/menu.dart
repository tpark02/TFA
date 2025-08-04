import 'package:TFA/providers/menu_tab_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:TFA/screens/search.dart';
import 'package:TFA/screens/home.dart';

class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(menuTabProvider);

    Widget body;
    switch (currentTab) {
      case MenuTab.home:
        body = const HomeScreen();
        break;
      case MenuTab.search:
        body = const SearchScreen();
        break;
      case MenuTab.travel:
        body = const Center(child: Text('여행'));
        break;
      case MenuTab.account:
        body = const Center(child: Text('계정'));
        break;
    }

    return Scaffold(
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex:
            [
              MenuTab.home,
              MenuTab.search,
              MenuTab.travel,
              MenuTab.account,
            ].contains(currentTab)
            ? [
                MenuTab.home,
                MenuTab.search,
                MenuTab.travel,
                MenuTab.account,
              ].indexOf(currentTab)
            : 0, // fallback when on flightList (or any non-tab screen)
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          ref.read(menuTabProvider.notifier).state = MenuTab.values[index];
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_travel),
            label: 'Travel',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}
