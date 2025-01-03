import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatchat/models/message_reply_model.dart';
import 'package:chatchat/providers/authenticationProvider.dart';
import 'package:chatchat/utils/assetManager.dart';
import 'package:chatchat/utils/constant.dart';
import 'package:date_format/date_format.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';

// //show snackbar method
// void showSnackBar(BuildContext context, String message) {
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//       content: Text(message),
//       // duration: const Duration(milliseconds: 500),
//     ),
//   );
// }

// pick image from gallery or camera
Future<File?> pickImage({
  required bool fromCamera,
  required Function(String) onFail,
}) async {
  File? fileImage;
  if (fromCamera) {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        fileImage = File(pickedImage.path);
      }
    } catch (e) {
      onFail(e.toString());
    }
  } else {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        fileImage = File(pickedImage.path);
      }
    } catch (e) {
      onFail(e.toString());
    }
  }
  return fileImage;
}

// pick video from gallery or camera
Future<File?> pickVideo({
  required bool fromCamera,
  required Function(String) onFail,
}) async {
  File? fileVideo;
  if (fromCamera) {
    try {
      final pickedVideo =
          await ImagePicker().pickVideo(source: ImageSource.camera);
      if (pickedVideo != null) {
        fileVideo = File(pickedVideo.path);
      }
    } catch (e) {
      onFail(e.toString());
    }
  } else {
    try {
      final pickedVideo =
          await ImagePicker().pickVideo(source: ImageSource.gallery);
      if (pickedVideo != null) {
        fileVideo = File(pickedVideo.path);
      }
    } catch (e) {
      onFail(e.toString());
    }
  }
  return fileVideo;
}

// pick file from explorer
Future<File?> pickFile({
  required void Function(String) onFail,
  List<String>? allowedExtensions, // Optional: Restrict file types
}) async {
  try {
    final result = await FilePicker.platform.pickFiles(
      type: allowedExtensions != null
          ? FileType.custom
          : FileType.any, // Support filtering by extensions
      allowedExtensions: allowedExtensions,
    );
    if (result != null && result.files.isNotEmpty) {
      final filePath = result.files.first.path;
      if (filePath != null) {
        final file = File(filePath);
        // Log or handle file details if needed
        debugPrint('Selected file: ${result.names.first}');
        debugPrint('File path: $filePath');
        debugPrint('File size: ${result.files.first.size} bytes');
        debugPrint('File extension: ${result.files.first.extension}');
        return file;
      } else {
        onFail("File path is null. Unable to process the file.");
      }
    } else {
      onFail("No file selected.");
    }
  } catch (e) {
    onFail("File picking failed: ${e.toString()}");
  }
  return null;
}

// user image widget

Widget userImageWidget({
  required String imageUrl,
  required double radius,
  required Function() onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: CircleAvatar(
      backgroundColor: Colors.grey,
      radius: radius,
      backgroundImage: imageUrl.isNotEmpty
          ? CachedNetworkImageProvider(imageUrl)
          : const AssetImage(AssetsManager.userDefaultIcon) as ImageProvider,
    ),
  );
}

Padding buildDateTimeHeader(groupByValue) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      formatDate(groupByValue.timeSent, [
        d,
        ' ',
        M,
        ' ',
        yy,
      ]),
      textAlign: TextAlign.center,
      style: const TextStyle(
          fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
    ),
  );
}

class CustomSnackBar {
  static void show({
    required BuildContext context,
    required String message,
    Color backgroundColor = Colors.black,
    Color textColor = Colors.white,
    int durationInSeconds = 3,
    //SnackBarAction? action,
  }) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: textColor),
      ),
      backgroundColor: backgroundColor,
      duration: Duration(seconds: durationInSeconds),
      //action: action,
      behavior: SnackBarBehavior.floating, // Optional for a floating effect
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

/// Helper function to show a custom snackbar
void showCustomSnackBar(
    {required BuildContext context,
    required String title,
    required String message,
    required ContentType contentType}) {
  final snackBar = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: title,
      message: message,
      contentType: contentType,
    ),
  );

  // Display the SnackBar
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

Widget messageToShow({
  required MessageEnum messageType,
  required String message,
}) {
  switch (messageType) {
    case MessageEnum.text:
      return Text(
        message,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
      );
    case MessageEnum.image:
      return const Row(
        children: [
          Icon(
            color: Colors.grey,
            Icons.image_outlined,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            style: TextStyle(color: Colors.grey),
            'image',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        ],
      );
    case MessageEnum.audio:
      return const Row(
        children: [
          Icon(
            color: Colors.grey,
            Icons.audiotrack_outlined,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            style: TextStyle(color: Colors.grey),
            'audio',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        ],
      );
    case MessageEnum.video:
      return const Row(
        children: [
          Icon(
            color: Colors.grey,
            Icons.video_camera_back_outlined,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            style: TextStyle(color: Colors.grey),
            'video',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        ],
      );
    case MessageEnum.document:
      return const Row(
        children: [
          Icon(
            color: Colors.grey,
            Icons.file_open_outlined,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            style: TextStyle(color: Colors.grey),
            'document',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        ],
      );
    default:
      return Text(
        message,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
      );
  }
}
