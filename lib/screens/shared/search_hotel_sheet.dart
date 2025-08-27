import 'package:TFA/models/hotel.dart';
import 'package:TFA/providers/hotel/hotel_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchHotelSheet extends ConsumerStatefulWidget {
  const SearchHotelSheet({super.key, required this.title});
  final String title;

  @override
  ConsumerState<SearchHotelSheet> createState() => _SearchHotelSheetState();
}

class _SearchHotelSheetState extends ConsumerState<SearchHotelSheet> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height * 0.7;
    final AsyncValue<Map<String, List<Hotel>>> filteredHotels = ref.watch(
      filteredHotelProvider,
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
                      onChanged: (String value) {
                        ref.read(searchHotelQueryProvider.notifier).state =
                            value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Hotel',
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
                child: filteredHotels.when(
                  data: (Map<String, List<Hotel>> grouped) {
                    if (grouped.isEmpty) {
                      return const Center(child: Text("No matching countries"));
                    }

                    return ListView(
                      children: grouped.entries.map((
                        MapEntry<String, List<Hotel>> entry,
                      ) {
                        final String city = entry.key;
                        final List<Hotel> hotels = entry.value;

                        return Column(
                          children: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, <String, String>{
                                  'city': city,
                                });
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        city,
                                        style: TextStyle(
                                          fontSize: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium?.fontSize,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        hotels[0].country,
                                        style: TextStyle(
                                          fontSize: Theme.of(
                                            context,
                                          ).textTheme.bodySmall?.fontSize,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${hotels.length} hotels',
                                    style: TextStyle(
                                      fontSize: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.fontSize,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (Object err, _) => Center(child: Text('Error: $err')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
