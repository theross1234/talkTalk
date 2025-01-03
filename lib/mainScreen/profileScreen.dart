import 'package:chatchat/models/user_model.dart';
import 'package:chatchat/providers/authenticationProvider.dart';
import 'package:chatchat/utils/constant.dart';
import 'package:chatchat/utils/global_method.dart';
import 'package:chatchat/widget/CustomAppBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class Profilescreen extends StatefulWidget {
  const Profilescreen({super.key});

  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen> {
  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthenticationProvider>().userModel;
    DateTime lastSeen =
        DateTime.fromMillisecondsSinceEpoch(int.parse(currentUser!.lastSeen));
    // get data from the argument
    final uid = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: const Text(Constant.profile),
        leading: AppBarBackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        actions: [
          currentUser.uid == uid
              ? IconButton(
                  onPressed: () async {
                    //Navigate to the settings Screen with uid as argument
                    Navigator.pushNamed(context, Constant.settingScreen,
                        arguments: uid);
                  },
                  icon: const Icon(Icons.settings),
                )
              : const SizedBox(),
        ],
      ),
      body: StreamBuilder(
        stream: context.read<AuthenticationProvider>().userStream(userId: uid),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text(Constant.somethingWentWrong));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final userModel =
              UserModel.fromMap(snapshot.data!.data() as Map<String, dynamic>);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
            child: Column(children: [
              Center(
                child: userImageWidget(
                    imageUrl: userModel.image, radius: 70, onTap: () {}),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                userModel.name,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                userModel.isOnline
                    ? Constant.onLine
                    : "${Constant.lastSeenappBar} ${timeago.format(lastSeen)}",
                style: TextStyle(
                  fontSize: 12,
                  color: userModel.isOnline
                      ? Colors.green
                      : const Color.fromARGB(255, 202, 201, 201),
                ),
              ),
              // verify if we are in our profile and show phone number if we are
              currentUser.uid == uid
                  ? Text(
                      userModel.phoneNumber,
                      style: const TextStyle(fontSize: 20, color: Colors.grey),
                    )
                  : const SizedBox.shrink(),
              const SizedBox(
                height: 10,
              ),
              buildFriendRequestButton(
                  userModel: userModel, currentUser: currentUser),
              const SizedBox(
                height: 10,
              ),
              buildFriendButton(userModel: userModel, currentUser: currentUser),
              const SizedBox(
                height: 5,
              ),
              const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(
                    height: 40,
                    width: 40,
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    )),
                SizedBox(
                  width: 10,
                ),
                Text(
                  Constant.aboutMe,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                    height: 40,
                    width: 40,
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    )),
              ]),
              Text(
                userModel.aboutMe,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ]),
          );
        },
      ),
    );
  }

// Build a custom button widget to avoid repetition
  Widget buildCustomButton({
    required String text,
    required VoidCallback onPressed,
    required double widthFactor,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * widthFactor,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: backgroundColor,
            padding: const EdgeInsets.symmetric(vertical: 10)),
        child: Text(
          text.toUpperCase(),
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

// Build friend request button
  Widget buildFriendRequestButton({
    required UserModel currentUser,
    required UserModel userModel,
  }) {
    final bool isOwnProfile = currentUser.uid == userModel.uid;

    if (isOwnProfile && currentUser.receivefriendRequestsUids.isNotEmpty) {
      return buildCustomButton(
        text: Constant.viewfriendRequest,
        onPressed: () {
          // Navigate to the friend request screen
          Navigator.pushNamed(context, Constant.friendRequestScreen);
        },
        widthFactor: 0.7,
        backgroundColor: Theme.of(context).cardColor,
        textColor: Theme.of(context).colorScheme.primary,
      );
    }

    // Return an empty widget if no condition is met
    return const SizedBox.shrink();
  }

// Build friends button
  Widget buildFriendButton({
    required UserModel currentUser,
    required UserModel userModel,
  }) {
    final bool isOwnProfile = currentUser.uid == userModel.uid;

    if (isOwnProfile && currentUser.friendsUids.isNotEmpty) {
      return buildCustomButton(
        text: Constant.friendList,
        onPressed: () {
          // Navigate to the friend list screen
          Navigator.pushNamed(context, Constant.friendsScreen);
        },
        widthFactor: 0.7,
        backgroundColor: Theme.of(context).cardColor,
        textColor: Theme.of(context).colorScheme.primary,
      );
    } else if (isOwnProfile == false) {
      // show cancel friend request button if user sent friend request
      // else send friend request
      if (userModel.receivefriendRequestsUids.contains(currentUser.uid)) {
        return buildCustomButton(
          text: Constant.cancelFriendRequest,
          backgroundColor: Theme.of(context).cardColor,
          textColor: Theme.of(context).colorScheme.primary,
          onPressed: () async {
            await context
                .read<AuthenticationProvider>()
                .cancelFriendRequest(
                  receiverId: userModel.uid,
                )
                .whenComplete(() {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('friend request cancelled')));
            });
          },
          widthFactor: 0.7,
        );
      } else if (userModel.sentFriendRequestsUids.contains(currentUser.uid)) {
        return buildCustomButton(
          text: Constant.acceptFriendRequest,
          onPressed: () async {
            // Navigate to the friend request screen
            await context
                .read<AuthenticationProvider>()
                .acceptFriendRequest(
                  friendId: userModel.uid,
                )
                .whenComplete(() {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('friend Accepted')));
            });
          },
          //Navigator.pushNamed(context, Constant.friendRequestScreen)
          backgroundColor: Theme.of(context).buttonTheme.colorScheme!.primary,
          textColor: Theme.of(context).colorScheme.onPrimary,
          widthFactor: 0.7,
        );
      } else if (userModel.friendsUids.contains(currentUser.uid)) {
        return Row(
          children: [
            buildCustomButton(
                text: Constant.unFriend,
                onPressed: () async {
                  // show Dialog to ask the user if he is sure to remove friend
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text(Constant.sure),
                          content: const Text(Constant.sureAdvertise),
                          actions: [
                            TextButton(
                              child: const Text(Constant.cancel),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () async {
                                await context
                                    .read<AuthenticationProvider>()
                                    .removeFriend(
                                      friendId: userModel.uid,
                                    )
                                    .whenComplete(() {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(Constant.frienRemove)));
                                  Navigator.of(context).pop();
                                });
                              },
                            ),
                          ],
                        );
                      });
                },
                backgroundColor:
                    Theme.of(context).buttonTheme.colorScheme!.primary,
                textColor: Colors.white,
                widthFactor: 0.4),
            const SizedBox(width: 10),
            buildCustomButton(
                text: Constant.sendMessage,
                onPressed: () async {
                  // Navigate to the chat screen
                  Navigator.pushNamed(context, Constant.chatscreen, arguments: {
                    Constant.contactUid: userModel.uid,
                    Constant.contactName: userModel.name,
                    Constant.contactImage: userModel.image,
                    Constant.groupId: '',
                  });
                },
                backgroundColor: Theme.of(context).cardColor,
                textColor: Theme.of(context).primaryColor,
                widthFactor: 0.4)
          ],
        );
      } else {
        return buildCustomButton(
          text: Constant.sendfriendRequest,
          onPressed: () async {
            // Send friend request
            await context
                .read<AuthenticationProvider>()
                .sendFriendRequest(
                  receiverId: userModel.uid,
                )
                .whenComplete(() {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('friend request sent')),
              );
              //showSnackBar(context, 'friend request sent');
            });
            // Navigate to the sent friend requests screen
          },
          backgroundColor: Theme.of(context).cardColor,
          textColor: Theme.of(context).primaryColor,
          widthFactor: 0.7,
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }
}
