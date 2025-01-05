import 'package:chatchat/models/message_model.dart';
import 'package:chatchat/utils/constant.dart';
import 'package:chatchat/utils/global_method.dart';
import 'package:flutter/material.dart';

class ReactionsDialog extends StatefulWidget {
  const ReactionsDialog(
      {super.key,
      required this.uid,
      required this.message,
      required this.onReactionTap,
      required this.onContextMenuTap});

  final String uid;
  final MessageModel message;
  final Function(String) onReactionTap;
  final Function(String) onContextMenuTap;

  @override
  State<ReactionsDialog> createState() => _ReactionsDialogState();
}

class _ReactionsDialogState extends State<ReactionsDialog> {
  @override
  Widget build(BuildContext context) {
    final isMyMessage = widget.uid == widget.message.senderUid;
    return Align(
      alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
                alignment:
                    isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
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
                            InkWell(
                              onTap: () {
                                widget.onReactionTap(reaction);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  reaction,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    //fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                )),
            Align(
                alignment:
                    isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
                child: Material(
                  color: const Color.fromRGBO(0, 0, 0, 0),
                  child: Padding(
                    padding: isMyMessage
                        ? const EdgeInsets.only(left: 50, right: 10)
                        : const EdgeInsets.only(left: 10, right: 50),
                    child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                            color: isMyMessage
                                ? Theme.of(context).cardColor
                                : Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.6),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: isMyMessage
                                    ? Theme.of(context).cardColor
                                    : Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: const Offset(0, 1),
                              )
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: widget.message.messageType == MessageEnum.text
                              ? Text(
                                  widget.message.message,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    //fontWeight: FontWeight.bold,
                                  ),
                                )
                              : widget.message.messageType == MessageEnum.video
                                  ? const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          color: Colors.grey,
                                          Icons.video_camera_back_sharp,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          style: TextStyle(color: Colors.grey),
                                          'video',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      ],
                                    )
                                  : widget.message.messageType ==
                                          MessageEnum.image
                                      ? const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              color: Colors.grey,
                                              Icons.image,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              style:
                                                  TextStyle(color: Colors.grey),
                                              'image',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            )
                                          ],
                                        )
                                      : widget.message.messageType ==
                                              MessageEnum.document
                                          ? const Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  color: Colors.grey,
                                                  Icons.file_copy,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                  'document',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                )
                                              ],
                                            )
                                          : const Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  color: Colors.grey,
                                                  Icons.audio_file,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                  'voice message',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                )
                                              ],
                                            ),
                        )),
                  ),
                )),
            Align(
                alignment:
                    isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
                child: Material(
                  color: const Color.fromRGBO(0, 0, 0, 0),
                  child: Padding(
                      padding: isMyMessage
                          ? const EdgeInsets.only(left: 50, right: 10)
                          : const EdgeInsets.only(left: 10, right: 50),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                            color: isMyMessage
                                ? Theme.of(context).cardColor
                                : Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.6),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: isMyMessage
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
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (final menu in contextMenu)
                              InkWell(
                                onTap: () {
                                  widget.onContextMenuTap(menu);
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
                                          color: Colors.white,
                                          fontSize: 16,
                                          //fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Icon(
                                        menu == 'Reply'
                                            ? Icons.reply
                                            : menu == 'Copy'
                                                ? Icons.copy
                                                : Icons.delete,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                          ],
                        ),
                      )),
                ))
          ],
        ),
      ),
    );
  }
}
