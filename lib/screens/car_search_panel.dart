import 'package:chat_app/providers/car/car_search_controller.dart';
import 'package:chat_app/providers/recent_search.dart';
import 'package:chat_app/screens/calendar_sheet.dart';
import 'package:chat_app/screens/recent_search_panel.dart';
import 'package:chat_app/screens/search_car_sheet.dart';
import 'package:chat_app/screens/show_adaptive_time_picker.dart';
import 'package:chat_app/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';

class CarSearchPanel extends ConsumerStatefulWidget {
  const CarSearchPanel({super.key});

  @override
  ConsumerState<CarSearchPanel> createState() => _CarSearchPanelState();
}

class _CarSearchPanelState extends ConsumerState<CarSearchPanel> {
  static const double _padding = 20.0;

  Future<void> fetchCurrentCountry() async {
    try {
      final position =
          await LocationService.getCurrentLocation(); // ✅ your class
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final city = placemarks.first.locality ?? '';
        ref.read(carSearchProvider.notifier).setCity(city);
        debugPrint("📍 Set country: $city");
      }
    } catch (e) {
      debugPrint("❌ Location error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final carState = ref.watch(carSearchProvider);
    final controller = ref.read(carSearchProvider.notifier);

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
                          builder: (ctx) => SearchCarSheet(title: 'Cars'),
                        );

                        if (result != null) {
                          String city = result['city'];
                          debugPrint(city);
                          controller.setCity(city);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [Text(carState.selectedCity)],
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
                    onPressed: () async {
                      final result = await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (ctx) => CalendarSheet(
                          key: UniqueKey(), // ✅ Force new state
                          firstTitle: "",
                          secondTitle: "",
                          isOnlyTab: true,
                          isRange: false,
                        ),
                      );

                      if (result != null) {
                        debugPrint('SET BEGIN: ${result['displayDate']}');
                        controller.setBeginDate(result['displayDate']);
                        debugPrint(
                          'AFTER BEGIN STATE: ${ref.read(carSearchProvider).beginDate}',
                        );
                      }
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
                    child: Row(
                      children: [
                        Icon(Icons.calendar_month),
                        SizedBox(width: _padding),
                        Text(carState.beginDate),
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
                        context,
                        TimeOfDay(hour: 12, minute: 0),
                      );
                      if (picked != null) {
                        debugPrint("Time picked: ${picked.format(context)}");
                        String formatted = picked
                            .format(context)
                            .toLowerCase(); // → "12:00 PM"

                        controller.setBeginTime(formatted.toString());
                      }
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
                    child: Text(carState.beginTime),
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
                    onPressed: () async {
                      final result = await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (ctx) => CalendarSheet(
                          key: UniqueKey(), // ✅ Force new state
                          firstTitle: "",
                          secondTitle: "",
                          isOnlyTab: true,
                          isRange: false,
                        ),
                      );
                      if (result != null) {
                        debugPrint('SET END: ${result['displayDate']}');
                        controller.setEndDate(result['displayDate']);
                        debugPrint(
                          'AFTER END STATE: ${ref.read(carSearchProvider).endDate}',
                        );
                      }
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
                    child: Row(
                      children: [
                        Icon(Icons.calendar_month),
                        SizedBox(width: _padding),
                        Text(carState.endDate),
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
                        context,
                        TimeOfDay(hour: 12, minute: 0),
                      );
                      if (picked != null) {
                        debugPrint("Time picked: ${picked.format(context)}");
                        String formatted = picked
                            .format(context)
                            .toLowerCase(); // → "12:00 PM"

                        controller.setEndTime(formatted.toString());
                      }
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
                    child: Text(carState.endTime),
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
                    onPressed: () {
                      debugPrint(carState.toString());
                      final hasCity = carState.selectedCity.isNotEmpty;
                      final hasDate =
                          ((carState.beginDate ?? '').isNotEmpty) &&
                          ((carState.endDate ?? '').isNotEmpty) &&
                          ((carState.beginTime ?? '').isNotEmpty) &&
                          ((carState.endTime ?? '').isNotEmpty);
                      if (!hasCity || !hasDate) {
                        return;
                      }

                      String displayDate =
                          '${carState.beginDate} - ${carState.endDate}, ${carState.beginTime} - ${carState.endTime}';

                      controller.addRecentSearch(
                        RecentSearch(
                          destination: carState.selectedCity,
                          tripDateRange: displayDate ?? '',
                          icons: [],
                          destinationCode: '',
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('Search Cars')],
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
                SizedBox(height: _padding),
                RecentSearchPanel(panelName: 'car'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
