import 'package:chatchat/utils/assetManager.dart';
import 'package:chatchat/utils/constant.dart';
import 'package:chatchat/widget/bottomChatField.dart';
import 'package:chatchat/widget/chatAppBar.dart';
import 'package:chatchat/widget/chatList.dart';
import 'package:flutter/material.dart';

class Chatscreen extends StatefulWidget {
  const Chatscreen({super.key});

  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  late ImageProvider _backgroundImage;

  @override
  void initState() {
    super.initState();
    // Précharge l'image pour un affichage instantané
    _backgroundImage = const AssetImage(AssetsManager.chatPattern);
    //precacheImage(_backgroundImage, context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Precache the image once context is available
    precacheImage(_backgroundImage, context);
  }

  @override
  Widget build(BuildContext context) {
    //final currentUserid = context.read<AuthenticationProvider>().userModel!.uid;
    // Obtenir les arguments de l'écran précédent
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final contactUid = args[Constant.contactUid];
    final contactName = args[Constant.contactName];
    final contactImage = args[Constant.contactImage];
    final groupId = args[Constant.groupId];

    // Vérifier si c'est un chat de groupe
    final isGroupChat = groupId!.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title: Chatappbar(contactUid: contactUid),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: _backgroundImage,
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(child: Chatlist(contactUid: contactUid, groupId: groupId)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: BottomChatField(
                contactUId: contactUid,
                contactName: contactName,
                groupId: groupId,
                contactImage: contactImage,
              ),
            )
          ],
        ),
      ),
    );
  }
}
