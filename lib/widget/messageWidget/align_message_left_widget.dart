import 'package:chatchat/models/message_model.dart';
import 'package:chatchat/utils/constant.dart';
import 'package:chatchat/widget/displayMessageTipe.dart';
import 'package:chatchat/widget/stacked_reactions.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

class AlignMessageLeftWidget extends StatelessWidget {
  const AlignMessageLeftWidget({
    super.key,
    required this.message,
    this.viewOnly = false,
  });

  final MessageModel message;
  final bool viewOnly;

  @override
  Widget build(BuildContext context) {
    final time = formatDate(message.timeSent, [hh, ':', nn, ' ', am]);
    //final isReplying = message.repliedTo.isNotEmpty;
    // get the reations from the list
    // final messageReations =
    //     message.reactions.map((e) => e.split('=')[1]).toList();
    // check if its dark mode
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final padding = message.reactions.isNotEmpty
        ? const EdgeInsets.only(right: 20.0, bottom: 25.0)
        : const EdgeInsets.only(bottom: 0.0);
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
            minWidth: MediaQuery.of(context).size.width * 0.3,
          ),
          child: Stack(
            children: [
              Padding(
                padding: padding,
                child: Card(
                  elevation: 5,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  color: Theme.of(context).primaryColor,
                  child: Padding(
                    padding: message.messageType == MessageEnum.text
                        ? const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0)
                        : const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 10.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //if (isReplying) ...[const MessageReplyPreview()],
                          DisplayMessageType(
                            message: message.message,
                            type: message.messageType,
                            color: isDarkMode ? Colors.white : Colors.black,
                            isReply: false,
                            //viewOnly: viewOnly,
                          ),
                          Text(
                            time,
                            style: TextStyle(
                                color: isDarkMode
                                    ? Colors.white60
                                    : Colors.grey.shade500,
                                fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 50,
                child: StackedReactions(
                  size: 16,
                  message: message,
                  onReactionTap: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
