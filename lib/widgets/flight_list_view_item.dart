import 'package:flutter/material.dart';

class FlightListViewItem extends StatelessWidget {
  const FlightListViewItem({
    super.key,
    required this.onClick,
    required this.index,
  });
  final void Function() onClick;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // Important!
      child: InkWell(
        onTap: () => onClick(),
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
          // margin: const EdgeInsets.symmetric(vertical: 8),
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
                        "${index} 5:25p",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
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
                              Expanded(
                                child: Divider(color: Colors.transparent),
                              ),
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
                              Expanded(
                                child: Divider(color: Colors.transparent),
                              ),
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
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
