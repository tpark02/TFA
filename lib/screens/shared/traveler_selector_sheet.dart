import 'package:TFA/widgets/counter_control.dart';
import 'package:flutter/material.dart';

class TravelerSelectorSheet extends StatefulWidget {
  TravelerSelectorSheet({
    super.key,
    required this.adult,
    required this.children,
    required this.infantLap,
    required this.infantSeat,
    required this.cabinIdx,
  });
  int adult;
  int children;
  int infantLap;
  int infantSeat;
  int cabinIdx;
  @override
  State<StatefulWidget> createState() => _TravelerSelectorState();
}

class _TravelerSelectorState extends State<TravelerSelectorSheet> {
  int _selectedIndex = 0;
  // int _selectedClassIdx = 0;
  // int _adultCount = 1;
  // int _childCount = 0;
  // int _infantLapCount = 0;
  // int _infantSeatCount = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height =
        MediaQuery.of(context).size.height * 0.40; // 65% of screen height
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          constraints: BoxConstraints(maxHeight: height),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Keep this always at the top
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 0;
                        });
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        foregroundColor: _selectedIndex == 0
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey,
                      ),
                      child: Text(
                        "Travelers",
                        style: TextStyle(
                          fontSize: Theme.of(
                            context,
                          ).textTheme.headlineMedium?.fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 1;
                        });
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        foregroundColor: _selectedIndex == 1
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey,
                      ),
                      child: Text(
                        "Class",
                        style: TextStyle(
                          fontSize: Theme.of(
                            context,
                          ).textTheme.headlineMedium?.fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // All other widgets share vertical space
              Expanded(
                child: _selectedIndex == 0
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  "Adults",
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
                                    count: widget.adult,
                                    onChanged: (int val) =>
                                        setState(() => widget.adult = val),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Children",
                                  style: TextStyle(
                                    fontSize: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.fontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "2-11",
                                  style: TextStyle(
                                    fontSize: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.fontSize,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: CounterControl(
                                    count: widget.children,
                                    onChanged: (int val) =>
                                        setState(() => widget.children = val),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Infant (lap)",
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
                                    count: widget.infantLap,
                                    onChanged: (int val) =>
                                        setState(() => widget.infantLap = val),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Infant (seat)",
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
                                    count: widget.infantSeat,
                                    onChanged: (int val) =>
                                        setState(() => widget.infantSeat = val),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size.zero,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        widget.cabinIdx = 0;
                                      });
                                    },
                                    child: Text(
                                      "Economy",
                                      style: TextStyle(
                                        color: widget.cabinIdx == 0
                                            ? Theme.of(
                                                context,
                                              ).colorScheme.primary
                                            : Colors.grey,
                                        fontSize: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium?.fontSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              widget.cabinIdx == 0
                                  ? const Icon(Icons.check)
                                  : const SizedBox.shrink(),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size.zero,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        widget.cabinIdx = 1;
                                      });
                                    },
                                    child: Text(
                                      "Premium Economy",
                                      style: TextStyle(
                                        color: widget.cabinIdx == 1
                                            ? Theme.of(
                                                context,
                                              ).colorScheme.primary
                                            : Colors.grey,
                                        fontSize: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium?.fontSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              widget.cabinIdx == 1
                                  ? const Icon(Icons.check)
                                  : const SizedBox.shrink(),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size.zero,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        widget.cabinIdx = 2;
                                      });
                                    },
                                    child: Text(
                                      "Business",
                                      style: TextStyle(
                                        color: widget.cabinIdx == 2
                                            ? Theme.of(
                                                context,
                                              ).colorScheme.primary
                                            : Colors.grey,
                                        fontSize: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium?.fontSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              widget.cabinIdx == 2
                                  ? const Icon(Icons.check)
                                  : const SizedBox.shrink(),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size.zero,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        widget.cabinIdx = 3;
                                      });
                                    },
                                    child: Text(
                                      "First",
                                      style: TextStyle(
                                        color: widget.cabinIdx == 3
                                            ? Theme.of(
                                                context,
                                              ).colorScheme.primary
                                            : Colors.grey,
                                        fontSize: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium?.fontSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              widget.cabinIdx == 3
                                  ? const Icon(Icons.check)
                                  : const SizedBox.shrink(),
                            ],
                          ),
                        ],
                      ),
              ),
              ElevatedButton(
                onPressed: () {
                  final int total =
                      widget.adult +
                      widget.children +
                      widget.infantLap +
                      widget.infantSeat;

                  Navigator.pop(context, <String, int>{
                    'passengerCount': total,
                    'cabinIdx': widget.cabinIdx,
                    'adult': widget.adult,
                    'children': widget.children,
                    'infantLap': widget.infantLap,
                    'infantSeat': widget.infantSeat,
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
                  children: <Widget>[Text('Done')],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
