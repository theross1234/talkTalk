import 'package:chatchat/minor_screen/reactions_context_menu.dart';
import 'package:chatchat/models/message_model.dart';
import 'package:chatchat/models/message_reply_model.dart';
import 'package:chatchat/providers/authenticationProvider.dart';
import 'package:chatchat/providers/chat_provider.dart';
import 'package:chatchat/utils/constant.dart';
import 'package:chatchat/utils/global_method.dart';
import 'package:chatchat/utils/hero_dialog_route.dart';
import 'package:chatchat/widget/messageWidget/message_widget.dart';
import 'package:chatchat/widget/reactions_dialog.dart';
import 'package:chatchat/widget/stacked_reactions.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  void onContextMenuClicked({required item, required message}) {
    //isMe = context.read<AuthenticationProvider>().userModel!.uid ==
    message.senderUid;
    print("/././././././. $item /././././././.");
    switch (item) {
      case 'Reply':
        final messageReply = MessageReplyModel(
          message: message.message,
          senderName: message.senderName,
          senderUid: message.senderUid,
          senderImage: message.senderImage,
          messageType: message.messageType,
          isMe: true,
        );
        context.read<ChatProvider>().setMessageReplyModel(messageReply);
        break;
      case 'Copy':
        Clipboard.setData(ClipboardData(text: message.message));
        // showSimpleSnackBar(
        //   context: context,
        //   message: 'Message copied to clipBoard',
        // );
        //showSnackBar(context, content: message.message);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("copy to clipboard"),
          ),
        );
        break;
      case 'Delete':
        // TODO: delete message
        showToast(context, 'Message deleted');
        break;
    }
  }

  showReactionsDialog({required MessageModel message, required bool isMe}) {
    showDialog(
        context: context,
        builder: (context) => ReactionsDialog(
            isMyMessage: isMe,
            message: message,
            onReactionTap: (reaction) {
              if (reaction == '➕') {
                Navigator.pop(context);
                // show emoji keyboard
                showEmojiContainer(messageId: message.messageId);
                //Navigator.pop(context);
              } else {
                // add reaction to message
                sendReactionToFirestore(
                    reaction: reaction, messageId: message.messageId);
                Future.delayed(const Duration(milliseconds: 500), () {
                  Navigator.pop(context);
                  //print("$reaction is selected");
                  // if it's a plus reaction show bottom sheet with emojis keyboard
                });
              }
            },
            onContextMenuTap: (item) {
              Future.delayed(const Duration(milliseconds: 500), () {
                Navigator.pop(context);
                onContextMenuClicked(item: item, message: message);
              });
            }));
  }

  void sendReactionToFirestore({
    required String reaction,
    required String messageId,
  }) {
    // get the sender uid
    final senderUid = context.read<AuthenticationProvider>().userModel!.uid;
    context.read<ChatProvider>().sendReactionToMessage(
        senderUid: senderUid,
        contactUid: widget.contactUid,
        messageId: messageId,
        reaction: reaction,
        isGroup: widget.groupId.isNotEmpty);
  }

  void showEmojiContainer({
    required String messageId,
    //required String reaction,
  }) {
    showModalBottomSheet(
        context: context,
        builder: (context) => SizedBox(
            height: 300,
            //color: Colors.white,
            child: EmojiPicker(
              onEmojiSelected: (category, emoji) {
                // add emoji to message
                Navigator.pop(context);
                sendReactionToFirestore(
                    reaction: emoji.emoji, messageId: messageId);
              },
            )));
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
          if (snapshot.hasData) {
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
                final paddingReaction = element.reactions.isEmpty ? 0.0 : 20.0;
                //final paddingReaction2 = element.reactions.isEmpty ? 0.0 : 20.0;
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
                return Stack(
                  children: [
                    InkWell(
                      onLongPress: () async {
                        //showReactionsDialog(message: element, isMe: isMe);
                        String? item = await Navigator.of(context)
                            .push(HeroDialogRoute(builder: (context) {
                          return ReactionsContextMenu(
                            isMyMessage: isMe,
                            message: element,
                            contactUid: widget.contactUid,
                            groupId: widget.groupId,
                          );
                        }));
                        if (item == null) return;

                        if (item == '➕') {
                          Future.delayed(const Duration(milliseconds: 200), () {
                            print("/././././. $item /././././.");
                            // on show emoji picker
                            showEmojiContainer(messageId: element.messageId);
                          });
                        } else {
                          print("/././././. $item /././././.");
                          Future.delayed(const Duration(milliseconds: 200), () {
                            // on context menu clicked
                            onContextMenuClicked(item: item, message: element);
                            // switch (item) {
                            //   case 'Reply':
                            //     final messageReply = MessageReplyModel(
                            //       message: element.message,
                            //       senderName: element.senderName,
                            //       senderUid: element.senderUid,
                            //       senderImage: element.senderImage,
                            //       messageType: element.messageType,
                            //       isMe: true,
                            //     );
                            //     context
                            //         .read<ChatProvider>()
                            //         .setMessageReplyModel(messageReply);
                            //     break;
                            //   case 'Copy':
                            //     Clipboard.setData(
                            //         ClipboardData(text: element.message));
                            //     // showSimpleSnackBar(
                            //     //   context: context,
                            //     //   message: 'Message copied to clipBoard',
                            //     // );
                            //     showSnackBar(context,
                            //         content: "Message copied to clipBoard");
                            //     break;
                            //   case 'Delete':
                            //     // TODO: delete message
                            //     showSnackBar(context,
                            //         content: "Message supprime");
                            //     break;
                            // }
                          });
                        }

                        // //value = true;
                        // if (value != null && value) {
                        //   showEmojiContainer(
                        //       messageId: element.messageId,
                        //       reaction: element.reactions.first.reaction);
                        // }
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 8.0,
                          bottom: paddingReaction,
                          //right: 2.0,
                        ),
                        child: Hero(
                          tag: element.messageId,
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
                            isViewOnly: false,
                            isMe: isMe,
                          ),
                        ),
                      ),
                    ),
                    isMe
                        ? Positioned(
                            bottom: 3,
                            right: 10,
                            //left: isMe ? null : 20,
                            child: StackedReactions(
                              message: element,
                              size: 17,
                              onReactionTap: () {
                                // TODO: show bottom sheet with list of people who reacted
                              },
                            )
                            //: const SizedBox.shrink(),
                            )
                        : Positioned(
                            bottom: 7,
                            left: 20,
                            child: StackedReactions(
                              message: element,
                              size: 17,
                              onReactionTap: () {
                                // TODO: show bottom sheet with list of people who reacted
                              },
                            )
                            //: const SizedBox.shrink(),
                            )
                  ],
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
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
