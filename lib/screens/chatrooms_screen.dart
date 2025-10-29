import 'package:flutter/material.dart';

class ChatRoomsScreen extends StatefulWidget {
  const ChatRoomsScreen({Key? key}) : super(key: key);

  @override
  State<ChatRoomsScreen> createState() => _ChatRoomsScreenState();
}

class _ChatRoomsScreenState extends State<ChatRoomsScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final List<String> _chatRooms = []; // Placeholder list for demo

  void _createChatRoom() {
    final username = _usernameController.text.trim();
    if (username.isEmpty) return;

    setState(() {
      _chatRooms.add("Chat with $username");
      _usernameController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Chat room created for $username')),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF009688); // Yenkasa color signature

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Rooms', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your Chat Rooms",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),

            // --- Username input ---
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                hintText: "Enter username to chat",
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // --- Create Chat Room Button ---
            Center(
              child: ElevatedButton(
                onPressed: _createChatRoom,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text("Create Chat Room", style: TextStyle(fontSize: 15)),
              ),
            ),
            const SizedBox(height: 8),

            // --- Chat Room List ---
            Expanded(
              child: _chatRooms.isEmpty
                  ? const Center(
                child: Text(
                  "No chat rooms yet.",
                  style: TextStyle(color: Colors.grey),
                ),
              )
                  : ListView.builder(
                itemCount: _chatRooms.length,
                itemBuilder: (context, index) {
                  final room = _chatRooms[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: primaryColor.withOpacity(0.1),
                        child: const Icon(Icons.chat, color: primaryColor),
                      ),
                      title: Text(
                        room,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                      onTap: () {
                        // Navigate to actual chat screen later
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
