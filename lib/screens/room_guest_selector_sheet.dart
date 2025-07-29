import 'package:chat_app/screens/counter_control.dart';
import 'package:flutter/material.dart';

class RoomGuestSelectorSheet extends StatefulWidget {
  const RoomGuestSelectorSheet({super.key});
  @override
  State<RoomGuestSelectorSheet> createState() => _RoomGuestSelectorSheet();
}

class _RoomGuestSelectorSheet extends State<RoomGuestSelectorSheet> {
  int _rooms = 1;
  int _adultCount = 0;
  int _childCount = 0;

  @override
  Widget build(BuildContext content) {
    final height =
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
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
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
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            "Number of Rooms",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: CounterControl(
                              count: _rooms,
                              onChanged: (val) => setState(() => _rooms = val),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Number of Adults",
                              style: TextStyle(
                                fontSize: 16,
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
                              onChanged: (val) =>
                                  setState(() => _adultCount = val),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Number of Children",
                              style: TextStyle(
                                fontSize: 16,
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
                              onChanged: (val) =>
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
                    final total = _adultCount + _childCount;
                    Navigator.pop(context, {
                      'roomCnt': _rooms,
                      'guestsCnt': total,
                      'childCnt': _childCount,
                      'adultCnt': _adultCount,
                    });
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
                    children: [Text('Done', style: TextStyle(fontSize: 16))],
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
