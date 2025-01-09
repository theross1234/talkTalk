import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayerWidgetAnother extends StatefulWidget {
  final String dataSource;

  const VideoPlayerWidgetAnother({
    super.key,
    required this.dataSource,
  });

  @override
  State<VideoPlayerWidgetAnother> createState() =>
      _VideoPlayerWidgetAnotherState();
}

class _VideoPlayerWidgetAnotherState extends State<VideoPlayerWidgetAnother> {
  late CustomVideoPlayerController _customVideoPlayerController;
  late CachedVideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    // Initialize the video controller
    _videoPlayerController =
        CachedVideoPlayerController.network(widget.dataSource)
          ..initialize().then((_) {
            setState(() {}); // Refresh UI after initialization
          }).catchError((e) {
            print("/./././././././././././././././././././././././");
            print("Error initializing video: $e");
            print("/././././././././././././././././././././././");
          });

    // Configure the custom video player controller
    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: _videoPlayerController,
      customVideoPlayerSettings: const CustomVideoPlayerSettings(
          // enterFullscreenOnStart: false,
          // exitFullscreenOnEnd: true,
          showFullscreenButton: false),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _customVideoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_videoPlayerController.value.isInitialized) {
      return CustomVideoPlayer(
          customVideoPlayerController: _customVideoPlayerController);
    } else if (_videoPlayerController.value.hasError) {
      return const Center(child: Text("Error loading video"));
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}
