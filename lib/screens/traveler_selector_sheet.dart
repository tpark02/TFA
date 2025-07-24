import 'package:chat_app/screens/counter_control.dart';
import 'package:flutter/material.dart';

class TravelerSelectorSheet extends StatefulWidget {
  const TravelerSelectorSheet({super.key});

  @override
  State<StatefulWidget> createState() => _TravelerSelectorState();
}

class _TravelerSelectorState extends State<TravelerSelectorSheet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height =
        MediaQuery.of(context).size.height * 0.30; // 65% of screen height
    return SafeArea(
      child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                color: Colors.white,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              constraints: BoxConstraints(maxHeight: height),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Travelers",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: const Text("Adults > 18")),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: CounterControl(),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Children 2 - 11"),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: CounterControl(),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text('Complete')]),
                    ),
                  ]))),
    );
  }
}
