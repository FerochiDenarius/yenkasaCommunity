import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class WelcomeScreenAndroid extends StatefulWidget {
  const WelcomeScreenAndroid({super.key});

  @override
  State<WelcomeScreenAndroid> createState() => _WelcomeScreenAndroidState();
}

class _WelcomeScreenAndroidState extends State<WelcomeScreenAndroid> {
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
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade900,
      body: Stack(
        children: [
          ...List.generate(communityNames.length, (i) {
            final textColor = Colors.white.withOpacity(0.8);
            final fontSize = 14.0 + random.nextDouble() * 6;

            return AnimatedPositioned(
              duration: const Duration(seconds: 3),
              left: positions[i].dx,
              top: positions[i].dy,
              child: Text(
                communityNames[i],
                style: TextStyle(
                  color: textColor,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chat_bubble_outline, color: Colors.white, size: 80),
                const SizedBox(height: 12),
                const Text(
                  "Welcome to Yenkasa",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // TODO: navigate to login/home
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text("Get Started"),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
