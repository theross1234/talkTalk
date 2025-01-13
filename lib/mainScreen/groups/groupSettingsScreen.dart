import 'package:chatchat/enums/enums.dart';
import 'package:chatchat/models/user_model.dart';
import 'package:chatchat/providers/group_provider.dart';
import 'package:chatchat/utils/constant.dart';
import 'package:chatchat/utils/global_method.dart';
import 'package:chatchat/widget/friendWidget.dart';
import 'package:chatchat/widget/settingsListTile.dart';
import 'package:chatchat/widget/settings_switch_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupSettingScreen extends StatefulWidget {
  const GroupSettingScreen({super.key});

  @override
  State<GroupSettingScreen> createState() => _GroupSettingScreenState();
}

class _GroupSettingScreenState extends State<GroupSettingScreen> {
  // get the group admins name
  String getGroupAdminsName({required GroupProvider groupProvider}) {
    if (groupProvider.groupMembersList.isEmpty) {
      return Constant.emptyGroupMember;
    } else {
      List<String> adminName = [Constant.you];
      for (int i = 0; i < groupProvider.groupAdminList.length; i++) {
        adminName.add(groupProvider.groupAdminList[i].name);
      }
      // if they are just two, separate them by 'and', if they are more than 2
      // sepaate them with comma + and before the last one
      if (adminName.length == 1) {
        return adminName.first;
      } else if (adminName.length == 2) {
        return adminName.join(" ${Constant.and} ");
      } else {
        return "${adminName.sublist(
              0,
              adminName.length - 1,
            ).join(", ")} ${Constant.and} ${adminName.last}";
      }
    }
  }

  Color getAdminsContainerColor({required GroupProvider groupProvider}) {
    if (groupProvider.groupMembersList.isEmpty) {
      return Theme.of(context).disabledColor;
    } else {
      return Theme.of(context).cardColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    // print group admn list
    List<UserModel> adminGroup = context.read<GroupProvider>().groupAdminList;
    print("group admin is: ${adminGroup.length}");
    //List<UserModel> adminFriend = context.watch<GroupProvider>().groupAdminList;
    return Scaffold(
      appBar: AppBar(
        title: const Text(Constant.groupSettings),
      ),
      body: Consumer<GroupProvider>(
        builder: (context, groupProvider, child) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            child: Column(
              children: [
                SettingsSwitchListTile(
                    title: Constant.editGroupSettings,
                    subTitle: Constant.settingSubltitle,
                    icon: Icons.edit,
                    containerColor: Theme.of(context).primaryColor,
                    value: groupProvider.editSettings,
                    onChanged: (value) {
                      groupProvider.setEditSettings(value: value);
                    }),
                const Divider(),
                SettingsSwitchListTile(
                    title: Constant.approveNewMembers,
                    subTitle: Constant.approveMembersSubtitle,
                    icon: Icons.approval,
                    containerColor: Colors.green,
                    value: groupProvider.approveNewMember,
                    onChanged: (value) {
                      groupProvider.setApproveNewMember(value: value);
                    }),
                const Divider(),
                groupProvider.approveNewMember
                    ? SettingsSwitchListTile(
                        title: Constant.requestsToJoin,
                        subTitle: Constant.requestsToJoinSubtitle,
                        icon: Icons.join_full,
                        containerColor: Colors.orange,
                        value: groupProvider.requestsToJoin,
                        onChanged: (value) {
                          groupProvider.setRequestsToJoin(value: value);
                        })
                    : const SizedBox.shrink(),
                const Divider(),
                SettingsSwitchListTile(
                    title: Constant.lockMessagesGroup,
                    subTitle: Constant.lockMessagesSubtitle,
                    icon: Icons.lock,
                    containerColor: Colors.grey,
                    value: groupProvider.lockMessages,
                    onChanged: (value) {
                      groupProvider.setLockMessages(value: value);
                    }),
                const Divider(),
                Card(
                  child: Settingslisttile(
                    title: Constant.groupAdmins,
                    subtitle:
                        "${getGroupAdminsName(groupProvider: groupProvider)}.",
                    icon: Icons.admin_panel_settings,
                    IconColor:
                        getAdminsContainerColor(groupProvider: groupProvider),
                    onTap: () {
                      // show bottom sheet to select admins
                      groupProvider.groupMembersList.isEmpty
                          ? showToast(context, Constant.emptyGroupMember)
                          : showBottomSheet(
                              backgroundColor: Colors.grey,
                              context: context,
                              builder: (context) {
                                return SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            Constant.selectAdmins,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                Constant.done,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ))
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                            itemCount: groupProvider
                                                .groupMembersList.length,
                                            itemBuilder: (context, index) {
                                              final friend = groupProvider
                                                  .groupMembersList[index];
                                              return FriendWidget(
                                                friend: friend,
                                                viewType:
                                                    FriendViewType.groupView,
                                                isAdminView: true,
                                              );
                                            }),
                                      )
                                    ]),
                                  ),
                                );
                              });
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Center(child: Text(" ---groups settings---")),
              ],
            ),
          );
        },
      ),
    );
  }
}
