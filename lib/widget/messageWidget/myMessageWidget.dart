import 'package:chatchat/enums/enums.dart';
import 'package:chatchat/models/message_model.dart';
import 'package:chatchat/widget/displayMessageTipe.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

class MyMessageWidget extends StatelessWidget {
  const MyMessageWidget({
    super.key,
    required this.messageModel,
  });

  final MessageModel messageModel;

  @override
  Widget build(BuildContext context) {
    final dateTime = formatDate(messageModel.timeSent, [hh, ':', nn, ' ', am]);
    final isReplying = messageModel.repliedTo.isNotEmpty;
    // final senderName =
    //     messageModel.repliedTo == 'You' ? messageModel.senderName : 'You';

    return Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
              minWidth: MediaQuery.of(context).size.width * 0.3,
            ),
            child: Card(
                elevation: 5,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15))),
                color: Theme.of(context).cardColor,
                //padding: const EdgeInsets.all(8.0),
                // decoration: BoxDecoration(
                //   color: Theme.of(context).cardColor,
                //   borderRadius: BorderRadius.circular(8.0),
                // ),
                child: Stack(
                  children: [
                    Padding(
                      padding: messageModel.messageType == MessageEnum.text
                          ? const EdgeInsets.only(
                              left: 10.0, right: 10.0, top: 0.0, bottom: 15.0)
                          : const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          isReplying
                              ? Container(
                                  padding: const EdgeInsets.all(8.0),
                                  width: MediaQuery.of(context).size.width,
                                  //height: MediaQuery.of(context).size.height,
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
                                      child: Padding(
                                        padding: messageModel.messageType ==
                                                MessageEnum.text
                                            ? const EdgeInsets.all(8.0)
                                            : const EdgeInsets.fromLTRB(
                                                5.0, 5.0, 5.0, 25.0),
                                        child: Column(
                                          //mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              messageModel.repliedTo,
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
                                      )))
                              : const SizedBox.shrink(),
                          DisplayMessageType(
                              isReply: false,
                              maxLines: 1,
                              overFlow: TextOverflow.ellipsis,
                              message: messageModel.message,
                              type: messageModel.messageType,
                              color: Colors.white),
                          // Text(messageModel.message,
                          //     style: const TextStyle(
                          //         color: Colors.white, fontSize: 16)),
                        ],
                      ),
                    ),
                    Positioned(
                        bottom: 4,
                        right: 10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              dateTime,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 10,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Icon(
                              messageModel.isSeen ? Icons.done_all : Icons.done,
                              size: 15,
                              color: messageModel.isSeen
                                  ? Colors.green
                                  : Colors.black,
                            )
                          ],
                        ))
                  ],
                ))));
  }
}
