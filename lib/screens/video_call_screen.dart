import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wakelock_plus/wakelock_plus.dart'; // keeps screen awake

class VideoCallScreen extends StatefulWidget {
  final String callUrl; // e.g. Daily.co room link
  final bool isVideoCall;

  const VideoCallScreen({
    Key? key,
    required this.callUrl,
    this.isVideoCall = true,
  }) : super(key: key);

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late WebViewController _controller;
  bool _micOn = true;
  bool _cameraOn = true;
  String _status = "Connecting...";

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable(); // keep screen on
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  void _toggleMic() {
    setState(() => _micOn = !_micOn);
    // If your WebRTC library allows JS injection, you could do:
    // _controller.runJavascript("toggleMicrophone(${_micOn.toString()});");
  }

  void _toggleCamera() {
    setState(() => _cameraOn = !_cameraOn);
    // Similarly, if your JS bridge supports it:
    // _controller.runJavascript("toggleCamera(${_cameraOn.toString()});");
  }

  void _endCall() {
    setState(() => _status = "Call Ended");
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    const white = Colors.white;
    const overlayColor = Color(0x80000000);
    const teal = Color(0xFF128C7E);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // --- WebView showing your WebRTC call ---
          WebView(
            initialUrl: widget.callUrl,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (controller) => _controller = controller,
            onPageFinished: (_) => setState(() => _status = "In Call"),
          ),

          // --- Status Text (e.g. Connecting...) ---
          if (_status != "In Call")
            Center(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: overlayColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _status,
                  style: const TextStyle(color: white, fontSize: 18),
                ),
              ),
            ),

          // --- Call Controls (bottom bar) ---
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: overlayColor,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Mic toggle
                  _CallButton(
                    icon: _micOn ? Icons.mic : Icons.mic_off,
                    onTap: _toggleMic,
                    bgColor: teal,
                  ),

                  const SizedBox(width: 32),

                  // End Call
                  _CallButton(
                    icon: Icons.call_end,
                    onTap: _endCall,
                    bgColor: Colors.redAccent,
                    size: 70,
                  ),

                  const SizedBox(width: 32),

                  // Camera toggle
                  if (widget.isVideoCall)
                    _CallButton(
                      icon: _cameraOn ? Icons.videocam : Icons.videocam_off,
                      onTap: _toggleCamera,
                      bgColor: teal,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CallButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color bgColor;
  final double size;

  const _CallButton({
    required this.icon,
    required this.onTap,
    required this.bgColor,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(size / 2),
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: size * 0.5),
      ),
    );
  }
}
