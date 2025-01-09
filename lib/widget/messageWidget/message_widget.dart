import 'package:chatchat/models/message_model.dart';
import 'package:chatchat/widget/messageWidget/contact_message_widget.dart';
import 'package:chatchat/widget/messageWidget/myMessageWidget.dart';
import 'package:chatchat/widget/messageWidget/swipeToWidget.dart';
import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({
    super.key,
    required this.messageModel,
    required this.onRightSwipe,
    required this.isViewOnly,
    required this.isMe,
  });

  final MessageModel messageModel;
  final Function() onRightSwipe;
  final bool isViewOnly;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    // final dateTime = formatDate(messageModel.timeSent, [hh, ':', nn, ' ', am]);
    // final isReplying = messageModel.repliedTo.isNotEmpty;

    return isMe
        ? isViewOnly
            ? MyMessageWidget(messageModel: messageModel)
            : SwipeToWidget(
                onRightSwipe: onRightSwipe,
                messageModel: messageModel,
                isMe: isMe,
              )
        : isViewOnly
            ? ContactMessageWidget(messageModel: messageModel)
            : SwipeToWidget(
                onRightSwipe: onRightSwipe,
                messageModel: messageModel,
                isMe: isMe,
              );
  }
}
