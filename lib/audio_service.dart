import 'package:flutter/services.dart';

class AudioService {
  static const platform = MethodChannel('com.example.untitled/audio');

  Future<bool> isSpeakerAvailable() async {
    final result = await platform.invokeMethod('isSpeakerAvailable');
    return result == true;
  }

  Future<bool> isBluetoothConnected() async {
    final result = await platform.invokeMethod('isBluetoothConnected');
    return result == true;
  }

  Future<void> openBluetoothSettings() async {
    await platform.invokeMethod('openBluetoothSettings');
  }

  Future<void> playTestAudio() async {
    try {
      await platform.invokeMethod('playTestAudio');
    } on PlatformException catch (e) {
      print("Error calling playTestAudio: ${e.message}");
    }
  }
}