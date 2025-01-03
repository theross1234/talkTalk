import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatchat/utils/constant.dart';
import 'package:chatchat/widget/audioPlayerWidget.dart';
import 'package:chatchat/widget/openfilewidget';
import 'package:chatchat/widget/videoPlayerWidget_another.dart';
import 'package:chatchat/widget/video_player_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class DisplayMessageType extends StatelessWidget {
  final String message;

  final Color color;

  final int? maxLines;

  final TextOverflow? overFlow;

  final MessageEnum type;

  const DisplayMessageType({
    super.key,
    required this.message,
    required this.type,
    required this.color,
    this.maxLines,
    this.overFlow,
  });

  // Future openFile({
  //   required String url,
  //   String? fileName,
  // }) async {
  //   final file = await downloadFile(url: url, name: fileName);
  //   if (file == null) return;

  //   print('path: ${file.path}');
  //   OpenFile.open(file.path);
  // }

  // // DOwnload file into private folder not visible to user
  // Future<File?> downloadFile({
  //   required String url,
  //   String? name,
  // }) async {
  //   final appStorage = await getApplicationDocumentsDirectory();
  //   final file = File('${appStorage.path}/$name');

  //   try {
  //     final response = await Dio().get(
  //       url,
  //       options: Options(
  //         responseType: ResponseType.bytes,
  //         followRedirects: false,
  //         receiveTimeout: const Duration(seconds: 0),
  //       ),
  //     );

  //     final raf = file.openSync(mode: FileMode.write);
  //     raf.writeFromSync(response.data);
  //     await raf.close();

  //     return file;
  //   } catch (e) {
  //     print(e);
  //     return null;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Widget messageToShow() {
      switch (type) {
        case MessageEnum.text:
          return Text(
            message,
            style: TextStyle(color: color, fontSize: 16.0),
            maxLines: maxLines,
            overflow: overFlow,
          );
        case MessageEnum.image:
          return CachedNetworkImage(
            imageUrl: message,
            fit: BoxFit.cover,
          );
        case MessageEnum.audio:
          return AudioPlayerWidget(
            audioUrl: message,
            colors: color,
          );
        case MessageEnum.video:
          // return VideoPlayerWidget(
          //   videoUrl: message,
          //   colors: color,
          // );
          return VideoPlayerWidgetAnother(
            dataSource: message,
          );
        case MessageEnum.document:
          // return Text(
          //   message,
          //   style: const TextStyle(color: Colors.white, fontSize: 16.0),
          //   maxLines: maxLines,
          //   overflow: overFlow,
          // );
          return FirestoreFileWidget(fileUrl: message, fileName: "file");
        default:
          return Text(
            message,
            style: const TextStyle(color: Colors.white, fontSize: 16.0),
            maxLines: maxLines,
            overflow: overFlow,
          );
      }
    }

    return messageToShow();
  }
}
