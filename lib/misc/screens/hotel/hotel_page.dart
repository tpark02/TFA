import 'package:TFA/misc/providers/hotel/hotel_search_controller.dart';
import 'package:TFA/misc/providers/hotel/hotel_search_state.dart';
import 'package:TFA/providers/recent_search.dart';
import 'package:TFA/misc/screens/hotel/hotel_list_page.dart';
import 'package:TFA/screens/shared/recent_search_list.dart';
import 'package:TFA/screens/shared/room_guest_selector_sheet.dart';
import 'package:TFA/misc/shared/search_hotel_sheet.dart';
import 'package:TFA/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:TFA/services/location_service.dart'; // ✅ your service
import 'package:geocoding/geocoding.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';

class HotelPage extends ConsumerStatefulWidget {
  const HotelPage({super.key});
  @override
  ConsumerState<HotelPage> createState() => _HotelPageState();
}

class _HotelPageState extends ConsumerState<HotelPage> {
  static const double _padding = 20.0;
  bool _isLoadingCity = true;
  bool _initialized = false;
  final User? user = FirebaseAuth.instance.currentUser;
  static const int startDays = 0;
  static const int endDays = 2;

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
        ref.read(hotelSearchProvider.notifier).setCity(city);
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

    final HotelSearchController controller = ref.read(
      hotelSearchProvider.notifier,
    );
    final DateTime startDate = DateTime.now();
    final DateTime endDate = DateTime.now().add(const Duration(days: endDays));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.setTripDates(departDate: startDate, returnDate: endDate);
    });

    Future.microtask(() {
      ref.read(hotelSearchProvider.notifier).loadRecentSearches();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      _initialized = true;

      Future<void>.microtask(() async {
        await fetchCurrentCountry();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final HotelSearchState hotelState = ref.watch(hotelSearchProvider);
    final HotelSearchController controller = ref.read(
      hotelSearchProvider.notifier,
    );

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
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
                children: <Widget>[
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
                        fetchCurrentCountry();
                        final result = await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (BuildContext ctx) =>
                              const SearchHotelSheet(title: "Hotels"),
                        );
                        if (result != null) {
                          final String city = result['city'];
                          debugPrint(city);
                          controller.setCity(city);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const Icon(Icons.apartment),
                          const SizedBox(width: 8),
                          _isLoadingCity
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                  ),
                                )
                              : Text(
                                  hotelState.city,
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
                ],
              ),
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
                        true,
                        startDays,
                        endDays,
                      );
                      if (result != null) {
                        final DateTime? departDate = result['departDate'];
                        final DateTime? returnDate = result['returnDate'];

                        controller.setTripDates(
                          departDate: departDate!,
                          returnDate: returnDate,
                        );
                        debugPrint(
                          "📅 selected dates depart date : $departDate, end date : ${returnDate ?? "empty"}",
                        );
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1,
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        const Icon(Icons.calendar_month),
                        Text(
                          hotelState.displayDate ?? 'Select',
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
                        builder: (BuildContext ctx) =>
                            const RoomGuestSelectorSheet(),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Icon(Icons.bed),
                        const SizedBox(width: 5),
                        Text(
                          hotelState.roomCnt,
                          style: TextStyle(
                            fontSize: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.fontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Text('|'),
                        const SizedBox(width: 5),
                        const Icon(Icons.person),
                        Text(
                          ((int.tryParse(hotelState.adultCnt) ?? 0) +
                                  (int.tryParse(hotelState.childCnt) ?? 0))
                              .toString(),
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
                      debugPrint(hotelState.toString());
                      final bool hasCity = hotelState.city.isNotEmpty;
                      final bool hasDate =
                          (hotelState.displayDate ?? '').isNotEmpty;
                      final bool hasGuests =
                          ((int.tryParse(hotelState.adultCnt) ?? 0) +
                              (int.tryParse(hotelState.childCnt) ?? 0)) >
                          0;
                      final bool hasRoom =
                          (int.tryParse(hotelState.roomCnt) ?? 0) > 0;

                      if (!hasCity || !hasGuests || !hasRoom || !hasDate) {
                        return;
                      }

                      final int totalGuest =
                          ((int.tryParse(hotelState.adultCnt) ?? 0) +
                          (int.tryParse(hotelState.childCnt) ?? 0));

                      final String? idToken = await user!.getIdToken();

                      final bool success = await controller.addRecentSearch(
                        RecentSearch(
                          destination: hotelState.city,
                          tripDateRange: hotelState.displayDate ?? '',
                          icons: <Widget>[
                            const SizedBox(width: 10),
                            Icon(
                              Icons.bed,
                              color: Colors.grey[500],
                              size: 20.0,
                            ),
                            Text(hotelState.roomCnt),
                            const SizedBox(width: 10),
                            Icon(
                              Icons.person,
                              color: Colors.grey[500],
                              size: 20.0,
                            ),
                            Text(totalGuest.toString()),
                          ],
                          destinationCode: '',
                          passengerCnt: totalGuest,
                          rooms: int.tryParse(hotelState.roomCnt)!,
                          kind: 'hotel',
                          departCode: 'n/a',
                          arrivalCode: 'n/a',
                          departDate: 'n/a',
                          returnDate: 'n/a',
                        ),
                        idToken!,
                      );
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const HotelListPage(),
                          ),
                        );
                      });
                      if (!success) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                '❌ Failed to save horel recent search',
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
                      children: <Widget>[Text('Search Hotel')],
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
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      "Suggestions",
                      style: TextStyle(
                        fontSize: Theme.of(
                          context,
                        ).textTheme.headlineMedium?.fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: _padding),
                Row(
                  children: <Widget>[
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
                              children: <Widget>[
                                const Icon(
                                  Icons.near_me,
                                  color: Color.fromRGBO(0, 140, 255, 1),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      hotelState.city,
                                      style: TextStyle(
                                        fontSize: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium?.fontSize,
                                        color: const Color.fromRGBO(
                                          99,
                                          99,
                                          99,
                                          1,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "Tonight",
                                      style: TextStyle(
                                        fontSize: Theme.of(
                                          context,
                                        ).textTheme.bodySmall?.fontSize,
                                        color: const Color.fromRGBO(
                                          99,
                                          99,
                                          99,
                                          1,
                                        ),
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
                                  child: const Text(
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
                const SizedBox(height: _padding),
                const RecentSearchList(panelName: 'hotel'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
