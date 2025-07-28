import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<TimeOfDay?> showAdaptiveTimePicker(
  BuildContext context,
  TimeOfDay initialTime,
) async {
  if (Platform.isIOS) {
    // Cupertino-style (iOS)
    TimeOfDay? pickedTime;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext builder) {
        DateTime initialDateTime = DateTime(
          0,
          0,
          0,
          initialTime.hour,
          initialTime.minute,
        );
        return SizedBox(
          height: 250,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CupertinoButton(
                    child: const Text('Done'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: initialDateTime,
                  use24hFormat: false,
                  onDateTimeChanged: (DateTime newDateTime) {
                    pickedTime = TimeOfDay(
                      hour: newDateTime.hour,
                      minute: newDateTime.minute,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    return pickedTime;
  } else {
    // Material-style (Android)
    return await showTimePicker(context: context, initialTime: initialTime);
  }
}
