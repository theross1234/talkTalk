import 'package:chatchat/enums/enums.dart';
import 'package:chatchat/utils/constant.dart';

class MessageReplyModel {
  final String message;
  final String senderUid;
  final String senderName;
  final String senderImage;
  final MessageEnum messageType;
  final bool isMe;

  MessageReplyModel({
    required this.message,
    required this.senderUid,
    required this.senderName,
    required this.senderImage,
    required this.messageType,
    required this.isMe,
  });

  // to map
  Map<String, dynamic> toMap() {
    return {
      Constant.message: message,
      Constant.senderUid: senderUid,
      Constant.senderName: senderName,
      Constant.senderImage: senderImage,
      Constant.messageType: messageType.name,
      Constant.isMe: isMe,
    };
  }

  // from map
  factory MessageReplyModel.fromMap(Map<String, dynamic> map) {
    return MessageReplyModel(
      message: map[Constant.message] ?? '',
      senderUid: map[Constant.senderUid] ?? '',
      senderName: map[Constant.senderName] ?? '',
      senderImage: map[Constant.senderImage] ?? '',
      messageType: map[Constant.messageType].toString().toMessageEnum(),
      isMe: map[Constant.isMe] ?? false,
    );
  }
}
