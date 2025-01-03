import 'package:chatchat/utils/constant.dart';

class UserModel {
  String uid;
  String name;
  String token;
  String phoneNumber;
  String aboutMe;
  String image;
  String lastSeen;
  String createdAt;
  bool isOnline;
  List<String> friendsUids;
  List<String> receivefriendRequestsUids;
  List<String> sentFriendRequestsUids;

  UserModel(
      {required this.uid,
      required this.name,
      required this.token,
      required this.phoneNumber,
      required this.aboutMe,
      required this.image,
      required this.lastSeen,
      required this.createdAt,
      required this.isOnline,
      required this.friendsUids,
      required this.receivefriendRequestsUids,
      required this.sentFriendRequestsUids});

  //from map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        uid: map[Constant.uid] ?? '',
        name: map[Constant.name] ?? '',
        token: map[Constant.token] ?? '',
        phoneNumber: map[Constant.phoneNumber] ?? '',
        aboutMe: map[Constant.aboutMe] ?? '',
        image: map[Constant.image] ?? '',
        lastSeen: map[Constant.lastSeen] ?? '',
        createdAt: map[Constant.createdAt] ?? '',
        isOnline: map[Constant.isOnline] ?? false,
        friendsUids: List<String>.from(map[Constant.friendsUids] ?? []),
        receivefriendRequestsUids:
            List<String>.from(map[Constant.receivefriendRequestsUids] ?? []),
        sentFriendRequestsUids:
            List<String>.from(map[Constant.sentFriendRequestsUids] ?? []));
  }

  Map<String, dynamic> toMap() {
    return {
      Constant.uid: uid,
      Constant.name: name,
      Constant.token: token,
      Constant.phoneNumber: phoneNumber,
      Constant.aboutMe: aboutMe,
      Constant.image: image,
      Constant.lastSeen: lastSeen,
      Constant.createdAt: createdAt,
      Constant.isOnline: isOnline,
      Constant.friendsUids: friendsUids,
      Constant.receivefriendRequestsUids: receivefriendRequestsUids,
      Constant.sentFriendRequestsUids: sentFriendRequestsUids
    };
  }
}
