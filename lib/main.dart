import 'package:flutter/material.dart';
import 'screens/welcome_android.dart';
import 'screens/register_screen.dart';
import 'screens/login_screen.dart';


void main() {
  runApp(const YenkasaApp());
}

class YenkasaApp extends StatelessWidget {
  const YenkasaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Yenkasa Community',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF1A1A1A), // black
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFD54F), // yellow
          brightness: Brightness.dark,
        ),
      ),
      // ✅ define routes
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreenAndroid(),
        '/register': (context) => const RegisterScreen(),
        '/login': (context) => const LoginScreen(),

      },
    );
  }
}
