import 'package:chatchat/models/message_model.dart';
import 'package:chatchat/widget/messageWidget/contact_message_widget.dart';
import 'package:chatchat/widget/messageWidget/myMessageWidget.dart';
import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';

class SwipeToWidget extends StatelessWidget {
  const SwipeToWidget({
    super.key,
    required this.onRightSwipe,
    required this.messageModel,
    // required this.isReplying,
    // required this.dateTime,
    required this.isMe,
  });

  final Function() onRightSwipe;
  final MessageModel messageModel;
  // final bool isReplying;
  // final String dateTime;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return SwipeTo(
      animationDuration: const Duration(milliseconds: 200),
      onRightSwipe: (details) {
        onRightSwipe();
      },
      child: isMe
          ? MyMessageWidget(messageModel: messageModel)
          : ContactMessageWidget(messageModel: messageModel),
    );
  }
}
