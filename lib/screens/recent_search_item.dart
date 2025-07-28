import 'package:flutter/material.dart';

class RecentSearchItem extends StatelessWidget {
  const RecentSearchItem({
    super.key,
    required this.destination,
    required this.tripDateRange,
    required this.icons,
  });
  final String destination;
  final String tripDateRange;
  final List<Widget> icons;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // your code here
      },
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.0),
                Text(
                  destination,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                Row(
                  children: [
                    Text(
                      tripDateRange,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[500],
                      ),
                    ),
                    for (int i = 0; i < icons.length; i++) icons[i],
                  ],
                ),
                SizedBox(height: 10.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
