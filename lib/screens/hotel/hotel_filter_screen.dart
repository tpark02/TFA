// lib/screens/hotel/hotel_filter_screen.dart
import 'package:flutter/material.dart';
import 'package:TFA/screens/hotel/hotel_filter_page.dart';

class HotelFilterScreen extends StatefulWidget {
  const HotelFilterScreen({super.key, this.initial});
  final HotelFilterResult? initial;

  @override
  State<HotelFilterScreen> createState() => _HotelFilterScreenState();
}

class _HotelFilterScreenState extends State<HotelFilterScreen> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController(); // 🟢 CREATE ONCE
  }

  @override
  void dispose() {
    _controller.dispose(); // 🟢 FIX: avoid leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: HotelFilterPage(
          scrollController: _controller,
          initial: widget.initial, // optional prefill
        ),
      ),
    );
  }
}
