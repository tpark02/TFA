import 'package:chat_app/screens/recent_search_item.dart';
import 'package:flutter/material.dart';

class RecentSearchPanel extends StatefulWidget {
  const RecentSearchPanel({super.key});
  @override
  State<RecentSearchPanel> createState() => _RecentSearchPanelState();
}

class _RecentSearchPanelState extends State<RecentSearchPanel> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              "Recent Search",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 10,
          itemBuilder: (context, index) => const RecentSearchItem(),
          separatorBuilder: (context, index) => Divider(
            color: Colors.grey,
            thickness: 0.5,
            height: 10,
          ),
        )
      ],
    );
  }
}
