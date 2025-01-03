import 'package:chatchat/models/lastMessageModels.dart';
import 'package:chatchat/providers/authenticationProvider.dart';
import 'package:chatchat/providers/chat_provider.dart';
import 'package:chatchat/utils/assetManager.dart';
import 'package:chatchat/utils/constant.dart';
import 'package:chatchat/utils/global_method.dart';
import 'package:chatchat/widget/frienList.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = context.read<AuthenticationProvider>().userModel!.uid;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
              Expanded(
                  child: StreamBuilder<List<LastMessageModel>>(
                      stream:
                          context.read<ChatProvider>().getChatListStream(uid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return const Center(
                              child: Text(
                            "Something went wrong",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ));
                        } else if (snapshot.hasData) {
                          if (snapshot.data!.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Lottie.asset(AssetsManager.pepeWaiting),
                                  const Text(Constant.noChat),
                                ],
                              ),
                            );
                          }
                          final chatlist = snapshot.data!;
                          return ListView.builder(
                              itemCount: chatlist.length,
                              itemBuilder: (context, index) {
                                final chat = chatlist[index];
                                final dateTime = formatDate(
                                    chat.timeSent, [hh, ':', nn, ' ', am]);
                                final isMe = chat.senderUid == uid;
                                final lastMessage = isMe
                                    ? 'you: ${chat.message}'
                                    : chat.message;
                                return ListTile(
                                  leading: userImageWidget(
                                      imageUrl: chat.contactImage,
                                      radius: 25,
                                      onTap: () {}),
                                  title: Text(chat.contactName),
                                  subtitle: messageToShow(
                                      messageType: chat.messageType,
                                      message: lastMessage),
                                  trailing: Text(dateTime.toString()),
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, Constant.chatscreen,
                                        arguments: {
                                          Constant.contactUid: chat.contactUid,
                                          Constant.contactName:
                                              chat.contactName,
                                          Constant.contactImage:
                                              chat.contactImage,
                                          Constant.groupId: ''
                                        });
                                  },
                                );
                              });
                        } else {
                          return const Center(
                            child: Text("No chat found"),
                          );
                        }
                      })),
            ],
          ),
        ),
      ),
    );
  }
}
