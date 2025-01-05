import 'package:chatchat/models/message_model.dart';
import 'package:chatchat/utils/constant.dart';
import 'package:chatchat/widget/displayMessageTipe.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';

class ContactMessageWidget extends StatelessWidget {
  const ContactMessageWidget(
      {super.key, required this.messageModel, required this.onRightSwipe});
  final MessageModel messageModel;
  final Function() onRightSwipe;

  @override
  Widget build(BuildContext context) {
    final dateTime = formatDate(messageModel.timeSent, [hh, ':', nn, ' ', am]);
    final isReplying = messageModel.repliedTo.isNotEmpty;
    final senderName =
        messageModel.repliedTo == 'You' ? messageModel.senderName : 'You';
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SwipeTo(
        animationDuration: const Duration(milliseconds: 200),
        onRightSwipe: (details) {
          onRightSwipe();
        },
        child: Align(
            alignment: Alignment.centerLeft,
            child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                  minWidth: MediaQuery.of(context).size.width * 0.3,
                  //minWidth: MediaQuery.of(context).size.height / 0.5,
                ),
                child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: messageModel.messageType == MessageEnum.text
                              ? const EdgeInsets.only(
                                  left: 10.0,
                                  right: 10.0,
                                  top: 0.0,
                                  bottom: 17.0)
                              : const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 25.0),
                          child: Column(
                            //mainAxisAlignment: MainAxisAlignment.start,

                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              isReplying
                                  ? Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.1),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12),
                                        ),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.1),
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(12),
                                              topRight: Radius.circular(12)),
                                        ),
                                        child: Column(
                                          //mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              senderName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            DisplayMessageType(
                                                isReply: false,
                                                maxLines: 1,
                                                overFlow: TextOverflow.ellipsis,
                                                message:
                                                    messageModel.repliedMessage,
                                                type: messageModel.messageType,
                                                color: Colors.white),
                                          ],
                                        ),
                                      ))
                                  : const SizedBox.shrink(),
                              DisplayMessageType(
                                  isReply: false,
                                  maxLines: 1,
                                  overFlow: TextOverflow.ellipsis,
                                  message: messageModel.message,
                                  type: messageModel.messageType,
                                  color: Colors.white),
                            ],
                          ),
                        ),
                        Positioned(
                            bottom: 4,
                            right: 10,
                            child: Row(
                              //mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  dateTime,
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.5),
                                    fontSize: 10,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                              ],
                            ))
                      ],
                    )))),
      ),
    );
  }
}
