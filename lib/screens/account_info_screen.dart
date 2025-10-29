import 'package:flutter/material.dart';

class AccountInfoScreen extends StatefulWidget {
  const AccountInfoScreen({Key? key}) : super(key: key);

  @override
  State<AccountInfoScreen> createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  bool isEditing = false;
  int posts = 0;
  int followers = 0;
  int following = 0;

  String username = "Username";
  String email = "user@example.com";
  String phone = "+233 000 000 000";
  String location = "Accra, Ghana";
  String community = "None";
  String dateJoined = "01 Jan 2025";
  int coins = 0;
  bool verified = false;

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF009688); // your Yenkasa color signature

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Profile Header ---
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: const CircleAvatar(
                      radius: 45,
                      backgroundImage: AssetImage('assets/images/default_avatar.png'),
                      backgroundColor: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStat("Posts", posts),
                        _buildStat("Followers", followers),
                        _buildStat("Following", following),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // --- Username + Verified ---
              Row(
                children: [
                  Text(
                    username,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 6),
                  if (verified)
                    const Icon(Icons.verified, color: Colors.blue, size: 20),
                ],
              ),
              const SizedBox(height: 4),
              Text(location, style: const TextStyle(fontSize: 14, color: Colors.grey)),

              const SizedBox(height: 12),
              Row(
                children: [
                  const Text(
                    "Coins:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "$coins YKC",
                    style: const TextStyle(fontSize: 14, color: primaryColor),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              Text("Community: $community", style: const TextStyle(fontSize: 14, color: Colors.black87)),
              const SizedBox(height: 4),
              Text("Date Joined: $dateJoined", style: const TextStyle(fontSize: 14, color: Colors.black87)),

              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    setState(() => isEditing = !isEditing);
                  },
                  child: Text(isEditing ? "Save Profile" : "Edit Profile"),
                ),
              ),

              const Divider(height: 32, thickness: 1, color: Color(0xFFE0E0E0)),

              // --- Contact Info ---
              _buildInfoRow("Email:", email),
              _buildInfoRow("Phone:", phone),

              const Divider(height: 32, thickness: 1, color: Color(0xFFE0E0E0)),

              const Text(
                "Posts",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 8),
              // --- User Posts Placeholder ---
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: const Text(
                  "No posts yet.",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String label, int value) {
    return Column(
      children: [
        Text(
          "$value",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
