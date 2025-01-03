import 'package:chatchat/utils/constant.dart';

class MessageModel {
  final String messageId;
  final String message;
  final String senderUid;
  final String senderName;
  final String senderImage;
  final String contactUid;
  final DateTime timeSent;
  final MessageEnum messageType;
  final bool isSeen;
  final String repliedMessage;
  final String repliedTo;
  final MessageEnum repliedMessageType;

  MessageModel({
    required this.messageId,
    required this.message,
    required this.senderUid,
    required this.senderName,
    required this.senderImage,
    required this.contactUid,
    required this.timeSent,
    required this.messageType,
    required this.isSeen,
    required this.repliedMessage,
    required this.repliedTo,
    required this.repliedMessageType,
  });

  // to map
  Map<String, dynamic> toMap() {
    return {
      Constant.messageId: messageId,
      Constant.message: message,
      Constant.senderUid: senderUid,
      Constant.senderName: senderName,
      Constant.senderImage: senderImage,
      Constant.contactUid: contactUid,
      //Constant.contactName: contactName,
      Constant.timeSent: timeSent.millisecondsSinceEpoch,
      Constant.messageType: messageType.name,
      Constant.isSeen: isSeen,
      Constant.repliedMessage: repliedMessage,
      Constant.repliedTo: repliedTo,
      Constant.repliedMessageType: repliedMessageType.name,
    };
  }

  // from map
  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      messageId: map[Constant.messageId] ?? '',
      message: map[Constant.message] ?? '',
      senderUid: map[Constant.senderUid] ?? '',
      senderName: map[Constant.senderName] ?? '',
      senderImage: map[Constant.senderImage] ?? '',
      contactUid: map[Constant.contactUid] ?? '',
      //contactName: map[Constant.contactName] ?? '',
      timeSent: DateTime.fromMillisecondsSinceEpoch(map[Constant.timeSent]),
      messageType: map[Constant.messageType].toString().toMessageEnum(),
      isSeen: map[Constant.isSeen] ?? false,
      repliedMessage: map[Constant.repliedMessage] ?? '',
      repliedTo: map[Constant.repliedTo] ?? '',
      repliedMessageType:
          map[Constant.repliedMessageType].toString().toMessageEnum(),
    );
  }

  copyWith({
    required String userId,
  }) {
    return MessageModel(
      messageId: messageId,
      message: message,
      senderUid: senderUid,
      senderName: senderName,
      senderImage: senderImage,
      contactUid: userId,
      //contactName: contactName,
      timeSent: timeSent,
      messageType: messageType,
      isSeen: isSeen,
      repliedMessage: repliedMessage,
      repliedTo: repliedTo,
      repliedMessageType: repliedMessageType,
    );
  }
}
