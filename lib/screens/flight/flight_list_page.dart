import 'package:flutter/material.dart';

class FlightListPage extends StatelessWidget {
  const FlightListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final flights = List.generate(10, (index) => const FlightInfo());

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90), // required!
        child: Container(
          color: Theme.of(context).colorScheme.primary,
          child: SizedBox(height: 30),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).colorScheme.primary,
            padding: const EdgeInsets.fromLTRB(
              16,
              24,
              16,
              16,
            ), // status bar spacing

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.arrow_back, color: Colors.white),
                FlightSearchSummaryCard(
                  from: 'ICN',
                  to: 'New York',
                  dateRange: 'Aug 18 - Aug 20',
                  passengerCount: 1,
                  cabinClass: 'Economy',
                ),
                Icon(Icons.favorite_border, color: Colors.white),
                Icon(Icons.share, color: Colors.white),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey),
          Container(
            color: Colors.grey[100],
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.all(10),
                        backgroundColor: Colors.white,
                        minimumSize: const Size(0, 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        side: BorderSide(color: Colors.grey[400]!, width: 1),
                      ),
                      onPressed: () {},
                      child: Icon(Icons.tune, size: 23),
                    ),
                  ),
                  FilterButton(label: "Sort: Cost"),
                  FilterButton(label: "Travel Hacks"),
                  FilterButton(label: "Stops"),
                  FilterButton(label: "Take Off"),
                  FilterButton(label: "Take Off"),
                  FilterButton(label: "Take Off"),
                  FilterButton(label: "Take Off"),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Choose Departing flight",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Total Cost",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                Container(
                  color: Colors.amber[50],
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            children: [
                              const TextSpan(
                                text: 'Automatic protection on every flight. ',
                              ),
                              TextSpan(
                                text: 'The Skiplagged Guarantee.',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          padding: const EdgeInsets.all(10.0),
                        ),
                        child: const Text("Learn More"),
                      ),
                    ],
                  ),
                ),
                ...List.generate(flights.length, (index) => flights[index]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FlightInfo extends StatelessWidget {
  const FlightInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "5:25p",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text("ICN", style: TextStyle(color: Colors.grey[700])),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(child: Divider(color: Colors.grey)),
                          Icon(
                            Icons.circle_outlined,
                            size: 12,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 90,
                            child: Divider(color: Colors.grey),
                          ),
                          Icon(
                            Icons.circle_outlined,
                            size: 12,
                            color: Colors.grey,
                          ),
                          Expanded(child: Divider(color: Colors.grey)),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.transparent)),
                          Text(
                            "DFW",
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            width: 70,
                            child: Divider(color: Colors.transparent),
                          ),
                          Text(
                            "PIT",
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 14,
                            ),
                          ),
                          Expanded(child: Divider(color: Colors.transparent)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: '8:29a',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.top,
                              child: Transform.translate(
                                offset: const Offset(-8, -13),
                                child: Text(
                                  '+1',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.red[800],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Text("LGA", style: TextStyle(color: Colors.grey[700])),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                "28h4m | 2 stops | American",
                style: TextStyle(color: Colors.grey[700]),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: const Text(
                    "₩916,759",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String label;
  const FilterButton({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.all(10),
          backgroundColor: Colors.white,
          minimumSize: const Size(0, 32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          side: BorderSide(color: Colors.grey[400]!, width: 1),
        ),
        onPressed: () {},
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class FlightSearchSummaryCard extends StatelessWidget {
  final String from;
  final String to;
  final String dateRange;
  final int passengerCount;
  final String cabinClass;

  const FlightSearchSummaryCard({
    super.key,
    required this.from,
    required this.to,
    required this.dateRange,
    required this.passengerCount,
    required this.cabinClass,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      color: Theme.of(context).colorScheme.secondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                from,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.compare_arrows, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Text(
                to,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(dateRange, style: const TextStyle(color: Colors.white)),
              const SizedBox(width: 12),
              const Icon(Icons.person, color: Colors.white, size: 16),
              const SizedBox(width: 4),
              Text(
                passengerCount.toString(),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(width: 12),
              const Icon(
                Icons.airline_seat_recline_normal,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(cabinClass, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }
}
