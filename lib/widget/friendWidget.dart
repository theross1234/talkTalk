import 'package:chatchat/enums/enums.dart';
import 'package:chatchat/models/user_model.dart';
import 'package:chatchat/providers/authenticationProvider.dart';
import 'package:chatchat/utils/constant.dart';
import 'package:chatchat/utils/global_method.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FriendWidget extends StatelessWidget {
  const FriendWidget({
    super.key,
    required this.friend,
    required this.viewType,
  });
  final UserModel friend;
  final FriendViewType viewType;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        minLeadingWidth: 0.0,
        leading:
            userImageWidget(imageUrl: friend.image, radius: 40, onTap: () {}),
        title: Text(friend.name),
        subtitle: Text(friend.aboutMe),
        trailing: viewType == FriendViewType.friendRequest
            ? IconButton(
                icon: const Icon(Icons.check),
                onPressed: () async {
                  await context
                      .read<AuthenticationProvider>()
                      .acceptFriendRequest(
                        friendId: friend.uid,
                      )
                      .whenComplete(() {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text("${Constant.friendAccepted}${friend.name}!")));
                  });
                })
            : viewType == FriendViewType.groupView
                ? Checkbox(
                    value: false,
                    onChanged: (value) {},
                  )
                : const SizedBox.shrink(),
        onTap: () async {
          viewType == FriendViewType.friend
              ? Navigator.pushNamed(context, Constant.chatscreen, arguments: {
                  Constant.contactUid: friend.uid,
                  Constant.contactName: friend.name,
                  Constant.contactImage: friend.image,
                  Constant.groupId: '',
                })
              : viewType == FriendViewType.allUsers
                  ? //Navigate to profile screen with uid as argument
                  Navigator.pushNamed(
                      context,
                      Constant.profileScreen,
                      arguments: friend.uid,
                    )
                  //await context
                  //     .read<AuthenticationProvider>()
                  //     .acceptFriendRequest(
                  //       friendId: user.uid,
                  //     )
                  //     .whenComplete(() {
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //         const SnackBar(
                  //             content: Text('friend Accepted')));
                  //   })
                  : ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('handle check')));
        });
  }
}
