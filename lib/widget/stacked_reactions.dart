import 'package:chatchat/models/message_model.dart';
import 'package:flutter/material.dart';

class StackedReactions extends StatelessWidget {
  const StackedReactions({
    super.key,
    required this.size,
    required this.message,
    //required this.reaction,
    required this.onReactionTap,
  });

  final MessageModel message;
  final double size;
  //final String reaction;
  final Function() onReactionTap;

  @override
  Widget build(BuildContext context) {
    // get the reaction from the list
    final messageReactions =
        message.reactions!.map((e) => e.split('=')[1]).toList();
    // if reactions are more than 5, get the the first 5 reactions
    final ReactionToShow = messageReactions.length > 5
        ? messageReactions.sublist(0, 5)
        : messageReactions;

    // get the count of the remaining reactions
    final remainingReactions = messageReactions.length - ReactionToShow.length;
    final allReactions = ReactionToShow.asMap()
        .map((index, reaction) {
          final value = Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: Container(
              margin: EdgeInsets.only(left: index * 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.white,
                // boxShadow: const [
                //   BoxShadow(
                //     //color: Colors.grey.withOpacity(0.5),
                //     spreadRadius: 1,
                //     blurRadius: 2,
                //     offset: Offset(0, 1),
                //   )
                // ]
              ),
              child: ClipOval(
                child: Text(
                  reaction,
                  style: TextStyle(
                    fontSize: size,
                  ),
                ),
              ),
            ),
          );
          return MapEntry(index, value);
        })
        .values
        .toList();
    return GestureDetector(
      onTap: onReactionTap(),
      child: Row(
        children: [
          Stack(children: allReactions),
          // show this only if the remaining reactions are more than 0
          if (remainingReactions > 0) ...[
            Positioned(
              left: 100,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  // boxShadow: const [
                  //   BoxShadow(
                  //     color: Colors.grey,
                  //     spreadRadius: 1,
                  //     blurRadius: 2,
                  //     offset: Offset(0, 1),
                  //   )
                  // ]
                ),
                child: ClipOval(
                  child: Text(
                    '+$remainingReactions',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            )
          ]
        ],
      ),
      // show this only if the remaining reactions are more than 0
    );
  }
}
