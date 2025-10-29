import 'package:flutter/material.dart';

class MainActivity extends StatefulWidget {
  const MainActivity({super.key});

  @override
  State<MainActivity> createState() => _MainActivityState();
}

class _MainActivityState extends State<MainActivity> {
  final List<String> posts = [
    "Welcome to Yenkasa Community!",
    "Today’s trending topic: Building Flutter UIs 🎨",
    "Earn Yenkasa Coins for active engagement 💰",
    "Share your thoughts and connect 🌍",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF5),
      appBar: AppBar(
        title: const Text(
          "Yenkasa Community",
          style: TextStyle(
            color: Color(0xFF222222),
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFFFFFFFB),
        elevation: 2,
        iconTheme: const IconThemeData(color: Color(0xFF222222)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return Card(
            color: Colors.white,
            elevation: 1.5,
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Text(
                post,
                style: const TextStyle(
                  color: Color(0xFF222222),
                  fontSize: 16,
                ),
              ),
              subtitle: const Text(
                "Tap to comment or react 💬",
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Opening post...")),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFFFFF2),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Create new post coming soon...")),
          );
        },
        child: const Icon(Icons.add, color: Color(0xFF444444)),
      ),
    );
  }
}
