import 'package:chat_app/screens/recent_search_item.dart';
import 'package:flutter/material.dart';

class RecentSearchPanel extends StatefulWidget {
  const RecentSearchPanel({
    super.key,
    required this.destination,
    required this.tripDateRange,
    required this.icons,
  });

  final String destination;
  final String tripDateRange;
  final List<Widget> icons;

  @override
  State<RecentSearchPanel> createState() => _RecentSearchPanelState();
}

class _RecentSearchPanelState extends State<RecentSearchPanel> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Recent searches",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 10,
          itemBuilder: (context, index) => RecentSearchItem(
            destination: widget.destination,
            tripDateRange: widget.tripDateRange,
            icons: widget.icons,
          ),
          separatorBuilder: (context, index) =>
              Divider(color: Colors.grey, thickness: 0.5, height: 10),
        ),
      ],
    );
  }
}
