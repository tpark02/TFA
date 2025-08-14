import 'package:TFA/models/airport.dart';
import 'package:TFA/providers/airport/airport_selection.dart';
import 'package:TFA/providers/airport/airport_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchAirportSheet extends ConsumerStatefulWidget {
  const SearchAirportSheet({
    super.key,
    required this.title,
    required this.isDeparture,
  });

  final String title;
  final bool isDeparture;

  @override
  ConsumerState<SearchAirportSheet> createState() => _AirportSheetState();
}

class _AirportSheetState extends ConsumerState<SearchAirportSheet> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height * 0.7;
    final String query = ref.watch(airportSearchQueryProvider);
    final AsyncValue<List<Airport>> airportData = ref.watch(airportDataProvider);

    final List filteredAirports = airportData.maybeWhen(
      data: (List<Airport> airports) {
        if (query.length < 2) return <dynamic>[];

        return airports.where((Airport a) {
          final String q = query.toLowerCase();
          return a.iataCode.toLowerCase().contains(q) ||
              a.airportName.toLowerCase().contains(q) ||
              a.city.toLowerCase().contains(q) ||
              a.country.toLowerCase().contains(q);
        }).toList();
      },
      orElse: () => <dynamic>[],
    );

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
            color: Colors.white,
          ),
          child: Column(
            children: <Widget>[
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: Theme.of(
                    context,
                  ).textTheme.headlineMedium?.fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (String value) =>
                          ref.read(airportSearchQueryProvider.notifier).state =
                              value,
                      decoration: InputDecoration(
                        hintText: widget.isDeparture ? "From" : "To",
                        hintStyle: const TextStyle(color: Colors.grey),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredAirports.length,
                  itemBuilder: (BuildContext context, int index) {
                    final airport = filteredAirports[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: <Widget>[
                          const Icon(Icons.local_airport),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                debugPrint("Selected: ${airport.iataCode}");
                                Navigator.pop(
                                  context,
                                  AirportSelection(
                                    name: airport.airportName,
                                    code: airport.iataCode,
                                    city: airport.city,
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                alignment: Alignment.centerLeft,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          airport.airportName,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: Theme.of(context)
                                                .textTheme
                                                .headlineMedium
                                                ?.fontSize,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '${airport.city}, ${airport.country}',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    airport.iataCode,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.fontSize,
                                      color: const Color.fromRGBO(48, 48, 48, 1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
