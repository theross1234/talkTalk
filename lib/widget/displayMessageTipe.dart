import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatchat/utils/constant.dart';
import 'package:chatchat/widget/audioPlayerWidget.dart';
import 'package:chatchat/widget/openfilewidget';
import 'package:chatchat/widget/videoPlayerWidget_another.dart';
import 'package:chatchat/widget/voicePlayer.dart';
import 'package:flutter/material.dart';

class DisplayMessageType extends StatefulWidget {
  final String message;

  final Color color;

  final int? maxLines;

  final TextOverflow? overFlow;

  final MessageEnum type;
  final bool isReply;

  const DisplayMessageType({
    super.key,
    required this.message,
    required this.isReply,
    required this.type,
    required this.color,
    this.maxLines,
    this.overFlow,
  });

  @override
  State<DisplayMessageType> createState() => _DisplayMessageTypeState();
}

class _DisplayMessageTypeState extends State<DisplayMessageType> {
  late CustomVideoPlayerController _customVideoPlayerController;

  late CachedVideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    // Initialize the video controller
    _videoPlayerController = CachedVideoPlayerController.network(widget.message)
      ..initialize().then((_) {
        setState(() {}); // Refresh UI after initialization
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
    _customVideoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget messageToShow() {
      switch (widget.type) {
        case MessageEnum.text:
          return Text(
            widget.message,
            style: TextStyle(color: widget.color, fontSize: 16.0),
            maxLines: widget.maxLines,
            overflow: widget.overFlow,
          );
        case MessageEnum.image:
          return CachedNetworkImage(
            imageUrl: widget.message,
            fit: BoxFit.cover,
          );
        case MessageEnum.audio:
          return AudioPlayerWidget(
            audioUrl: widget.message,
            colors: widget.color,
          );
        // return VoicesMessage(
        //   audioUrl: widget.message,
        //   backgroundColor: Colors.black,
        //   fixedWaveColor: const Color.fromARGB(255, 255, 0, 0),
        //   liveWaveColor: const Color.fromARGB(255, 255, 255, 255),
        // );
        case MessageEnum.video:
          // return VideoPlayerWidget(
          //   videoUrl: widget.message,
          //   colors: widget.color,
          // );
          print(
              "/././././../././././ there is the video link ${widget.message}");
          return VideoPlayerWidgetAnother(
            dataSource: widget.message,
          );
        // return AspectRatio(
        //   aspectRatio: _videoPlayerController.value.aspectRatio,
        //   child: CustomVideoPlayer(
        //       customVideoPlayerController: _customVideoPlayerController),
        // );
        case MessageEnum.document:
          // return Text(
          //   message,
          //   style: const TextStyle(color: Colors.white, fontSize: 16.0),
          //   maxLines: maxLines,
          //   overflow: overFlow,
          // );
          return FirestoreFileWidget(fileUrl: widget.message, fileName: "file");
        default:
          return Text(
            widget.message,
            style: const TextStyle(color: Colors.white, fontSize: 16.0),
            maxLines: widget.maxLines,
            overflow: widget.overFlow,
          );
      }
    }

    return messageToShow();
  }
}
