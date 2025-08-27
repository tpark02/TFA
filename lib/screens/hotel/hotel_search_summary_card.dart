import 'package:TFA/providers/hotel/hotel_search_controller.dart';
import 'package:TFA/providers/hotel/hotel_search_state.dart';
import 'package:TFA/screens/shared/calendar_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HotelSearchSummaryCard extends ConsumerWidget {
  final String city;
  final String dateRange;
  final String roomCnt;
  final String guestsCnt;

  const HotelSearchSummaryCard({
    super.key,
    required this.city,
    required this.dateRange,
    required this.roomCnt,
    required this.guestsCnt,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final HotelSearchController controller = ref.read(
      hotelSearchProvider.notifier,
    );
    final HotelSearchState hotelState = ref.watch(hotelSearchProvider);

    return Container(
      padding: const EdgeInsets.all(8),
      color: Theme.of(context).colorScheme.secondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              InkWell(
                onTap: () {},
                child: Text(
                  city,
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              const SizedBox(width: 10),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextButton(
                onPressed: () async {
                  final Map<String, DateTime?>? result =
                      await Navigator.of(
                        context,
                        rootNavigator: true,
                      ).push<Map<String, DateTime?>>(
                        MaterialPageRoute<Map<String, DateTime?>>(
                          builder: (_) => CalendarSheet(
                            key: UniqueKey(),
                            firstTitle: 'One Way',
                            secondTitle: 'Round Trip',
                            isOnlyTab: false,
                            isRange: false,
                            startDays: 0,
                            endDays: 0,
                          ),
                        ),
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
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  dateRange,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              Flexible(
                child: InkWell(
                  onTap: () async {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(width: 5),
                      const Text("|", style: TextStyle(color: Colors.white)),
                      const SizedBox(width: 5),
                      const Icon(Icons.bed, color: Colors.white, size: 16),
                      const SizedBox(width: 5),
                      Text(
                        roomCnt,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(width: 5),
                      const Icon(Icons.person, color: Colors.white, size: 16),
                      const SizedBox(width: 5),
                      Text(
                        guestsCnt,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
