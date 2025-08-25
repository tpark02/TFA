import 'dart:io' show Platform;
import 'package:TFA/providers/airport/airport_selection.dart';
import 'package:TFA/screens/flight/flight_trip_details_page.dart';
import 'package:TFA/screens/shared/search_airport_sheet.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

Future<T?> showPlatformModalSheet<T>({
  required BuildContext context,
  required Widget Function(BuildContext) builder,
  bool expand = false,
  bool isScrollControlled = true,
  bool useRootNavigator = true,
}) {
  if (Platform.isIOS) {
    return CupertinoScaffold.showCupertinoModalBottomSheet<T>(
      context: context,
      builder: builder,
      expand: expand,
      useRootNavigator: useRootNavigator,
    );
  } else {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      useRootNavigator: useRootNavigator,
      builder: builder,
    );
  }
}

Future<void> showTripDetailsModal({
  required BuildContext context,
  required bool isReturnPage,
  required Map<String, dynamic> departData,
  required Map<String, dynamic>? returnData,
}) {
  final FlightTripDetailsPage page = FlightTripDetailsPage(
    isReturnPage: isReturnPage,
    departData: departData,
    returnData: returnData,
  );

  if (Platform.isIOS) {
    return CupertinoScaffold.showCupertinoModalBottomSheet(
      context: context,
      useRootNavigator: true,
      expand: false,
      builder: (_) => page,
    );
  } else {
    return showMaterialModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (_) => page,
    );
  }
}

Future<AirportSelection?> showAirportSelectionSheet({
  required BuildContext context,
  required String title,
  required bool isDeparture,
}) {
  final sheet = SearchAirportSheet(title: title, isDeparture: isDeparture);

  if (Platform.isIOS) {
    return CupertinoScaffold.showCupertinoModalBottomSheet<AirportSelection>(
      context: context,
      useRootNavigator: true,
      expand: false,
      builder: (_) => sheet,
    );
  } else {
    return showMaterialModalBottomSheet<AirportSelection>(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (_) => sheet,
    );
  }
}
