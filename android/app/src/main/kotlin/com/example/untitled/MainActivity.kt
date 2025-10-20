package com.example.untitled

import android.content.Context
import android.content.Intent
import android.media.AudioDeviceCallback
import android.media.AudioDeviceInfo
import android.media.AudioManager
import android.media.MediaPlayer
import android.provider.Settings
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.untitled/audio"
    private lateinit var audioManager: AudioManager
    private lateinit var audioCallback: AudioDeviceCallback
    private var mediaPlayer: MediaPlayer? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager

        audioCallback = object : AudioDeviceCallback() {
            override fun onAudioDevicesAdded(addedDevices: Array<out AudioDeviceInfo>?) {
                super.onAudioDevicesAdded(addedDevices)
                Log.d("AudioHelper", "Audio devices added")
            }

            override fun onAudioDevicesRemoved(removedDevices: Array<out AudioDeviceInfo>?) {
                super.onAudioDevicesRemoved(removedDevices)
                Log.d("AudioHelper", "Audio devices removed")
            }
        }
        audioManager.registerAudioDeviceCallback(audioCallback, null)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "isSpeakerAvailable" ->
                        result.success(audioOutputAvailable(AudioDeviceInfo.TYPE_BUILTIN_SPEAKER))
                    "isBluetoothConnected" ->
                        result.success(audioOutputAvailable(AudioDeviceInfo.TYPE_BLUETOOTH_A2DP))
                    "openBluetoothSettings" -> {
                        openBluetoothSettings()
                        result.success(null)
                    }
                    "playTestAudio" -> {
                        playTestAudio()
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun audioOutputAvailable(type: Int): Boolean {
        val devices = audioManager.getDevices(AudioManager.GET_DEVICES_OUTPUTS)
        return devices.any { it.type == type }
    }

    private fun openBluetoothSettings() {
        val intent = Intent(Settings.ACTION_BLUETOOTH_SETTINGS).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK)
        }
        startActivity(intent)
    }

    private fun playTestAudio() {
        mediaPlayer?.release() 
        mediaPlayer = MediaPlayer.create(this, R.raw.test_sound)
        mediaPlayer?.setOnCompletionListener {
            it.release()
            mediaPlayer = null
        }
        mediaPlayer?.start()
        Log.d("AudioHelper", "Test audio played")
    }

    override fun onDestroy() {
        super.onDestroy()
        mediaPlayer?.release()
        audioManager.unregisterAudioDeviceCallback(audioCallback)
    }
}