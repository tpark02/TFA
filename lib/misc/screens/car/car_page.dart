import 'package:TFA/misc/providers/car/car_search_controller.dart';
import 'package:TFA/misc/providers/car/car_search_state.dart';
import 'package:TFA/providers/recent_search.dart';
import 'package:TFA/screens/shared/recent_search_list.dart';
import 'package:TFA/misc/shared/search_car_sheet.dart';
import 'package:TFA/screens/shared/show_adaptive_time_picker.dart';
import 'package:TFA/services/location_service.dart';
import 'package:TFA/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';

class CarPage extends ConsumerStatefulWidget {
  const CarPage({super.key});

  @override
  ConsumerState<CarPage> createState() => _CarPageState();
}

class _CarPageState extends ConsumerState<CarPage> {
  static const int startDays = 0;
  static const int endDays = 2;

  static const double _padding = 20.0;
  bool _initialized = false;
  bool _isLoadingCity = true;
  bool _isDifferentDropOff = false;
  String _dropOffCity = '';
  final User? user = FirebaseAuth.instance.currentUser;

  Future<void> fetchCurrentCountry() async {
    setState(() => _isLoadingCity = true);

    try {
      final Position position = await LocationService.getCurrentLocation();
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final String city = placemarks.first.locality ?? '';
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
  void initState() {
    super.initState();

    final CarSearchController controller = ref.read(carSearchProvider.notifier);
    final DateTime departDate = DateTime.now();
    final DateTime returnDate = DateTime.now().add(
      const Duration(days: endDays),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.setTripDates(departDate: departDate, returnDate: returnDate);

      final TimeOfDay defaultTime = const TimeOfDay(hour: 12, minute: 0);
      final String formatted = defaultTime.format(context).toLowerCase();

      controller.setBeginTime(formatted);
      controller.setEndTime(formatted);
    });

    Future.microtask(() {
      ref.read(carSearchProvider.notifier).loadRecentSearchesFromApi();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      _initialized = true;

      Future.microtask(() async {
        await fetchCurrentCountry();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final CarSearchState carState = ref.watch(carSearchProvider);
    final CarSearchController controller = ref.read(carSearchProvider.notifier);

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: _padding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'Different drop-off',
                      style: TextStyle(
                        fontSize: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.fontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    FlutterSwitch(
                      value: _isDifferentDropOff,
                      onToggle: (bool val) {
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
                  children: <Widget>[
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
                            builder: (BuildContext ctx) =>
                                const SearchCarSheet(title: 'Pick-up Location'),
                          );

                          if (result != null) {
                            final String city = result['city'];
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
                                    fontSize: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.fontSize,
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
                                  builder: (BuildContext ctx) =>
                                      const SearchCarSheet(
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
                                    fontSize: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.fontSize,
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
              children: <Widget>[
                Expanded(
                  flex: 6,
                  child: OutlinedButton(
                    onPressed: () async {
                      final Map<String, DateTime?>? result = await showCalender(
                        context,
                        ref,
                        '',
                        '',
                        true,
                        false,
                        startDays,
                        endDays,
                      );
                      if (result != null) {
                        final DateTime? departDate = result['departDate'];
                        controller.setDepartDate(departDate);
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
                      children: <Widget>[
                        const Icon(Icons.calendar_month),
                        const SizedBox(width: _padding),
                        Text(
                          carState.displayDepartDate,
                          style: TextStyle(
                            fontSize: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.fontSize,
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
                      final TimeOfDay? picked = await showAdaptiveTimePicker(
                        context,
                        const TimeOfDay(hour: 12, minute: 0),
                      );
                      if (picked != null) {
                        debugPrint("Time picked: ${picked.format(context)}");
                        final String formatted = picked
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
                        fontSize: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.fontSize,
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
              children: <Widget>[
                Expanded(
                  flex: 6,
                  child: OutlinedButton(
                    onPressed: () async {
                      final Map<String, DateTime?>? result = await showCalender(
                        context,
                        ref,
                        '',
                        '',
                        true,
                        false,
                        startDays + 2,
                        endDays,
                      );

                      if (result != null) {
                        final DateTime? returnDate = result['departDate'];
                        controller.setReturnDate(returnDate);
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
                      children: <Widget>[
                        const Icon(Icons.calendar_month),
                        const SizedBox(width: _padding),
                        Text(
                          carState.displayReturnDate ?? 'N/A',
                          style: TextStyle(
                            fontSize: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.fontSize,
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
                      final TimeOfDay? picked = await showAdaptiveTimePicker(
                        context,
                        const TimeOfDay(hour: 12, minute: 0),
                      );
                      if (picked != null) {
                        debugPrint("Time picked: ${picked.format(context)}");
                        final String formatted = picked
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
                        fontSize: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.fontSize,
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
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      debugPrint(carState.toString());
                      final bool hasCity = carState.selectedCity.isNotEmpty;
                      final bool hasDate =
                          ((carState.departDate ?? '').isNotEmpty) &&
                          ((carState.returnDate ?? '').isNotEmpty) &&
                          ((carState.beginTime ?? '').isNotEmpty) &&
                          ((carState.endTime ?? '').isNotEmpty);
                      if (!hasCity || !hasDate) {
                        return;
                      }

                      final String displayDate =
                          '${carState.departDate} - ${carState.returnDate}, ${carState.beginTime} - ${carState.endTime}';

                      final String? idToken = await user!.getIdToken();

                      final bool success = await controller.addRecentSearch(
                        RecentSearch(
                          destination: carState.selectedCity,
                          tripDateRange: displayDate,
                          icons: <Widget>[],
                          destinationCode: '',
                          passengerCnt: -1,
                          rooms: 0,
                          kind: 'car',
                          departCode: 'n/a',
                          arrivalCode: 'n/a',
                          departDate: 'n/a',
                          returnDate: 'n/a',
                        ),
                        idToken!,
                      );
                      if (!success) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                '❌ Failed to save car recent search',
                              ),
                            ),
                          );
                        });
                      }
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
                      children: <Widget>[Text('Search Cars')],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(_padding),
            child: Column(
              children: <Widget>[
                SizedBox(height: _padding),
                RecentSearchList(panelName: 'car'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
