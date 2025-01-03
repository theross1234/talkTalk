import 'package:chatchat/utils/constant.dart';
import 'package:chatchat/widget/frienList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Friendrequestscreen extends StatefulWidget {
  const Friendrequestscreen({super.key});

  @override
  State<Friendrequestscreen> createState() => _FriendrequestscreenState();
}

class _FriendrequestscreenState extends State<Friendrequestscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Constant.friendRequestScreenAppTitle),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: CupertinoSearchTextField(
                  placeholder: "Search friends",
                  onChanged: (value) {
                    //TODO: Search the friend
                    //TODO: Navigate to the search result screen
                    //TODO: Navigate to the friend profile screen
                    //TODO: Navigate to the chat screen
                  },
                )),
            const Expanded(
                child: Frienlist(
              viewType: FriendViewType.friendRequest,
            )),
          ],
        ),
      ),
    );
  }
}
