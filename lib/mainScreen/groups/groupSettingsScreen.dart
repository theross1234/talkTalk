import 'package:chatchat/providers/group_provider.dart';
import 'package:chatchat/utils/constant.dart';
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
  @override
  Widget build(BuildContext context) {
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
                      subtitle: "You, Ross, Ross and Ross",
                      onTap: () {
                        // show bottom sheet to select admins
                      },
                      icon: Icons.admin_panel_settings,
                      IconColor: Colors.black),
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
