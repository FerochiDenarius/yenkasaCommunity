import 'dart:math';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Random random = Random();
  final List<Offset> stars = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateStars();
    });
  }

  void _generateStars() {
    final size = MediaQuery.of(context).size;
    // generate about 25 scattered black stars randomly
    for (int i = 0; i < 25; i++) {
      stars.add(Offset(
        random.nextDouble() * size.width,
        random.nextDouble() * size.height,
      ));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    const Color yellow = Color(0xFFFFD54F);
    const Color black = Color(0xFF1A1A1A);

    return Scaffold(
      backgroundColor: yellow,
      body: Stack(
        children: [
          // ⭐ scattered black stars background
          ...stars.map((offset) {
            return Positioned(
              left: offset.dx,
              top: offset.dy,
              child: const Icon(
                Icons.star,
                color: black,
                size: 14,
              ),
            );
          }).toList(),

          // Main content
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
            child: Column(
              children: [
                // 🖼️ Illustration placeholder
                const Icon(Icons.chat_bubble_outline,
                    color: black, size: 100),
                const SizedBox(height: 30),

                // White card
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Welcome Back 👋",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Sign in to continue chatting",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Username or Email field
                      _buildInputField(
                        label: "Username or Email",
                        icon: Icons.person_outline,
                      ),

                      // Password field
                      _buildPasswordField(),

                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            // TODO: Forgot password logic
                          },
                          child: const Text(
                            "Forgot password?",
                            style: TextStyle(
                              color: black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Sign In button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: handle sign-in logic
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: black,
                            foregroundColor: yellow,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 4,
                          ),
                          child: const Text(
                            "Sign In",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Google sign-in button
                      OutlinedButton.icon(
                        onPressed: () {
                          // TODO: handle Google Sign-In
                        },
                        icon: const Icon(Icons.g_mobiledata, color: black),
                        label: const Text(
                          "Continue with Google",
                          style: TextStyle(
                            fontSize: 16,
                            color: black,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: black, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Register link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don’t have an account?",
                            style: TextStyle(color: Colors.black54),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            child: const Text(
                              " Sign Up",
                              style: TextStyle(
                                color: black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: label,
          prefixIcon: Icon(icon, color: Colors.black54),
          filled: true,
          fillColor: const Color(0xFFF9F9F9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    bool obscure = true;
    return StatefulBuilder(
      builder: (context, setState) {
        return TextField(
          obscureText: obscure,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: "Password",
            prefixIcon: const Icon(Icons.lock_outline, color: Colors.black54),
            suffixIcon: IconButton(
              icon: Icon(
                obscure ? Icons.visibility : Icons.visibility_off,
                color: Colors.black54,
              ),
              onPressed: () => setState(() => obscure = !obscure),
            ),
            filled: true,
            fillColor: const Color(0xFFF9F9F9),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        );
      },
    );
  }
}
