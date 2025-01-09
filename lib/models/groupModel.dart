import 'package:chatchat/enums/enums.dart';
import 'package:chatchat/utils/constant.dart';

class Groupmodel {
  String groupId;
  String createrUid;
  String groupName;
  String groupImage;
  //String groupAdmin;
  MessageEnum messageType;
  String lastMessageId;
  String groupDescription;
  String lastMessage;
  String senderUid;
  DateTime groupCreatedAt;
  DateTime timeSent;
  bool isPrivate;
  bool editSettings;
  bool approveMembers;
  bool lockMessages;
  bool requestToJoin;
  List<String> groupMembersUids;
  List<String> adminsUids;
  List<String> awaitingApprovalUids;

  Groupmodel({
    required this.groupId,
    required this.createrUid,
    required this.groupName,
    required this.groupImage,
    //required this.groupAdmin,
    required this.messageType,
    required this.lastMessageId,
    required this.groupDescription,
    required this.lastMessage,
    required this.senderUid,
    required this.groupCreatedAt,
    required this.timeSent,
    required this.isPrivate,
    required this.editSettings,
    required this.approveMembers,
    required this.lockMessages,
    required this.requestToJoin,
    required this.groupMembersUids,
    required this.adminsUids,
    required this.awaitingApprovalUids,
  });

  // to map
  Map<String, dynamic> toMap() {
    return {
      Constant.groupId: groupId,
      Constant.createrUid: createrUid,
      Constant.groupName: groupName,
      Constant.groupImage: groupImage,
      //'groupAdmin': groupAdmin,
      Constant.messageType: messageType,
      Constant.lastMessageId: lastMessageId,
      Constant.groupDescription: groupDescription,
      Constant.lastMessage: lastMessage,
      Constant.senderUid: senderUid,
      Constant.groupCreatedAt: groupCreatedAt,
      Constant.timeSent: timeSent,
      Constant.isPrivate: isPrivate,
      Constant.editSettings: editSettings,
      Constant.ApproveMembers: approveMembers,
      Constant.lockMessages: lockMessages,
      Constant.requestToJoin: requestToJoin,
      Constant.groupMembersUids: groupMembersUids,
      Constant.adminsUids: adminsUids,
      Constant.awaitingApprovalUids: awaitingApprovalUids,
    };
  }

  // from map
  factory Groupmodel.fromMap(Map<String, dynamic> map) {
    return Groupmodel(
      groupId: map[Constant.groupId] ?? '',
      createrUid: map[Constant.createrUid] ?? '',
      groupName: map[Constant.groupName] ?? '',
      groupImage: map[Constant.groupImage] ?? '',
      messageType: map[Constant.messageType].toString().toMessageEnum(),
      lastMessageId: map[Constant.lastMessageId] ?? '',
      groupDescription: map[Constant.groupDescription] ?? '',
      lastMessage: map[Constant.lastMessage] ?? '',
      senderUid: map[Constant.senderUid] ?? '',
      groupCreatedAt:
          DateTime.fromMillisecondsSinceEpoch(map[Constant.groupCreatedAt]),
      timeSent: DateTime.fromMillisecondsSinceEpoch(map[Constant.timeSent]),
      isPrivate: map[Constant.isPrivate] ?? false,
      editSettings: map[Constant.editSettings] ?? false,
      approveMembers: map[Constant.ApproveMembers] ?? false,
      lockMessages: map[Constant.lockMessages] ?? false,
      requestToJoin: map[Constant.requestToJoin] ?? false,
      groupMembersUids: List<String>.from(map[Constant.groupMembersUids]),
      adminsUids: List<String>.from(map[Constant.adminsUids]),
      awaitingApprovalUids:
          List<String>.from(map[Constant.awaitingApprovalUids] ?? []),
    );
  }
}
