import 'package:TFA/widgets/filter_button.dart';
import 'package:TFA/widgets/search_summary_card.dart';
import 'package:TFA/widgets/search_summary_loading_card.dart';
import 'package:flutter/material.dart';

class FlightListPage extends StatefulWidget {
  const FlightListPage({super.key});

  @override
  State<FlightListPage> createState() => _FlightListPageState();
}

class _FlightListPageState extends State<FlightListPage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

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
              0,
              25,
              0,
              10,
            ), // status bar spacing
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                ),
                SearchSummaryCard(
                  from: 'ICN',
                  to: 'New York',
                  dateRange: 'Aug 18 - Aug 20',
                  passengerCount: 1,
                  cabinClass: 'Economy',
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {},
                  icon: Icon(Icons.favorite_border, color: Colors.white),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {},
                  icon: Icon(Icons.share, color: Colors.white),
                ),
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
                  FilterButton(label: "Landing"),
                  FilterButton(label: "Flight Duration"),
                  FilterButton(label: "Layover Duration"),
                  FilterButton(label: "Airlines"),
                  FilterButton(label: "Arrival Airport"),
                  FilterButton(label: "Layover Cities"),
                ],
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(
                    child: SearchSummaryLoadingCard(
                      routeText: 'ICN - New York',
                      dateText: 'Aug 16 - Aug 18',
                    ),
                  )
                : Column(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Colors.grey[400]!, // or any color you want
                              width: 1.0, // thickness of the top border
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Choose Departing flight",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                        children: [
                                          const TextSpan(
                                            text:
                                                'Automatic protection on every flight. ',
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
                                        borderRadius: BorderRadius.circular(
                                          4.0,
                                        ),
                                      ),
                                      padding: const EdgeInsets.all(10.0),
                                    ),
                                    child: const Text("Learn More"),
                                  ),
                                ],
                              ),
                            ),
                            ...List.generate(
                              flights.length,
                              (index) => flights[index],
                            ),
                          ],
                        ),
                      ),
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
