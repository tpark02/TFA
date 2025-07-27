import 'package:chat_app/screens/calendar_sheet.dart';
import 'package:chat_app/screens/recent_search_panel.dart';
import 'package:chat_app/screens/search_car_sheet.dart';
import 'package:chat_app/screens/show_adaptive_time_picker.dart';
import 'package:flutter/material.dart';

class CarSearchPanel extends StatefulWidget {
  const CarSearchPanel({super.key});

  @override
  State<CarSearchPanel> createState() => _CarSearchPanelState();
}

class _CarSearchPanelState extends State<CarSearchPanel> {
  static const double _padding = 20.0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: _padding),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).colorScheme.primary, width: 1),
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
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20))),
                            builder: (ctx) => SearchCarSheet());
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Incheon Intl'),
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
                                  top: Radius.circular(20))),
                          builder: (ctx) => CalendarSheet(
                                firstTitle: "",
                                secondTitle: "",
                                isOnlyTab: true,
                              ));
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.calendar_month),
                        SizedBox(width: _padding),
                        Text('Sun Aug 10th')
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 4,
                  child: OutlinedButton(
                    onPressed: () async {
                      final picked = await showAdaptiveTimePicker(
                          context, TimeOfDay(hour: 12, minute: 0));
                      if (picked != null) {
                        debugPrint("Time picked: ${picked.format(context)}");
                        // update state here
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      // padding: EdgeInsets.only(
                      //     left: 10), // 🔥 Kill default horizontal padding
                      side: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero),
                    ),
                    child: const Text("12:00 pm"),
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
                  flex: 6,
                  child: OutlinedButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20))),
                          builder: (ctx) => CalendarSheet(
                                firstTitle: "",
                                secondTitle: "",
                                isOnlyTab: true,
                              ));
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.calendar_month),
                        SizedBox(width: _padding),
                        Text('Sun Aug 10th')
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 4,
                  child: OutlinedButton(
                    onPressed: () async {
                      final picked = await showAdaptiveTimePicker(
                          context, TimeOfDay(hour: 12, minute: 0));
                      if (picked != null) {
                        debugPrint("Time picked: ${picked.format(context)}");
                        // update state here
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      // padding: EdgeInsets.only(
                      //     left: 10), // 🔥 Kill default horizontal padding
                      side: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero),
                    ),
                    child: const Text("12:00 pm"),
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
                      children: [
                        Text('Search Cars'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(_padding),
            child: Column(
              children: [
                RecentSearchPanel(
                  destination: "Incheon Intl",
                  tripDateRange: "Aug 9 - Aug 11, 12:00pn - 12:00pm",
                  icons: [],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
