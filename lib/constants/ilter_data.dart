// Global, reusable filter data. Import anywhere.

import 'package:collection/collection.dart';

// --- Airlines ---
const List<String> kAirlines = [
  "Aero Lloyd (YP)",
  "Air Busan",
  "Air Canada",
  "Air China",
  "Air France",
  "Alaska Airlines",
  "American Airlines",
  // extras so Show More is meaningful
  "ANA", "Asiana Airlines", "British Airways", "Cathay Pacific",
  "Delta", "Emirates", "Etihad", "Qatar Airways",
];

// Default selections as const. Copy when using in state.
const Set<String> kDefaultSelectedAirlines = {
  "Aero Lloyd (YP)",
  "Air Busan",
  "Air Canada",
  "Air China",
  "Air France",
  "Alaska Airlines",
  "American Airlines",
};

// --- Layover cities ---
const List<String> kLayoverCities = [
  "AUH - Abu Dhabi",
  "AMS - Amsterdam",
  "IST - Arnavutköy, Istanbul",
  "ATL - Atlanta",
  "PEK - Beijing",
  "BOS - Boston",
  "ORD - Chicago",
  "ICN - Incheon",
  "DXB - Dubai",
];

const Set<String> kDefaultSelectedLayovers = {
  "AUH - Abu Dhabi",
  "AMS - Amsterdam",
  "IST - Arnavutköy, Istanbul",
  "ATL - Atlanta",
  "PEK - Beijing",
  "BOS - Boston",
  "ORD - Chicago",
};

// Helper to get a safe mutable copy anywhere.
Set<String> cloneSet(Iterable<String> src) => {...src};
