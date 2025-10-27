import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'screens/welcome_android.dart';
import 'screens/welcome_ios.dart';

void main() {
  runApp(const YenkasaApp());
}

class YenkasaApp extends StatelessWidget {
  const YenkasaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Platform.isIOS
          ? const WelcomeScreenIOS()
          : const WelcomeScreenAndroid(),
    );
  }
}
