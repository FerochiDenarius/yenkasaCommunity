import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ChatScreen extends StatefulWidget {
  final String receiverName;
  final String receiverImageUrl;
  final bool isOnline;

  const ChatScreen({
    Key? key,
    required this.receiverName,
    required this.receiverImageUrl,
    this.isOnline = false,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<String> _messages = [];
  bool _showAttachMenu = false;
  File? _backgroundImage;
  Color? _backgroundColor;

  // --- Wallpaper chooser ---
  Future<void> _chooseBackground() async {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo, color: Color(0xFF128C7E)),
                title: const Text("Choose Picture"),
                onTap: () async {
                  Navigator.pop(ctx);
                  final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
                  if (picked != null) {
                    setState(() => _backgroundImage = File(picked.path));
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.palette, color: Color(0xFF128C7E)),
                title: const Text("Choose Color"),
                onTap: () {
                  Navigator.pop(ctx);
                  _openColorPicker();
                },
              ),
              if (_backgroundImage != null || _backgroundColor != null)
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  title: const Text("Reset to default"),
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() {
                      _backgroundImage = null;
                      _backgroundColor = null;
                    });
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void _openColorPicker() {
    Color tempColor = _backgroundColor ?? Colors.white;
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Select Background Color"),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: tempColor,
              onColorChanged: (c) => tempColor = c,
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(ctx),
            ),
            TextButton(
              child: const Text("Select"),
              onPressed: () {
                Navigator.pop(ctx);
                setState(() => _backgroundColor = tempColor);
              },
            ),
          ],
        );
      },
    );
  }

  // --- send message ---
  void _sendMessage() {
    final msg = _messageController.text.trim();
    if (msg.isEmpty) return;
    setState(() {
      _messages.add(msg);
      _messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    const teal = Color(0xFF128C7E); // Yenkasa green-teal
    final bgDecoration = _backgroundImage != null
        ? BoxDecoration(
      image: DecorationImage(
        image: FileImage(_backgroundImage!),
        fit: BoxFit.cover,
      ),
    )
        : BoxDecoration(color: _backgroundColor ?? Colors.white);

    return Scaffold(
      body: GestureDetector(
        onLongPress: _chooseBackground,
        child: Container(
          decoration: bgDecoration,
          child: Column(
            children: [
              // --- Header bar ---
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                color: teal,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    CircleAvatar(
                      radius: 22,
                      backgroundImage: NetworkImage(widget.receiverImageUrl),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.receiverName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          Text(
                            widget.isOnline ? "Online" : "Offline",
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.call, color: Colors.white),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.videocam, color: Colors.white),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              // --- Message list ---
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(8),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[_messages.length - 1 - index];
                    return Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: teal.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(msg, style: const TextStyle(fontSize: 15, color: Colors.black)),
                      ),
                    );
                  },
                ),
              ),

              // --- Attachments popup (optional future expansion) ---
              if (_showAttachMenu)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 6,
                        color: Colors.black12,
                        offset: Offset(0, -2),
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      _AttachIcon(icon: Icons.image, label: "Image"),
                      _AttachIcon(icon: Icons.videocam, label: "Video"),
                      _AttachIcon(icon: Icons.camera_alt, label: "Camera"),
                      _AttachIcon(icon: Icons.insert_drive_file, label: "File"),
                      _AttachIcon(icon: Icons.location_on, label: "Location"),
                      _AttachIcon(icon: Icons.contact_page, label: "Contact"),
                    ],
                  ),
                ),

              // --- Message input row ---
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.attach_file, color: teal),
                      onPressed: () => setState(() => _showAttachMenu = !_showAttachMenu),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        maxLines: 5,
                        minLines: 1,
                        decoration: InputDecoration(
                          hintText: "Type a message",
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.mic, color: teal),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: teal),
                      onPressed: _sendMessage,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AttachIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  const _AttachIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    const teal = Color(0xFF128C7E);
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: teal.withOpacity(0.1),
          radius: 22,
          child: Icon(icon, color: teal, size: 22),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.black87)),
      ],
    );
  }
}
