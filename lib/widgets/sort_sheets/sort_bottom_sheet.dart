import 'package:TFA/providers/sort_tab_provider.dart';
import 'package:flutter/material.dart';

Future<void> showSortBottomSheet({
  required BuildContext context,
  required String title,
  required SortTab sortType,
  required String selectedSort,
  required ValueChanged<String> onSortSelected,
}) {
  return showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
    ),
    builder: (BuildContext context) {
      List<String> options;

      switch (sortType) {
        case SortTab.hotelSort:
          options = <String>['Price', 'Discount', 'Ranking'];
          break;
        case SortTab.sort:
          options = <String>['Duration', 'Cost', 'Value'];
          break;
        case SortTab.stops:
          options = <String>['Nonstop', 'Up to 1 stop', 'Up to 2 stops'];
          break;
        case SortTab.travelHacks:
          // TODO: Handle this case.
          throw UnimplementedError();
        case SortTab.takeoff:
          // TODO: Handle this case.
          throw UnimplementedError();
        case SortTab.landing:
          // TODO: Handle this case.
          throw UnimplementedError();
        case SortTab.flightDuration:
          // TODO: Handle this case.
          throw UnimplementedError();
        case SortTab.layoverDuration:
          // TODO: Handle this case.
          throw UnimplementedError();
        case SortTab.airlines:
          // TODO: Handle this case.
          throw UnimplementedError();
        case SortTab.layoverCities:
          // TODO: Handle this case.
          throw UnimplementedError();
      }
      return StatefulBuilder(
        builder: (BuildContext context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 0, 0),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: Theme.of(
                      context,
                    ).textTheme.headlineMedium?.fontSize,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),

              // const SizedBox(height: 8),
              ...options.map(
                (String option) => RadioListTile<String>(
                  value: option,
                  groupValue: selectedSort,
                  title: Text(option),
                  contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),

                  onChanged: (String? value) {
                    if (value != null) {
                      setState(() => selectedSort = value);
                      onSortSelected(value);
                    }
                  },
                ),
              ),
              // const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10,
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        2,
                      ), // ← bigger = rounder
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Done'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          );
        },
      );
    },
  );
}
