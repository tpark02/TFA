import 'package:chat_app/constants/font_size.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/providers/recent_search.dart';

class RecentSearchItem extends StatelessWidget {
  const RecentSearchItem({super.key, required this.search});

  final RecentSearch search;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO: handle tap
      },
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10.0),
              Text(
                search.destination,
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontSize: kFontSize14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Row(
                children: [
                  Text(
                    search.tripDateRange,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[500],
                    ),
                  ),
                  ...search.icons,
                ],
              ),
              const SizedBox(height: 10.0),
            ],
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Column(
                children: [
                  Text(
                    search.destinationCode,
                    style: const TextStyle(
                      fontSize: kFontSize14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
