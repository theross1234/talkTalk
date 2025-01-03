import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final Color colors;
  const VideoPlayerWidget({
    super.key,
    required this.videoUrl,
    required this.colors,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late CachedVideoPlayerController _videoPlayerController;
  bool isVideoPlaying = false;
  bool isLoading = true;

  @override
  void initState() {
    _videoPlayerController =
        CachedVideoPlayerController.network(widget.videoUrl)
          ..addListener(() {})
          ..initialize().then((_) {
            setState(() {
              _videoPlayerController.setVolume(1);
              setState(() {
                isLoading = false;
              });
              //isVideoPlaying = true;
            });
          });
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          children: [
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : CachedVideoPlayer(_videoPlayerController),
            Align(
              alignment: Alignment.center,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    isVideoPlaying = !isVideoPlaying;
                    isVideoPlaying
                        ? _videoPlayerController.play()
                        : _videoPlayerController.pause();
                  });
                },
                icon: Icon(
                  isVideoPlaying ? Icons.pause : Icons.play_arrow,
                  color: widget.colors,
                  size: 50,
                ),
              ),
            ),
          ],
        ));
  }
}
