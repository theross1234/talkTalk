import 'package:chatchat/models/message_reply_model.dart';
import 'package:chatchat/providers/authenticationProvider.dart';
import 'package:chatchat/providers/chat_provider.dart';
import 'package:chatchat/utils/constant.dart';
import 'package:chatchat/utils/global_method.dart';
import 'package:chatchat/widget/contact_message_widget.dart';
import 'package:chatchat/widget/message_widget.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';

class Chatlist extends StatefulWidget {
  final String contactUid;

  final String groupId;

  const Chatlist({super.key, required this.contactUid, required this.groupId});

  @override
  State<Chatlist> createState() => _ChatlistState();
}

class _ChatlistState extends State<Chatlist> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserid = context.read<AuthenticationProvider>().userModel!.uid;
    return StreamBuilder(
        stream: context.read<ChatProvider>().getMessagesStream(
            userId: currentUserid,
            contactId: widget.contactUid,
            isGroup: widget.groupId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text(Constant.somethingWentWrong));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.isEmpty) {
            return const Center(
                child: Text(Constant.noMessageYet,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)));
          }

          // automaticcally scroll to the bottom on new message
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollController.animateTo(
                _scrollController.position.minScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut);
          });

          final MessageList = snapshot.data!;
          return GroupedListView<dynamic, DateTime>(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            reverse: true,
            elements: MessageList,
            controller: _scrollController,
            groupBy: (element) {
              return DateTime(element.timeSent!.year, element.timeSent!.month,
                  element.timeSent!.day);
            },
            groupHeaderBuilder: (dynamic groupByValue) =>
                buildDateTimeHeader(groupByValue),
            itemBuilder: (context, dynamic element) {
              // set the message as seen
              if (!element.isSeen && element.senderUid != currentUserid) {
                //print("%%%%%% runningi set message seen %%%%%%");
                context.read<ChatProvider>().setMessageSeen(
                    groupId: widget.groupId,
                    messageId: element.messageId,
                    contactUid: widget.contactUid,
                    userId: currentUserid);
              }
              // check if we send the last message
              final isMe = element.senderUid == currentUserid;
              return isMe
                  ? Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: MessageWidget(
                        messageModel: element,
                        onRightSwipe: () {
                          // set the message reply to true
                          final messageReply = MessageReplyModel(
                            message: element.message,
                            senderName: element.senderName,
                            senderUid: element.senderUid,
                            senderImage: element.senderImage,
                            messageType: element.messageType,
                            isMe: isMe,
                          );
                          context
                              .read<ChatProvider>()
                              .setMessageReplyModel(messageReply);
                          // CustomSnackBar.show(
                          //     context: context, message: "message swippe");
                        },
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ContactMessageWidget(
                        messageModel: element,
                        onRightSwipe: () {
                          // set the message reply to true
                          final messageReply = MessageReplyModel(
                            message: element.message,
                            senderName: element.senderName,
                            senderUid: element.senderUid,
                            senderImage: element.senderImage,
                            messageType: element.messageType,
                            isMe: isMe,
                          );
                          context
                              .read<ChatProvider>()
                              .setMessageReplyModel(messageReply);
                          // CustomSnackBar.show(
                          //     context: context, message: "message swippe");
                        },
                      ),
                    );
            },
            groupComparator: (value1, value2) {
              return value2.compareTo(value1);
            },
            itemComparator: (item1, item2) {
              var firstItem = item1.timeSent;
              var secondItem = item2.timeSent;
              return secondItem!.compareTo(firstItem!);
            }, // optional
            useStickyGroupSeparators: true, // optional
            floatingHeader: true, // optional
            order: GroupedListOrder.ASC, // optional
            // footer:
            //     Text("Widget at the bottom of list"), // optional
          );
        });
  }
}
