import 'package:TFA/providers/flight/flight_search_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CalendarSheet extends ConsumerStatefulWidget {
  const CalendarSheet({
    super.key,
    required this.firstTitle,
    required this.secondTitle,
    required this.isOnlyTab,
    required this.isRange,
    required this.startDays,
    required this.endDays,
  });

  final String firstTitle;
  final String secondTitle;
  final bool isOnlyTab;
  final bool isRange;
  final int startDays;
  final int endDays;

  @override
  ConsumerState<CalendarSheet> createState() => _CalendarSheetState();
}

class _CalendarSheetState extends ConsumerState<CalendarSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();

    startDate = DateTime.now().add(Duration(days: widget.startDays));
    endDate = null;

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onSelectionRange(DateRangePickerSelectionChangedArgs args) {
    final FlightSearchController controller = ref.read(
      flightSearchProvider.notifier,
    );

    debugPrint('_onSelectionRange');

    if (args.value is PickerDateRange) {
      final PickerDateRange range = args.value as PickerDateRange;

      if (range.startDate != null && range.endDate != null) {
        startDate = range.startDate;
        endDate = range.endDate;
        controller.setClearReturnDate(false);
      } else {
        debugPrint('selected range: start or end is null');
      }
    } else {
      debugPrint('selected range: null or not a valid range');
    }
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    debugPrint('_onSelectionChanged');
    final FlightSearchController controller = ref.read(
      flightSearchProvider.notifier,
    );
    if (args.value is DateTime) {
      startDate = args.value;
      controller.setClearReturnDate(true);
    } else {
      debugPrint('Selection is not a DateTime: ${args.value.runtimeType}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height =
        MediaQuery.of(context).size.height * 0.7; // 95% of screen height

    final bool isRange = widget.isRange;

    final PickerDateRange initialRange = PickerDateRange(
      DateTime.now().add(Duration(days: widget.startDays)),
      DateTime.now().add(Duration(days: widget.endDays)),
    );

    final DateTime initialDate = DateTime.now().add(Duration(days: widget.startDays));

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          constraints: BoxConstraints(maxHeight: height),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            // color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Calendar",
                style: TextStyle(
                  fontSize: Theme.of(
                    context,
                  ).textTheme.headlineMedium?.fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              !widget.isOnlyTab
                  ? TabBar(
                      dividerColor: Colors.transparent,
                      controller: _tabController,
                      tabs: <Widget>[
                        Tab(text: widget.firstTitle),
                        Tab(text: widget.secondTitle),
                      ],
                    )
                  : const SizedBox.shrink(),
              const SizedBox(height: 8),
              Expanded(
                child: widget.isOnlyTab
                    ? SfDateRangePicker(
                        initialSelectedRange: isRange ? initialRange : null,
                        initialSelectedDate: isRange ? null : initialDate,
                        minDate: DateTime.now(),
                        onSelectionChanged: widget.isRange
                            ? _onSelectionRange
                            : _onSelectionChanged,
                        selectionMode: widget.isRange
                            ? DateRangePickerSelectionMode.range
                            : DateRangePickerSelectionMode.single,
                        backgroundColor: Colors.transparent,
                        headerStyle: DateRangePickerHeaderStyle(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          textStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: Theme.of(
                              context,
                            ).textTheme.headlineMedium?.fontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : TabBarView(
                        controller: _tabController,
                        children: <Widget>[
                          SfDateRangePicker(
                            initialSelectedDate: DateTime.now().add(
                              const Duration(days: 10),
                            ),
                            minDate: DateTime.now(),
                            onSelectionChanged: _onSelectionChanged,
                            selectionMode: DateRangePickerSelectionMode.single,
                            backgroundColor: Colors.transparent,
                            headerStyle: DateRangePickerHeaderStyle(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              textStyle: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: Theme.of(
                                  context,
                                ).textTheme.headlineMedium?.fontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SfDateRangePicker(
                            initialSelectedRange: initialRange,
                            minDate: DateTime.now(),
                            onSelectionChanged: _onSelectionRange,
                            selectionMode: DateRangePickerSelectionMode.range,
                            backgroundColor: Colors.transparent,
                            headerStyle: DateRangePickerHeaderStyle(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              textStyle: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
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
              const SizedBox(height: 12),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Theme.of(
                          context,
                        ).colorScheme.onPrimary,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.zero, // sharp corners, no rounding
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context, <String, DateTime?>{
                          'startDate': startDate,
                          'endDate': endDate,
                        });
                      },
                      child: const Text("Confirm"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
