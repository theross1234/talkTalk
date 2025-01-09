import 'package:chatchat/enums/enums.dart';
import 'package:chatchat/utils/constant.dart';
import 'package:chatchat/widget/CustomAppBar.dart';
import 'package:chatchat/widget/frienList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Friendscreen extends StatefulWidget {
  const Friendscreen({super.key});

  @override
  State<Friendscreen> createState() => _FriendscreenState();
}

class _FriendscreenState extends State<Friendscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBarBackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(Constant.friendScreenAppTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: CupertinoSearchTextField(
                  placeholder: Constant.searchFriend,
                  onChanged: (value) {
                    //TODO: Search the friend
                    //TODO: Navigate to the search result screen
                    //TODO: Navigate to the friend profile screen
                    //TODO: Navigate to the chat screen
                  },
                )),
            const Expanded(
                child: Frienlist(
              viewType: FriendViewType.friend,
            )),
          ],
        ),
      ),
    );
  }
}
