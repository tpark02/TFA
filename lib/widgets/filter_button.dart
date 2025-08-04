import 'package:flutter/material.dart';

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
