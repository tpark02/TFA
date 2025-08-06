import 'package:TFA/providers/flight/flight_search_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CalendarSheet extends ConsumerStatefulWidget {
  const CalendarSheet({
    super.key,
    required this.firstTitle,
    required this.secondTitle,
    required this.isOnlyTab,
    required this.isRange,
  });

  final String firstTitle;
  final String secondTitle;
  final bool isOnlyTab;
  final bool isRange;
  @override
  ConsumerState<CalendarSheet> createState() => _CalendarSheetState();
}

class _CalendarSheetState extends ConsumerState<CalendarSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? displayDate;
  PickerDateRange? selectedRange;
  DateTime? selectedDate;
  late FlightSearchController controller;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    controller = ref.read(flightSearchProvider.notifier); // ✅ Proper place
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onSelectionRange(DateRangePickerSelectionChangedArgs args) {
    debugPrint('_onSelectionRange');

    if (args.value is PickerDateRange) {
      final range = args.value as PickerDateRange;

      if (range.startDate != null && range.endDate != null) {
        final String start = DateFormat('yyyy-MM-dd').format(range.startDate!);
        final String end = DateFormat('yyyy-MM-dd').format(range.endDate!);

        selectedRange = range; // ✅ store it
        controller.setDepartDate(start);
        controller.setReturnDate(end);

        displayDate =
            '${DateFormat('MMM d').format(range.startDate!)} – ${DateFormat('MMM d').format(range.endDate!)}';
        debugPrint('selected range: $displayDate');
      } else {
        debugPrint('selected range: start or end is null');
      }
    } else {
      debugPrint('selected range: null or not a valid range');
    }
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    debugPrint('_onSelectionChanged');
    selectedDate = args.value;

    if (args.value is DateTime && selectedDate != null) {
      final String start = DateFormat('yyyy-MM-dd').format(selectedDate!);
      controller.setDepartDate(start);
      controller.setReturnDate(null); // ✅ correct

      displayDate = DateFormat('MMMM d').format(selectedDate!);
      debugPrint('Selected: $displayDate');
    } else {
      debugPrint('Selection is not a DateTime: ${args.value.runtimeType}');
      selectedDate = null;
      displayDate = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(" is only : ${widget.isOnlyTab}");
    final height =
        MediaQuery.of(context).size.height * 0.7; // 95% of screen height

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
            children: [
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
                      tabs: [
                        Tab(text: widget.firstTitle),
                        Tab(text: widget.secondTitle),
                      ],
                    )
                  : const SizedBox.shrink(),
              const SizedBox(height: 8),
              Expanded(
                child: widget.isOnlyTab
                    ? SfDateRangePicker(
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
                        children: [
                          SfDateRangePicker(
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
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Theme.of(
                          context,
                        ).colorScheme.onPrimary,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.zero, // sharp corners, no rounding
                        ),
                      ),
                      onPressed: () {
                        if (displayDate != null) {
                          Navigator.pop(context, {
                            'displayDate': displayDate,
                            'selectedDate': selectedDate,
                            'selectedRange': selectedRange,
                          }); // 🔥 returns it to caller
                        } else {
                          // optional: show a message or prevent closing
                          debugPrint('No date selected yet.');
                        }
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
