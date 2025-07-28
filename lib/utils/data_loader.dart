import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

Future<List<List<dynamic>>> loadAirportData() async {
  final rawData = await rootBundle.loadString('assets/data/airports.csv');
  final List<List<dynamic>> csvTable = const CsvToListConverter(
    eol: '\n',
  ).convert(rawData);
  return csvTable;
}

Future<List<List<dynamic>>> loadHotelData() async {
  final rawData = await rootBundle.loadString('assets/data/hotels.csv');
  final List<List<dynamic>> csvTable = const CsvToListConverter(
    eol: '\n',
  ).convert(rawData);
  return csvTable;
}
