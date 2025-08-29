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
    final cs = Theme.of(context).colorScheme;

    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SpinKitThreeBounce(color: Colors.lightBlue, size: 40),
            const SizedBox(height: 10),
            Text(
              routeText,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.headlineMedium?.fontSize,
                fontWeight: FontWeight.bold,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              dateText,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.headlineMedium?.fontSize,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
