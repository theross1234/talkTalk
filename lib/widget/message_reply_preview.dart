import 'package:chatchat/providers/chat_provider.dart';
import 'package:chatchat/utils/constant.dart';
import 'package:chatchat/utils/global_method.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageReplyPreview extends StatelessWidget {
  const MessageReplyPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder:
          (BuildContext context, ChatProvider chatProvider, Widget? child) {
        final messageReply = chatProvider.messageReplyModel;
        final isMe = messageReply!.isMe;
        final messageType = messageReply.messageType;

        return Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isMe
                    ? Theme.of(context).primaryColor.withOpacity(0.2)
                    : Theme.of(context).cardColor,
              ),
              child: ListTile(
                  trailing: IconButton(
                      onPressed: () {
                        chatProvider.setMessageReplyModel(null);
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.black,
                      )),
                  title: Text(
                    isMe ? Constant.you : messageReply.senderName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: messageToShow(
                    messageType: messageType,
                    message: messageReply.message,
                  )),
            ));
      },
    );
  }
}
