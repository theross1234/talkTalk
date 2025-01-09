import 'package:chatchat/enums/enums.dart';
import 'package:chatchat/utils/constant.dart';

class LastMessageModel {
  String message;
  String senderUid;
  String contactUid;
  String contactName;
  String contactImage;
  DateTime timeSent;
  MessageEnum messageType;
  bool isSeen;
  //String timestamp;

  LastMessageModel(
      {required this.message,
      //required this.timestamp,
      required this.senderUid,
      required this.contactUid,
      required this.contactName,
      required this.contactImage,
      required this.timeSent,
      required this.messageType,
      required this.isSeen});

  // to map
  Map<String, dynamic> toMap() {
    return {
      Constant.message: message,
      Constant.senderUid: senderUid,
      Constant.contactUid: contactUid,
      Constant.contactName: contactName,
      Constant.contactImage: contactImage,
      Constant.timeSent: timeSent.microsecondsSinceEpoch,
      Constant.messageType: messageType.name,
      Constant.isSeen: isSeen,
    };
  }

  // from map
  factory LastMessageModel.fromMap(Map<String, dynamic> map) {
    return LastMessageModel(
      message: map[Constant.message] ?? '',
      senderUid: map[Constant.senderUid] ?? '',
      contactUid: map[Constant.contactUid] ?? '',
      contactName: map[Constant.contactName] ?? '',
      contactImage: map[Constant.contactImage] ?? '',
      timeSent: DateTime.fromMicrosecondsSinceEpoch(map[Constant.timeSent]),
      messageType: map[Constant.messageType].toString().toMessageEnum(),
      isSeen: map[Constant.isSeen],
    );
  }

  // copy with method
  copyWith({
    required String contactUid,
    required String contactName,
    required String contactImage,
  }) {
    return LastMessageModel(
      message: message,
      senderUid: senderUid,
      contactUid: contactUid,
      contactName: contactName,
      contactImage: contactImage,
      timeSent: timeSent,
      messageType: messageType,
      isSeen: isSeen,
    );
  }
}
