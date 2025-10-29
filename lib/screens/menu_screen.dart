import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          "Main Menu",
          style: TextStyle(
            color: Color(0xFF222222),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFFFFBF2),
        elevation: 1.5,
        iconTheme: const IconThemeData(color: Color(0xFF222222)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🧍 Profile Preview Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 32,
                    backgroundImage: AssetImage("assets/images/default_avatar.png"),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Kofi Bright",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFF222222),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Yenkasa Coins: 1,240 YKC",
                          style: TextStyle(
                            color: Color(0xFF009688),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 🧭 Menu Buttons
            _menuButton(context, "Contacts", Icons.people_alt_outlined, onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Opening Contacts...")),
              );
            }),

            _menuButton(context, "Chat Rooms", Icons.chat_bubble_outline, onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Opening Chat Rooms...")),
              );
            }),

            _menuButton(context, "Account Info", Icons.account_circle_outlined, onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Opening Account Info...")),
              );
            }),

            _menuButton(context, "Edit Profile", Icons.edit_outlined,
                bgColor: const Color(0xFFD5D5D5), onTap: () {}),

            _menuButton(context, "Verify Account", Icons.verified_outlined, onTap: () {}),

            _menuButton(context, "Settings", Icons.settings_outlined, onTap: () {}),

            _menuButton(context, "Logout", Icons.logout,
                bgColor: const Color(0xFFCCCCCC),
                textColor: const Color(0xFF222222),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Logged out.")),
                  );
                }),
          ],
        ),
      ),
    );
  }

  // 🔘 Modern button builder
  Widget _menuButton(
      BuildContext context,
      String text,
      IconData icon, {
        Color bgColor = const Color(0xFFE0E0E0),
        Color textColor = const Color(0xFF222222),
        required VoidCallback onTap,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        icon: Icon(icon, color: const Color(0xFF128C7E)),
        label: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
