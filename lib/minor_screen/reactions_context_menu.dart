import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:chatchat/models/message_model.dart';
import 'package:chatchat/models/message_reply_model.dart';
import 'package:chatchat/providers/authenticationProvider.dart';
import 'package:chatchat/providers/chat_provider.dart';
import 'package:chatchat/widget/messageWidget/align_message_left_widget.dart';
import 'package:chatchat/widget/messageWidget/align_message_right_widget.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../utils/global_method.dart';

class ReactionsContextMenu extends StatefulWidget {
  const ReactionsContextMenu({
    super.key,
    required this.isMyMessage,
    required this.message,
    required this.contactUid,
    required this.groupId,
  });

  final bool isMyMessage;
  final MessageModel message;
  final String contactUid;
  final String groupId;

  @override
  State<ReactionsContextMenu> createState() => _ReactionsContextMenuState();
}

class _ReactionsContextMenuState extends State<ReactionsContextMenu> {
  bool reactionCliqued = false;
  int? reactionCliquedIndex;
  int? contextMenuCliquedIndex;

  Future<void> sendReactionToFirestore({
    required String reaction,
    required String messageId,
  }) async {
    // get the sender uid
    final senderUid = context.read<AuthenticationProvider>().userModel!.uid;
    await context.read<ChatProvider>().sendReactionToMessage(
        senderUid: senderUid,
        contactUid: widget.contactUid,
        messageId: messageId,
        reaction: reaction,
        isGroup: widget.groupId.isNotEmpty);
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
        showToast(context, message.message);
        break;
      case 'Delete':
        // TODO: delete message
        break;
    }
  }

  void showEmojiContainer({
    required String messageId,
    required String reaction,
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

  // void showEmojiContainer({
  //   required String messageId,
  //   required String reaction,
  // }) {
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (context) => SizedBox(
  //           height: 300,
  //           //color: Colors.white,
  //           child: EmojiPicker(
  //             onEmojiSelected: (category, emoji) {
  //               // add emoji to message
  //               Navigator.pop(context);
  //               sendReactionToFirestore(
  //                   reaction: emoji.emoji, messageId: messageId);
  //             },
  //           )));
  // }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Center(
          child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
                alignment: widget.isMyMessage == true
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Material(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade500,
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            )
                          ]),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (final reaction in reactions)
                            FadeInUp(
                              from: 5 + (reactions.indexOf(reaction) * 20),
                              duration: const Duration(milliseconds: 700),
                              child: InkWell(
                                  onTap: () async {
                                    setState(() {
                                      reactionCliqued = true;
                                      reactionCliquedIndex =
                                          reactions.indexOf(reaction);
                                    });
                                    if (reaction == '➕') {
                                      // showEmojiContainer(
                                      //     messageId: widget.message.messageId,
                                      //     reaction: reaction);
                                      Future.delayed(
                                          const Duration(milliseconds: 200),
                                          () {
                                        Navigator.of(context).pop('➕');
                                      });
                                    } else {
                                      await sendReactionToFirestore(
                                        reaction: reaction,
                                        messageId: widget.message.messageId,
                                      ).whenComplete(() {
                                        Navigator.pop(context);
                                      });
                                    }
                                  },
                                  child: Pulse(
                                    infinite: false,
                                    duration: const Duration(seconds: 1),
                                    animate: reactionCliqued &&
                                        reactionCliquedIndex ==
                                            reactions.indexOf(reaction),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        reaction,
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  )),
                            )
                        ],
                      ),
                    ),
                  ),
                )),
            const SizedBox(
              height: 10,
            ),
            widget.isMyMessage
                ? Hero(
                    tag: widget.message.messageId,
                    child: AlignMessageRightWidget(
                      message: widget.message,
                    ),
                  )
                : Hero(
                    tag: widget.message.messageId,
                    child: AlignMessageLeftWidget(
                      message: widget.message,
                    ),
                  ),
            Align(
                alignment: widget.isMyMessage == true
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Material(
                  color: const Color.fromRGBO(0, 0, 0, 0),
                  child: Padding(
                      padding: widget.isMyMessage == true
                          ? const EdgeInsets.only(left: 50, right: 10)
                          : const EdgeInsets.only(left: 10, right: 50),
                      child: FadeInRight(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: widget.isMyMessage == true
                                      ? Theme.of(context).cardColor
                                      : Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: const Offset(0, 1),
                                )
                              ]),
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: [
                              for (final menu in contextMenu)
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      contextMenuCliquedIndex =
                                          contextMenu.indexOf(menu);
                                    });
                                    Future.delayed(
                                        const Duration(milliseconds: 500), () {
                                      Navigator.of(context).pop(menu);
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          menu,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Pulse(
                                          infinite: false,
                                          duration: const Duration(seconds: 1),
                                          animate: contextMenuCliquedIndex ==
                                              contextMenu.indexOf(menu),
                                          child: Icon(
                                            menu == 'Reply'
                                                ? Icons.reply
                                                : menu == 'Copy'
                                                    ? Icons.copy
                                                    : Icons.delete,
                                            color: Colors.black,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ),
                      )),
                ))
          ],
        ),
      )),
    );
  }
}
