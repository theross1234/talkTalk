import 'package:chatchat/models/user_model.dart';
import 'package:chatchat/providers/authenticationProvider.dart';
import 'package:chatchat/utils/constant.dart';
import 'package:chatchat/utils/global_method.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class Chatappbar extends StatefulWidget {
  final String contactUid;

  const Chatappbar({super.key, required this.contactUid});

  @override
  State<Chatappbar> createState() => _ChatappbarState();
}

class _ChatappbarState extends State<Chatappbar> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: context
          .read<AuthenticationProvider>()
          .userStream(userId: widget.contactUid),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text(Constant.somethingWentWrong));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final userModel =
            UserModel.fromMap(snapshot.data!.data() as Map<String, dynamic>);
        DateTime lastSeen =
            DateTime.fromMillisecondsSinceEpoch(int.parse(userModel.lastSeen));
        return Row(
          children: [
            userImageWidget(
                imageUrl: userModel.image,
                radius: 20,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Constant.profileScreen,
                    arguments: userModel.uid,
                  );
                }),
            const SizedBox(width: 10),
            Column(
              //mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userModel.name, style: const TextStyle(fontSize: 18)),
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
                )
              ],
            ),
          ],
        );
      },
    );
  }
}
