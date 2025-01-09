import 'package:chatchat/models/groupModel.dart';
import 'package:chatchat/models/user_model.dart';
import 'package:flutter/material.dart';

class GroupProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _editSettings = true;
  bool _approveNewMember = false;
  bool _requestsToJoin = false;
  bool _lockMessages = false;

  Groupmodel? _groupmodel;
  final List<UserModel> _groupMembersList = [];
  final List<UserModel> _groupAdminList = [];

  // getters
  bool get isLoading => _isLoading;
  bool get editSettings => _editSettings;
  bool get approveNewMember => _approveNewMember;
  bool get requestsToJoin => _requestsToJoin;
  bool get lockMessages => _lockMessages;
  Groupmodel get groupmodel => _groupmodel!;
  List<UserModel> get groupMembersList => _groupMembersList;
  List<UserModel> get groupAdminList => _groupAdminList;

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

  void setGroupmodel({required Groupmodel value}) {
    _groupmodel = value;
    notifyListeners();
  }

  void setGroupMembersList({required UserModel groupMembers}) {
    // _groupMembersList.clear();
    _groupMembersList.add(groupMembers);
    notifyListeners();
  }

  void setGroupAdminList({required UserModel groupAdmin}) {
    // _groupAdminList.clear();
    _groupAdminList.add(groupAdmin);
    notifyListeners();
  }

  // remove member from group
  void removeMemberFromGroup({required UserModel groupMember}) {
    _groupMembersList.remove(groupMember);
    notifyListeners();
  }

  // remove admin from group
  void removeAdminFromGroup({required UserModel groupAdmin}) {
    _groupAdminList.remove(groupAdmin);
    notifyListeners();
  }
}
