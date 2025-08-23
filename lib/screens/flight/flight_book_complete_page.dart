// import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class FlightBookCompletePage extends StatefulWidget {
  const FlightBookCompletePage({super.key});

  @override
  State<FlightBookCompletePage> createState() => _FlightBookCompletePageState();
}

class _FlightBookCompletePageState extends State<FlightBookCompletePage> {
  // late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    // _confettiController = ConfettiController(
    //   duration: const Duration(seconds: 3),
    // );

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Future.delayed(const Duration(milliseconds: 200), () {
    //     if (mounted) {
    //       _confettiController.stop();
    //       _confettiController.play();
    //     }
    //   });
    // });
  }

  @override
  void dispose() {
    // _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF8),
      body: Stack(
        children: [
          // ✅ Centered success content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('✅', style: TextStyle(fontSize: 96)),
                const SizedBox(height: 12),
                Text(
                  'Booking Confirmed',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Your flight is all set',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Back'),
                ),
              ],
            ),
          ),

          // 🎉 Confetti emitter ABOVE the checkmark, horizontally centered
          // Align(
          //   alignment: const Alignment(
          //     0,
          //     -0.3,
          //   ), // x=0 (center), y=-0.3 (above center)
          //   child: ConfettiWidget(
          //     confettiController: _confettiController,
          //     blastDirectionality: BlastDirectionality.explosive,
          //     minBlastForce: 5,
          //     maxBlastForce: 12,
          //     emissionFrequency: 0.05,
          //     numberOfParticles: 40,
          //     gravity: 0.3,
          //   ),
          // ),
        ],
      ),
    );
  }
}
