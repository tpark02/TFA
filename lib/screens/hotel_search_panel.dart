import 'package:chat_app/providers/hotel/hotel_search_controller.dart';
import 'package:chat_app/screens/calendar_sheet.dart';
import 'package:chat_app/screens/recent_search_panel.dart';
import 'package:chat_app/screens/room_guest_selector_sheet.dart';
import 'package:chat_app/screens/search_hotel_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HotelSearchPanel extends ConsumerStatefulWidget {
  const HotelSearchPanel({super.key});
  @override
  ConsumerState<HotelSearchPanel> createState() => _HotelSearchPanelState();
}

class _HotelSearchPanelState extends ConsumerState<HotelSearchPanel> {
  static const double _padding = 20.0;
  @override
  Widget build(BuildContext context) {
    final hotelState = ref.watch(hotelSearchProvider);
    final controller = ref.read(hotelSearchProvider.notifier);

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: _padding),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide.none, // Remove default border
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      onPressed: () async {
                        final result = await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (ctx) =>
                              const SearchHotelSheet(title: "Hotel"),
                        );
                        if (result != null) {
                          String country = result['country'];
                          debugPrint(country);
                          controller.setCountry(country);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.apartment),
                          const SizedBox(width: 8),
                          Text(hotelState.country),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: _padding),
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: OutlinedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (ctx) => CalendarSheet(
                          firstTitle: "",
                          secondTitle: "",
                          isOnlyTab: true,
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1,
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.calendar_month),
                        SizedBox(width: _padding),
                        Text('Search'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 4,
                  child: OutlinedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (ctx) => const RoomGuestSelectorSheet(),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      // padding: EdgeInsets.only(
                      //     left: 10), // 🔥 Kill default horizontal padding
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1,
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.bed),
                        SizedBox(width: 5),
                        Text('1'),
                        SizedBox(width: 5),
                        Text('|'),
                        SizedBox(width: 5),
                        Icon(Icons.person),
                        Text('2'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: _padding),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('Search Hotel')],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Bottom box
          Padding(
            padding: const EdgeInsets.all(_padding),
            child: Column(
              children: [
                const Row(
                  children: [
                    Text(
                      "Suggestions",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: _padding),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          // your code here
                        },
                        child: Card(
                          elevation: 1,
                          color: Theme.of(context).cardColor,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.near_me,
                                  color: Color.fromRGBO(0, 140, 255, 1),
                                ),
                                SizedBox(width: 8),
                                Column(
                                  children: [
                                    Text(
                                      "Seoul",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color.fromRGBO(99, 99, 99, 1),
                                      ),
                                    ),
                                    Text(
                                      "Tonight",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color.fromRGBO(99, 99, 99, 1),
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Container(
                                  width: 100,
                                  height: 30,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    borderRadius: BorderRadius.zero,
                                  ),
                                  child: Text(
                                    "Check",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: _padding),
                RecentSearchPanel(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
