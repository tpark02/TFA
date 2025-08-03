import 'package:TFA/constants/font_size.dart';
import 'package:TFA/providers/hotel/hotel_search_controller.dart';
import 'package:TFA/providers/recent_search.dart';
import 'package:TFA/screens/shared/calendar_sheet.dart';
import 'package:TFA/screens/shared/recent_search_panel.dart';
import 'package:TFA/screens/shared/room_guest_selector_sheet.dart';
import 'package:TFA/screens/shared/search_hotel_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:TFA/services/location_service.dart'; // ✅ your service
import 'package:geocoding/geocoding.dart';

class HotelSearchPanel extends ConsumerStatefulWidget {
  const HotelSearchPanel({super.key});
  @override
  ConsumerState<HotelSearchPanel> createState() => _HotelSearchPanelState();
}

class _HotelSearchPanelState extends ConsumerState<HotelSearchPanel> {
  static const double _padding = 20.0;
  bool _isLoadingCity = true;
  bool _initialized = false;

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
    final controller = ref.read(hotelSearchProvider.notifier);
    controller.setDisplayDate('$today - $today');
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
                        fetchCurrentCountry();
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
                          String city = result['city'];
                          debugPrint(city);
                          controller.setCity(city);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
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
                                    fontSize: kFontSize14,
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
                          firstTitle: "",
                          secondTitle: "",
                          isOnlyTab: true,
                          isRange: true,
                        ),
                      );

                      if (result != null && result['displayDate'] != null) {
                        controller.setDisplayDate(result['displayDate']);
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
                          hotelState.displayDate ?? 'Select',
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
                  flex: 4,
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
                        builder: (ctx) => const RoomGuestSelectorSheet(),
                      );

                      if (result != null) {
                        final roomCnt = result['roomCnt'];
                        final guestsCnt = result['guestsCnt'];
                        final adultCnt = result['adultCnt'];
                        final childCnt = result['childCnt'];

                        final rooms = roomCnt is int ? roomCnt : 1;

                        debugPrint(
                          'guestCnt: $guestsCnt (${guestsCnt.runtimeType})',
                        );

                        controller.setRoomCnt(rooms.toString());
                        controller.setAdultCnt(adultCnt.toString());
                        controller.setChildCnt(childCnt.toString());
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.bed),
                        SizedBox(width: 5),
                        Text(
                          hotelState.roomCnt,
                          style: TextStyle(
                            fontSize: kFontSize14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 5),
                        Text('|'),
                        SizedBox(width: 5),
                        Icon(Icons.person),
                        Text(
                          ((int.tryParse(hotelState.adultCnt) ?? 0) +
                                  (int.tryParse(hotelState.childCnt) ?? 0))
                              .toString(),
                          style: TextStyle(
                            fontSize: kFontSize14,
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
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      debugPrint(hotelState.toString());
                      final hasCity = hotelState.city.isNotEmpty;
                      final hasDate = (hotelState.displayDate ?? '').isNotEmpty;
                      final hasGuests =
                          ((int.tryParse(hotelState.adultCnt) ?? 0) +
                              (int.tryParse(hotelState.childCnt) ?? 0)) >
                          0;
                      final hasRoom =
                          (int.tryParse(hotelState.roomCnt) ?? 0) > 0;

                      if (!hasCity || !hasGuests || !hasRoom || !hasDate) {
                        return;
                      }

                      int totalGuest =
                          ((int.tryParse(hotelState.adultCnt) ?? 0) +
                          (int.tryParse(hotelState.childCnt) ?? 0));

                      controller.addRecentSearch(
                        RecentSearch(
                          destination: hotelState.city,
                          tripDateRange: hotelState.displayDate ?? '',
                          icons: [
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
                          guests: totalGuest,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      hotelState.city,
                                      style: TextStyle(
                                        fontSize: kFontSize14,
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
                RecentSearchPanel(panelName: 'hotel'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
