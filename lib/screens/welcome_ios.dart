import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WelcomeScreenIOS extends StatefulWidget {
  const WelcomeScreenIOS({super.key});

  @override
  State<WelcomeScreenIOS> createState() => _WelcomeScreenIOSState();
}

class _WelcomeScreenIOSState extends State<WelcomeScreenIOS> {
  final List<String> communityNames = [
    "Ayimensah", "Danfa", "Kweiman", "Oyarifa", "Abokobi", "Frafraha",
    "New Legon", "Adenta", "Adenta NewSite", "Amrahia", "Oyibi",
    "Legon Campus", "East Legon", "Menpeasem", "Ogbojo", "Adjinganor",
    "Botwe", "Madina Zongo Juntion", "Atomic Juntion", "UPSA", "Bawaleshie",
    "American House", "School Junction", "Mataheko", "Nana Krom",
    "Hatso", "Taifa", "Odokor", "Aboso Okai"
  ];

  final Random random = Random();
  final List<Offset> positions = [];
  Timer? timer;
  final List<double> opacities = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializePositions();
      _startFloatingAnimation();
    });
  }

  void _initializePositions() {
    final size = MediaQuery.of(context).size;
    for (var i = 0; i < communityNames.length; i++) {
      positions.add(Offset(
        random.nextDouble() * size.width,
        random.nextDouble() * size.height,
      ));
      opacities.add(random.nextDouble()); // random fade strength
    }
  }

  void _startFloatingAnimation() {
    timer = Timer.periodic(const Duration(seconds: 3), (_) {
      setState(() {
        final size = MediaQuery.of(context).size;
        for (int i = 0; i < positions.length; i++) {
          positions[i] = Offset(
            random.nextDouble() * size.width,
            random.nextDouble() * size.height,
          );
          opacities[i] = random.nextDouble();
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemPurple,
      child: Stack(
        children: [
          // Floating community names
          ...List.generate(communityNames.length, (i) {
            final fontSize = 14.0 + random.nextDouble() * 6;
            return AnimatedPositioned(
              duration: const Duration(seconds: 3),
              left: positions[i].dx,
              top: positions[i].dy,
              child: AnimatedOpacity(
                duration: const Duration(seconds: 3),
                opacity: opacities[i],
                child: Text(
                  communityNames[i],
                  style: TextStyle(
                    color: CupertinoColors.white.withOpacity(0.9),
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            );
          }),

          // Center Yenkasa logo + title
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  CupertinoIcons.chat_bubble_2_fill,
                  color: CupertinoColors.white,
                  size: 80,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Welcome to Yenkasa",
                  style: TextStyle(
                    color: CupertinoColors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 24),
                CupertinoButton.filled(
                  borderRadius: BorderRadius.circular(25),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  onPressed: () {
                    // TODO: navigate to login/home
                  },
                  child: const Text(
                    "Get Started",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
