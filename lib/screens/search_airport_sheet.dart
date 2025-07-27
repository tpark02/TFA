import 'package:chat_app/providers/airport_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchAirportSheet extends ConsumerStatefulWidget {
  const SearchAirportSheet(
      {super.key, required this.title, required this.isDeparture});
  final String title;
  final bool isDeparture;

  @override
  ConsumerState<SearchAirportSheet> createState() => _AirportSheetState();
}

class _AirportSheetState extends ConsumerState<SearchAirportSheet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.5;
    final query = ref.watch(searchQueryProvider);
    final airportData = ref.watch(airportDataProvider);

    final filteredAirports = airportData.maybeWhen(
      data: (airports) {
        // debugPrint('Query: "$query"');
        if (query.length < 2) {
          return [];
        }

        final matches = airports.where((a) {
          final inIATA = a.iataCode.toLowerCase().contains(query);
          final inName = a.airportName.toLowerCase().contains(query);
          final inCity = a.city.toLowerCase().contains(query);
          final inCountry = a.country.toLowerCase().contains(query);

          return inName || inCity || inCountry || inIATA;
        }).toList();
        return matches;
      },
      orElse: () => [],
    );

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: height,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Text(widget.title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) =>
                          ref.read(searchQueryProvider.notifier).state = value,
                      decoration: InputDecoration(
                        hintText: widget.isDeparture ? "From" : "To",
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.search,
                            color: Theme.of(context).colorScheme.primary),

                        // Add visible border
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 1),
                          borderRadius: BorderRadius.circular(0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2),
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (final airport in filteredAirports)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              const Icon(Icons.local_airport),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    // handle selection
                                    debugPrint("Selected: ${airport.iataCode}");
                                    Navigator.pop(context, airport.iataCode);
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    alignment: Alignment.centerLeft,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              airport.airportName,
                                              overflow: TextOverflow
                                                  .ellipsis, // 🔥 cut if too long
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                                overflow: TextOverflow
                                                    .ellipsis, // 🔥 cut if too long
                                                '${airport.city}, ${airport.country}'),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        airport.iataCode,
                                        overflow: TextOverflow
                                            .ellipsis, // 🔥 cut if too long
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color:
                                                Color.fromRGBO(48, 48, 48, 1)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
