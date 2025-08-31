import 'package:TFA/misc/providers/hotel/hotel_search_controller.dart';
import 'package:TFA/widgets/counter_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoomGuestSelectorSheet extends ConsumerStatefulWidget {
  const RoomGuestSelectorSheet({super.key});
  @override
  ConsumerState<RoomGuestSelectorSheet> createState() =>
      _RoomGuestSelectorSheet();
}

class _RoomGuestSelectorSheet extends ConsumerState<RoomGuestSelectorSheet> {
  int _rooms = 1;
  int _adultCount = 1;
  int _childCount = 0;
  late final HotelSearchController controller;

  @override
  void initState() {
    super.initState();
    controller = ref.read(hotelSearchProvider.notifier);
  }

  @override
  Widget build(BuildContext content) {
    final double height =
        MediaQuery.of(context).size.height * 0.40; // 65% of screen height
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.zero),
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          constraints: BoxConstraints(maxHeight: height),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      child: const Text(
                        "Number of Rooms / Guests",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "Number of Rooms",
                            style: TextStyle(
                              fontSize: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.fontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: CounterControl(
                              count: _rooms,
                              onChanged: (int val) =>
                                  setState(() => _rooms = val),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Number of Adults",
                              style: TextStyle(
                                fontSize: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.fontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: CounterControl(
                              count: _adultCount,
                              onChanged: (int val) =>
                                  setState(() => _adultCount = val),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Number of Children",
                              style: TextStyle(
                                fontSize: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.fontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: CounterControl(
                              count: _childCount,
                              onChanged: (int val) =>
                                  setState(() => _childCount = val),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    controller.updateGuestCounts(
                      roomCnt: _rooms.toString(),
                      adultCnt: _adultCount.toString(),
                      childCnt: _childCount.toString(),
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Done',
                        style: TextStyle(
                          fontSize: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.fontSize,
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
    );
  }
}
