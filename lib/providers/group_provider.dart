import 'dart:io';

import 'package:chatchat/models/groupModel.dart';
import 'package:chatchat/models/user_model.dart';
import 'package:chatchat/utils/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class GroupProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _editSettings = true;
  bool _approveNewMember = false;
  bool _requestsToJoin = false;
  bool _lockMessages = false;

  GroupModel? _groupmodel;
  final List<UserModel> _groupMembersList = [];
  final List<UserModel> _groupAdminList = [];

  // getters
  bool get isLoading => _isLoading;
  bool get editSettings => _editSettings;
  bool get approveNewMember => _approveNewMember;
  bool get requestsToJoin => _requestsToJoin;
  bool get lockMessages => _lockMessages;
  GroupModel get groupmodel => _groupmodel!;
  List<UserModel> get groupMembersList => _groupMembersList;
  List<UserModel> get groupAdminList => _groupAdminList;

  // firebase intialisation
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  // setters
  void setIsLoading({required bool value}) {
    _isLoading = value;
    notifyListeners();
  }

  void setEditSettings({required bool value}) {
    _editSettings = value;
    notifyListeners();
  }

  void setApproveNewMember({required bool value}) {
    _approveNewMember = value;
    notifyListeners();
  }

  void setRequestsToJoin({required bool value}) {
    _requestsToJoin = value;
    notifyListeners();
  }

  void setLockMessages({required bool value}) {
    _lockMessages = value;
    notifyListeners();
  }

  void setGroupmodel({required GroupModel value}) {
    _groupmodel = value;
    notifyListeners();
  }

  void addMemberToGroupList({required UserModel groupMembers}) {
    // _groupMembersList.clear();
    _groupMembersList.add(groupMembers);
    notifyListeners();
  }

  void addMemberToAdminList({required UserModel groupAdmin}) {
    // _groupAdminList.clear();
    _groupAdminList.add(groupAdmin);
    notifyListeners();
  }

  // remove member from group
  void removeMemberFromGroup({required UserModel groupMember}) {
    _groupMembersList.remove(groupMember);
    // remove this user from admin list
    _groupAdminList.remove(groupMember);
    notifyListeners();
  }

  // remove admin from group
  void removeAdminFromGroup({required UserModel groupAdmin}) {
    _groupAdminList.remove(groupAdmin);
    notifyListeners();
  }

  // clear group member list
  Future<void> clearGroupMembersList() async {
    _groupMembersList.clear();
    notifyListeners();
  }

  // clear admin list
  Future<void> clearGroupAdminList() async {
    _groupAdminList.clear();
    notifyListeners();
  }

  // get list of the members uids from groupMembersList
  // List<String> getGroupMemberUidList() {
  //   List<String> groupMemberUidList = [];
  //   for (int i = 0; i < _groupMembersList.length; i++) {
  //     groupMemberUidList.add(_groupMembersList[i].uid);
  //   }
  //   return groupMemberUidList;
  // }
  List<String> getGroupMemberUidList() {
    return _groupMembersList.map((e) => e.uid).toList();
  }

  // get list of the admins uids from groupAdminList
  List<String> getGroupAdminUidList() {
    return _groupAdminList.map((e) => e.uid).toList();
  }

  // create a group
  Future<void> createGroup({
    required GroupModel groupModel,
    required File? groupImage,
    required Function onSuccess,
    required Function(String) onFail,
  }) async {
    setIsLoading(value: true);
    try {
      var groupId = const Uuid().v4();
      groupModel.groupId = groupId;

      // check if the file image is not null
      if (groupImage != null) {
        // upload the image to firebase storage
        final String imageUrl = await storeFileToStorage(
            file: groupImage, reference: "${Constant.groupImages}/$groupId");
        groupModel.groupImage = imageUrl;
      }
      // add the group admin
      groupModel.adminsUids = [
        groupModel.createrUid,
        ...getGroupAdminUidList()
      ];
      // add the group members
      groupModel.groupMembersUids = [
        groupModel.createrUid,
        ...getGroupMemberUidList()
      ];
      // add the setting of the group
      groupModel.editSettings = editSettings;

      // add the approval of new members
      groupModel.approveMembers = approveNewMember;

      // add the requests to join
      groupModel.requestToJoin = requestsToJoin;

      // add the lock messages
      groupModel.lockMessages = lockMessages;

      // add the group to firebase
      await _firestore
          .collection(Constant.groups)
          .doc(groupId)
          .set(groupModel.toMap());

      // set Loading to false
      setIsLoading(value: false);

      // call the onSuccess function
      onSuccess();
    } catch (e) {
      setIsLoading(value: false);
      onFail(e.toString());
    }
  }

  // store File to storage and return file url
  Future<String> storeFileToStorage(
      {required File file, required String reference}) async {
    UploadTask uploadTask =
        _firebaseStorage.ref().child(reference).putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    String fileUrl = await taskSnapshot.ref.getDownloadURL();
    return fileUrl;
  }
}
