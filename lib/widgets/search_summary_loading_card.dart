import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SearchSummaryLoadingCard extends StatelessWidget {
  const SearchSummaryLoadingCard({
    super.key,
    required this.routeText,
    required this.dateText,
  });

  final String routeText;
  final String dateText;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SpinKitThreeBounce(color: Colors.lightBlue, size: 40),
          const SizedBox(height: 10),
          Text(
            routeText,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            dateText,
            style: const TextStyle(fontSize: 20, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
