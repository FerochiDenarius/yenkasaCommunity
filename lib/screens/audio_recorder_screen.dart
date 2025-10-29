import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

class AudioRecorderScreen extends StatefulWidget {
  const AudioRecorderScreen({Key? key}) : super(key: key);

  @override
  State<AudioRecorderScreen> createState() => _AudioRecorderScreenState();
}

class _AudioRecorderScreenState extends State<AudioRecorderScreen> {
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();

  bool _isRecording = false;
  bool _isPreviewVisible = false;
  String? _filePath;
  Duration _recordDuration = Duration.zero;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _player.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    if (await _recorder.hasPermission()) {
      await _recorder.start();
      _recordDuration = Duration.zero;
      _timer = Timer.periodic(const Duration(seconds: 1), (t) {
        setState(() => _recordDuration += const Duration(seconds: 1));
      });
      setState(() => _isRecording = true);
    }
  }

  Future<void> _stopRecording() async {
    final path = await _recorder.stop();
    _timer?.cancel();
    setState(() {
      _isRecording = false;
      _filePath = path;
      _isPreviewVisible = true;
    });
  }

  Future<void> _playPreview() async {
    if (_filePath != null) {
      await _player.play(DeviceFileSource(_filePath!));
    }
  }

  void _deleteAudio() {
    setState(() {
      _filePath = null;
      _isPreviewVisible = false;
    });
  }

  void _sendAudio() {
    if (_filePath != null) {
      // TODO: Integrate with your chat send logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Audio file sent: $_filePath")),
      );
      Navigator.pop(context);
    }
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(d.inMinutes)}:${twoDigits(d.inSeconds.remainder(60))}";
  }

  @override
  Widget build(BuildContext context) {
    const teal = Color(0xFF128C7E);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Recorder', style: TextStyle(color: Colors.white)),
        backgroundColor: teal,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isRecording)
                Text(
                  _formatDuration(_recordDuration),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

              const SizedBox(height: 20),

              // --- Record Controls ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!_isRecording)
                    IconButton(
                      icon: const Icon(Icons.mic, size: 64, color: Colors.black),
                      onPressed: _startRecording,
                    ),
                  if (_isRecording)
                    IconButton(
                      icon: const Icon(Icons.stop, size: 64, color: Colors.red),
                      onPressed: _stopRecording,
                    ),
                ],
              ),

              const SizedBox(height: 24),

              // --- Preview Controls ---
              if (_isPreviewVisible)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.play_arrow, size: 48, color: Colors.black),
                      onPressed: _playPreview,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 48, color: Colors.black),
                      onPressed: _deleteAudio,
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, size: 48, color: teal),
                      onPressed: _sendAudio,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
