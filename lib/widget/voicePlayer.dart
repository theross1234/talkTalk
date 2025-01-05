import 'dart:async';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class VoicesMessage extends StatefulWidget {
  final String audioUrl;
  final Color backgroundColor;
  final Color fixedWaveColor;
  final Color liveWaveColor;

  const VoicesMessage({
    super.key,
    required this.audioUrl,
    required this.backgroundColor,
    required this.fixedWaveColor,
    required this.liveWaveColor,
  });

  @override
  State<VoicesMessage> createState() => _VoicesMessageState();
}

class _VoicesMessageState extends State<VoicesMessage> {
  final PlayerController _playerController = PlayerController();
  StreamSubscription<PlayerState>? _playerStateSubscription;
  late String _localAudioFilePath;

  @override
  void initState() {
    super.initState();
    // Delay the preparation to avoid blocking the main thread
    Future.delayed(const Duration(milliseconds: 280), () async {
      _localAudioFilePath = await _getLocalFilePath(widget.audioUrl);
      _prepareVoice();
      _subscribeToPlayerState();
    });
  }

  @override
  void dispose() {
    // Dispose of the player controller and subscription to prevent memory leaks
    _playerStateSubscription?.cancel();
    _playerController.dispose();
    super.dispose();
  }

  /// Returns the local file path for the audio file
  Future<String> _getLocalFilePath(String audioUrl) async {
    final tempDir = await getTemporaryDirectory();
    final fileName =
        audioUrl.split('/').last.split('?').first; // Extract filename
    return '${tempDir.path}/$fileName';
  }

  /// Prepares the voice message for playback
  Future<void> _prepareVoice() async {
    try {
      // Download the audio file if it doesn't exist locally
      final tempFilePath = await _downloadOrLoadAudioFile(widget.audioUrl);

      // Configure the player with the file path
      await _playerController.preparePlayer(
        path: tempFilePath,
        shouldExtractWaveform: true,
        noOfSamples: (MediaQuery.of(context).size.width / 0.5).floor() ~/ 5,
      );
    } catch (e) {
      debugPrint("Error preparing voice message: $e");
    }
  }

  /// Downloads or loads the audio file, returning the file path
  Future<String> _downloadOrLoadAudioFile(String audioUrl) async {
    final tempDir = await getTemporaryDirectory();

    if (audioUrl.startsWith("http")) {
      final response = await http.get(Uri.parse(audioUrl));
      if (response.statusCode == 200) {
        final tempFilePath = '${tempDir.path}/voice_message.mp3';
        final tempFile = File(tempFilePath);
        await tempFile.writeAsBytes(response.bodyBytes);
        return tempFilePath;
      } else {
        throw Exception(
            'Failed to download audio file. Status code: ${response.statusCode}');
      }
    } else {
      final byteData = await rootBundle.load(audioUrl);
      final tempFilePath = '${tempDir.path}/${audioUrl.split('/').last}';
      final tempFile = File(tempFilePath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(byteData.buffer
            .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      return tempFilePath;
    }
  }

  /// Subscribes to the player's state changes
  void _subscribeToPlayerState() {
    _playerStateSubscription =
        _playerController.onPlayerStateChanged.listen((_) {
      setState(() {});
    });
  }

  /// Toggles playback of the voice message
  Future<void> _togglePlayback() async {
    if (_playerController.playerState == PlayerState.playing) {
      await _playerController.pausePlayer();
    } else {
      await _playerController.startPlayer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxContainerWidth = MediaQuery.of(context).size.width * 0.75;

    return Container(
      constraints: BoxConstraints(maxWidth: maxContainerWidth),
      child: Card(
        margin: EdgeInsets.zero,
        color: widget.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: ListTile(
            contentPadding: const EdgeInsets.all(8.0),
            horizontalTitleGap: 8,
            leading: GestureDetector(
              onTap: _togglePlayback,
              child: CircleAvatar(
                radius: 22.5,
                child: Icon(
                  _playerController.playerState == PlayerState.playing
                      ? Icons.pause
                      : Icons.play_arrow,
                  color: Colors.black,
                ),
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: AudioFileWaveforms(
                size: Size(MediaQuery.of(context).size.width * 0.5, 25),
                playerController: _playerController,
                enableSeekGesture: true,
                continuousWaveform: false,
                waveformType: WaveformType.fitWidth,
                playerWaveStyle: PlayerWaveStyle(
                  fixedWaveColor: widget.fixedWaveColor,
                  liveWaveColor: widget.liveWaveColor,
                  spacing: 5,
                  waveThickness: 2.5,
                  scaleFactor: 70,
                ),
                backgroundColor: widget.backgroundColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
