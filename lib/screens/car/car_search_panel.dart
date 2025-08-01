import 'package:TFA/constants/font_size.dart';
import 'package:TFA/providers/car/car_search_controller.dart';
import 'package:TFA/providers/recent_search.dart';
import 'package:TFA/screens/shared/calendar_sheet.dart';
import 'package:TFA/screens/shared/recent_search_panel.dart';
import 'package:TFA/screens/shared/search_car_sheet.dart';
import 'package:TFA/screens/shared/show_adaptive_time_picker.dart';
import 'package:TFA/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:geocoding/geocoding.dart';

class CarSearchPanel extends ConsumerStatefulWidget {
  const CarSearchPanel({super.key});

  @override
  ConsumerState<CarSearchPanel> createState() => _CarSearchPanelState();
}

class _CarSearchPanelState extends ConsumerState<CarSearchPanel> {
  static const double _padding = 20.0;
  bool _initialized = false;
  bool _isLoadingCity = true;
  bool _isDifferentDropOff = false;
  String _dropOffCity = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      _initialized = true;

      Future.microtask(() async {
        _setDefaultDateTime();
        await fetchCurrentCountry();
      });
    }
  }

  void _setDefaultDateTime() {
    final now = DateTime.now();
    final today = "${_monthName(now.month)} ${now.day}";
    final time = TimeOfDay.fromDateTime(now).format(context).toLowerCase();

    final controller = ref.read(carSearchProvider.notifier);
    controller.setBeginDate(today);
    controller.setEndDate(today);
    controller.setBeginTime(time);
    controller.setEndTime(time);
  }

  String _monthName(int month) {
    const months = [
      '', // dummy for 0 index
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return months[month];
  }

  Future<void> fetchCurrentCountry() async {
    setState(() => _isLoadingCity = true);

    try {
      final position = await LocationService.getCurrentLocation();
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final city = placemarks.first.locality ?? '';
        ref.read(carSearchProvider.notifier).setCity(city);
        debugPrint("📍 Set city: $city");
      }
    } catch (e) {
      debugPrint("❌ Location error: $e");
    } finally {
      if (mounted) setState(() => _isLoadingCity = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final carState = ref.watch(carSearchProvider);
    final controller = ref.read(carSearchProvider.notifier);

    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: _padding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Different drop-off',
                      style: TextStyle(
                        fontSize: kFontSize14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    FlutterSwitch(
                      value: _isDifferentDropOff,
                      onToggle: (val) {
                        setState(() {
                          _isDifferentDropOff = val;
                        });
                      },
                      width: 50.0,
                      height: 30.0,
                      toggleSize: 25.0,
                      activeColor: Theme.of(context).colorScheme.primary,
                      inactiveColor: Colors.grey.shade600,
                      toggleColor: Colors.white,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: _padding),
                child: Row(
                  children: [
                    // 🟦 Pickup
                    SizedBox(
                      width: !_isDifferentDropOff
                          ? (MediaQuery.of(context).size.width) - _padding * 2
                          : (MediaQuery.of(context).size.width -
                                    _padding * 2 -
                                    8) /
                                2,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1,
                          ),
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
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
                                SearchCarSheet(title: 'Pick-up Location'),
                          );

                          if (result != null) {
                            String city = result['city'];
                            controller.setCity(city);
                          }
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: _isLoadingCity
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                  ),
                                )
                              : Text(
                                  carState.selectedCity.isEmpty
                                      ? 'Pick-up Location'
                                      : carState.selectedCity,
                                  style: TextStyle(
                                    fontSize: kFontSize14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    _isDifferentDropOff
                        ? const SizedBox(width: 8)
                        : const SizedBox.shrink(),
                    // 🟪 Drop-off (only show if toggled ON)
                    _isDifferentDropOff
                        ? SizedBox(
                            width:
                                (MediaQuery.of(context).size.width -
                                    _padding * 2 -
                                    8) /
                                2,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 1,
                                ),
                                foregroundColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
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
                                  builder: (ctx) => SearchCarSheet(
                                    title: 'Drop-off Location',
                                  ),
                                );

                                if (result != null) {
                                  setState(() {
                                    _dropOffCity = result['city'];
                                  });
                                }
                              },
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _dropOffCity.isEmpty
                                      ? 'Drop-off Location'
                                      : _dropOffCity,
                                  style: TextStyle(
                                    fontSize: kFontSize14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            ],
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
                        Text(
                          carState.beginDate,
                          style: TextStyle(
                            fontSize: kFontSize14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3,
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
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1,
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: Text(
                      carState.beginTime,
                      style: TextStyle(
                        fontSize: kFontSize14,
                        fontWeight: FontWeight.bold,
                      ),
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
                        Text(
                          carState.endDate,
                          style: TextStyle(
                            fontSize: kFontSize14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3,
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
                    child: Text(
                      carState.endTime,
                      style: TextStyle(
                        fontSize: kFontSize14,
                        fontWeight: FontWeight.bold,
                      ),
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
