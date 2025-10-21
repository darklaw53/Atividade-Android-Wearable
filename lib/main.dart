import 'package:flutter/material.dart';
import 'audio_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wear OS Audio Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const AudioHome(),
    );
  }
}

class AudioHome extends StatefulWidget {
  const AudioHome({super.key});

  @override
  State<AudioHome> createState() => _AudioHomeState();
}

class _AudioHomeState extends State<AudioHome> {
  final AudioService audioService = AudioService();

  Future<void> _showAudioInfo() async {
    try {
      bool speaker = await audioService.isSpeakerAvailable();
      bool bt = await audioService.isBluetoothConnected();

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => Dialog(
          insetPadding: const EdgeInsets.all(8),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
              maxWidth: MediaQuery.of(context).size.width * 0.9,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Audio Info',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Speaker available: $speaker\nBluetooth connected: $bt',
                    style: const TextStyle(fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => Dialog(
          insetPadding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Error',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('$e', textAlign: TextAlign.center),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  void _openBluetoothSettings() {
    audioService.openBluetoothSettings();
  }

  void _playTestAudio() {
    audioService.playTestAudio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wear OS'),
      centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: _showAudioInfo,
                  child: const Text('Check Audio Devices'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _openBluetoothSettings,
                  child: const Text('Open Bluetooth Settings'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _playTestAudio,
                  child: const Text('Play Test Audio'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}