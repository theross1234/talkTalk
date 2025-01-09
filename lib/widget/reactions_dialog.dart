import 'package:animate_do/animate_do.dart';
import 'package:chatchat/models/message_model.dart';
import 'package:chatchat/utils/global_method.dart';
import 'package:chatchat/widget/messageWidget/align_message_left_widget.dart';
import 'package:chatchat/widget/messageWidget/align_message_right_widget.dart';
import 'package:flutter/material.dart';

class ReactionsDialog extends StatefulWidget {
  const ReactionsDialog(
      {super.key,
      required this.isMyMessage,
      required this.message,
      required this.onReactionTap,
      required this.onContextMenuTap});

  final bool isMyMessage;
  final MessageModel message;
  final Function(String) onReactionTap;
  final Function(String) onContextMenuTap;

  @override
  State<ReactionsDialog> createState() => _ReactionsDialogState();
}

class _ReactionsDialogState extends State<ReactionsDialog> {
  bool reactionCliqued = false;
  int? reactionCliquedIndex;
  int? contextMenuCliquedIndex;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          widget.isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
                alignment: Alignment.centerRight,
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
                                  onTap: () {
                                    widget.onReactionTap(reaction);
                                    setState(() {
                                      reactionCliqued = true;
                                      reactionCliquedIndex =
                                          reactions.indexOf(reaction);
                                    });
                                    Future.delayed(const Duration(seconds: 1),
                                        () {
                                      setState(() {
                                        reactionCliqued = false;
                                      });
                                    });
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
            // Align(
            //     alignment: widget.isMyMessage
            //         ? Alignment.centerRight
            //         : Alignment.centerLeft,
            //     child: Material(
            //       color: const Color.fromRGBO(0, 0, 0, 0),
            //       child: Padding(
            //         padding: widget.isMyMessage == true
            //             ? const EdgeInsets.only(left: 50, right: 10)
            //             : const EdgeInsets.only(left: 10, right: 50),
            //         child: Container(
            //             margin: const EdgeInsets.symmetric(vertical: 10),
            //             decoration: BoxDecoration(
            //                 color: widget.isMyMessage == true
            //                     ? Theme.of(context).cardColor
            //                     : Theme.of(context)
            //                         .primaryColor
            //                         .withOpacity(0.6),
            //                 borderRadius: BorderRadius.circular(10),
            //                 boxShadow: [
            //                   BoxShadow(
            //                     color: widget.isMyMessage == true
            //                         ? Theme.of(context).cardColor
            //                         : Theme.of(context)
            //                             .primaryColor
            //                             .withOpacity(0.1),
            //                     spreadRadius: 1,
            //                     blurRadius: 1,
            //                     offset: const Offset(0, 1),
            //                   )
            //                 ]),
            //             child: Padding(
            //               padding: const EdgeInsets.all(8.0),
            //               child: widget.message.messageType == MessageEnum.text
            //                   ? Text(
            //                       widget.message.message,
            //                       style: const TextStyle(
            //                         fontSize: 16,
            //                         color: Colors.white,
            //                       ),
            //                     )
            //                   : widget.message.messageType == MessageEnum.video
            //                       ? const Row(
            //                           mainAxisSize: MainAxisSize.min,
            //                           children: [
            //                             Icon(
            //                               color: Colors.grey,
            //                               Icons.video_camera_back_sharp,
            //                             ),
            //                             SizedBox(
            //                               width: 5,
            //                             ),
            //                             Text(
            //                               style: TextStyle(color: Colors.grey),
            //                               'video',
            //                               maxLines: 1,
            //                               overflow: TextOverflow.ellipsis,
            //                             )
            //                           ],
            //                         )
            //                       : widget.message.messageType ==
            //                               MessageEnum.image
            //                           ? const Row(
            //                               mainAxisSize: MainAxisSize.min,
            //                               children: [
            //                                 Icon(
            //                                   color: Colors.grey,
            //                                   Icons.image,
            //                                 ),
            //                                 SizedBox(
            //                                   width: 5,
            //                                 ),
            //                                 Text(
            //                                   style:
            //                                       TextStyle(color: Colors.grey),
            //                                   'image',
            //                                   maxLines: 1,
            //                                   overflow: TextOverflow.ellipsis,
            //                                 )
            //                               ],
            //                             )
            //                           : widget.message.messageType ==
            //                                   MessageEnum.document
            //                               ? const Row(
            //                                   mainAxisSize: MainAxisSize.min,
            //                                   children: [
            //                                     Icon(
            //                                       color: Colors.grey,
            //                                       Icons.file_copy,
            //                                     ),
            //                                     SizedBox(
            //                                       width: 5,
            //                                     ),
            //                                     Text(
            //                                       style: TextStyle(
            //                                           color: Colors.grey),
            //                                       'document',
            //                                       maxLines: 1,
            //                                       overflow:
            //                                           TextOverflow.ellipsis,
            //                                     )
            //                                   ],
            //                                 )
            //                               : const Row(
            //                                   mainAxisSize: MainAxisSize.min,
            //                                   children: [
            //                                     Icon(
            //                                       color: Colors.grey,
            //                                       Icons.audio_file,
            //                                     ),
            //                                     SizedBox(
            //                                       width: 5,
            //                                     ),
            //                                     Text(
            //                                       style: TextStyle(
            //                                           color: Colors.grey),
            //                                       'voice message',
            //                                       maxLines: 1,
            //                                       overflow:
            //                                           TextOverflow.ellipsis,
            //                                     )
            //                                   ],
            //                                 ),
            //             )),
            //       ),
            //     )),
            Align(
                alignment: Alignment.centerRight,
                child: widget.isMyMessage
                    ? FadeInRight(
                        duration: const Duration(milliseconds: 500),
                        child: AlignMessageRightWidget(
                          message: widget.message,
                        ),
                      )
                    : FadeInLeft(
                        duration: const Duration(milliseconds: 200),
                        child: AlignMessageLeftWidget(
                          message: widget.message,
                        ),
                      )),
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
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              for (final menu in contextMenu)
                                InkWell(
                                  onTap: () {
                                    widget.onContextMenuTap(menu);
                                    setState(() {
                                      contextMenuCliquedIndex =
                                          contextMenu.indexOf(menu);
                                    });
                                    // Future.delayed(const Duration(seconds: 1),
                                    //     () {
                                    //   setState(() {
                                    //     contextMenuCliqued = false;
                                    //   });
                                    // });
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
      ),
    );
  }
}
