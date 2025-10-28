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
    // slower animation refresh rate (every 6 seconds instead of 3)
    timer = Timer.periodic(const Duration(seconds: 6), (_) {
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
    // Ghana-inspired mild yellow and black palette
    final Color backgroundColor = const Color(0xFF1A1A1A); // soft black
    final Color accentYellow = const Color(0xFFFFD54F); // warm, mild yellow

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          ...List.generate(communityNames.length, (i) {
            final textColor = accentYellow.withOpacity(0.8);
            final fontSize = 14.0 + random.nextDouble() * 6;

            return AnimatedPositioned(
              duration: const Duration(seconds: 6),
              curve: Curves.easeInOut,
              left: positions[i].dx,
              top: positions[i].dy,
              child: Text(
                communityNames[i],
                style: TextStyle(
                  color: textColor,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black.withOpacity(0.6),
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
              ),
            );
          }),
          // Centered logo/title
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chat_bubble_outline, color: accentYellow, size: 80),
                const SizedBox(height: 12),
                Text(
                  "Welcome to Yenkasa",
                  style: TextStyle(
                    color: accentYellow,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    shadows: [
                      Shadow(
                        blurRadius: 6,
                        color: Colors.black.withOpacity(0.8),
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },


                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentYellow,
                    foregroundColor: backgroundColor,
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
