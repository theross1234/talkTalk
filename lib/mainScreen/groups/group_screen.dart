import 'package:chatchat/mainScreen/groups/private_group_screen.dart';
import 'package:chatchat/mainScreen/groups/public_group_screen.dart';
import 'package:chatchat/utils/constant.dart';
import 'package:flutter/material.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
              title: TabBar(indicatorSize: TabBarIndicatorSize.tab, tabs: [
            Tab(
              text: Constant.private.toUpperCase(),
            ),
            Tab(
              text: Constant.public.toUpperCase(),
            ),
          ])),
          body: const TabBarView(children: [
            PrivateGroupScreen(),
            PublicGroupScreen(),
          ])),
    );
  }
}
