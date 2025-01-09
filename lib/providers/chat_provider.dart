import 'dart:io';

import 'package:chatchat/models/lastMessageModels.dart';
import 'package:chatchat/models/message_model.dart';
import 'package:chatchat/models/message_reply_model.dart';
import 'package:chatchat/models/user_model.dart';
import 'package:chatchat/utils/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ChatProvider extends ChangeNotifier {
  bool _isLoading = false;
  MessageReplyModel? _messageReplyModel;

  get isLoading => _isLoading;
  MessageReplyModel? get messageReplyModel => _messageReplyModel;

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setMessageReplyModel(MessageReplyModel? messageReplyModel) {
    _messageReplyModel = messageReplyModel;
    notifyListeners();
  }

  // firebase initialisation
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  // sent text message to firestore
  Future<void> sendTextMessage({
    required UserModel sender,
    required String message,
    required MessageEnum messageType,
    required String contacUid,
    required String contactName,
    required String contactImage,
    required String groupId,
    required Function onSuccess,
    required Function onError,
  }) async {
    setIsLoading(true);
    notifyListeners();
    try {
      var messageId = const Uuid().v4();
      //1. check if it's a message reply and add the relied message id to the message
      String repliedMessage = _messageReplyModel?.message ?? '';
      String repliedTo = _messageReplyModel == null
          ? ''
          : _messageReplyModel!.isMe
              ? 'You'
              : _messageReplyModel!.senderName;
      MessageEnum repliedTMessageType =
          _messageReplyModel?.messageType ?? MessageEnum.text;

      //2. UPDATE/SET THE MESSAGEMODEL CLASS
      final messageModel = MessageModel(
        senderUid: sender.uid,
        senderName: sender.name,
        senderImage: sender.image,
        contactUid: contacUid,
        timeSent: DateTime.now(),
        isSeen: false,
        repliedMessage: repliedMessage,
        repliedMessageType: repliedTMessageType,
        messageId: messageId,
        message: message,
        messageType: messageType,
        repliedTo: repliedTo,
        reactions: [],
      );

      //3. check if it's a group message and sent to the groucontact else to the contact
      if (groupId.isNotEmpty) {
        // handle group message
      } else {
        // handle contact message
        await handleMessageContactMessage(
          messageModel: messageModel,
          contactUid: contacUid,
          contactName: contactName,
          contactImage: contactImage,
          onSuccess: onSuccess,
          onError: onError,
        );

        // set message reply model to null
        setMessageReplyModel(null);
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  Future<void> handleMessageContactMessage(
      {required String contactUid,
      required String contactName,
      required String contactImage,
      required MessageModel messageModel,
      required Function onSuccess,
      required Function onError}) async {
    try {
      // 0. contact messageModel
      final contactMessageModel =
          messageModel.copyWith(userId: messageModel.senderUid);

      // 1. intialize the last message for the sender
      final senderLastMessage = LastMessageModel(
        message: messageModel.message,
        messageType: messageModel.messageType,
        contactUid: contactUid,
        senderUid: messageModel.senderUid,
        timeSent: messageModel.timeSent,
        contactName: contactName,
        contactImage: contactImage,
        isSeen: false,
      );

      // 2. initialize the last message for the receiver
      final receiverLastMessage = senderLastMessage.copyWith(
        contactImage: messageModel.senderImage,
        contactName: messageModel.senderName,
        contactUid: messageModel.senderUid,
      );

      // 3. send the message to sender firestore location
      await _firestore
          .collection(Constant.users)
          .doc(messageModel.senderUid)
          .collection(Constant.chats)
          .doc(contactUid)
          .collection(Constant.messages)
          .doc(messageModel.messageId)
          .set(messageModel.toMap());

      // 4. send the message to receiver firestore location
      await _firestore
          .collection(Constant.users)
          .doc(contactUid)
          .collection(Constant.chats)
          .doc(messageModel.senderUid)
          .collection(Constant.messages)
          .doc(messageModel.messageId)
          .set(contactMessageModel.toMap());

      // 5. update the last message for the sender
      await _firestore
          .collection(Constant.users)
          .doc(messageModel.senderUid)
          .collection(Constant.chats)
          .doc(contactUid)
          .set(senderLastMessage.toMap());

      // 6. update the last message for the receiver
      await _firestore
          .collection(Constant.users)
          .doc(contactUid)
          .collection(Constant.chats)
          .doc(messageModel.senderUid)
          .set(receiverLastMessage.toMap());

      // await _firestore.runTransaction((transaction) async {
      //   // 3. send the message to sender firestore location
      //   transaction.set(
      //     _firestore
      //         .collection(Constant.users)
      //         .doc(messageModel.senderUid)
      //         .collection(Constant.chats)
      //         .doc(contactUid)
      //         .collection(Constant.messages)
      //         .doc(messageModel.messageId),
      //     messageModel.toMap(),
      //   );

      //   // 4. send the message to receiver firestore location
      //   transaction.set(
      //     _firestore
      //         .collection(Constant.users)
      //         .doc(contactUid)
      //         .collection(Constant.chats)
      //         .doc(messageModel.senderUid)
      //         .collection(Constant.messages)
      //         .doc(messageModel.messageId),
      //     contactMessageModel.toMap(),
      //   );

      //   // 5. send the last message to sender firestore location
      //   transaction.set(
      //     _firestore
      //         .collection(Constant.users)
      //         .doc(messageModel.senderUid)
      //         .collection(Constant.chats)
      //         .doc(contactUid),
      //     senderLastMessage.toMap(),
      //   );

      //   // 6. send the last message to receiver firestore location
      //   transaction.set(
      //     _firestore
      //         .collection(Constant.users)
      //         .doc(contactUid)
      //         .collection(Constant.chats)
      //         .doc(messageModel.senderUid),
      //     receiverLastMessage.toMap(),
      //   );
      // });

      // set Loading to false
      setIsLoading(false);
      //notifyListeners();
      // 7. call the onSuccess function
      onSuccess();
    } on FirebaseException catch (e) {
      // set Loading to false
      setIsLoading(false);
      onError(e.message.toString());
    } catch (e) {
      // set Loading to false
      setIsLoading(false);
      onError(e.toString());
    }
  }

  // send reaction to message
  Future<void> sendReactionToMessage({
    required String senderUid,
    required String contactUid,
    required String messageId,
    required String reaction,
    required bool isGroup,
  }) async {
    // set Loading to true
    setIsLoading(true);
    // a reaction is saved as senderUID=reaction
    String reactionToAdd = '$senderUid=$reaction';

    try {
      // 1. check if it is a group message or not
      if (isGroup) {
        // TODO: send reaction to group message
        // 2. get the reaction list from the firestore
        final messageData = await _firestore
            .collection(Constant.groups)
            .doc(contactUid)
            .collection(Constant.messages)
            .doc(messageId)
            .get();

        // 3. add the message data to message model
        final message = MessageModel.fromMap(messageData.data()!);

        // 4. check if the reaction list is empty or not
        if (message.reactions.isEmpty) {
          // 5. if the reaction list is empty, add the reaction to the message
          await _firestore
              .collection(Constant.groups)
              .doc(contactUid)
              .collection(Constant.messages)
              .doc(messageId)
              .update({
            Constant.reactions: FieldValue.arrayUnion([reactionToAdd]),
          });
        } else {
          // 6. get UIDs list from the reaction list
          final uids = message.reactions.map((e) => e.split('=')[0]).toList();

          // 7. check if the reactions is already added or not
          if (uids.contains(senderUid)) {
            // 8. get the index of the reaction
            final index = uids.indexOf(senderUid);
            // 9. replace the reaction
            message.reactions[index] = reactionToAdd;
          } else {
            // 10. add the reaction to the message
            message.reactions.add(reactionToAdd);
          }

          // 11. update the message
          await _firestore
              .collection(Constant.groups)
              .doc(senderUid)
              .collection(Constant.messages)
              .doc(messageId)
              .update({
            Constant.reactions: message.reactions,
          });
        }
      } else {
        // handle contact message
        // 2. get the reaction list from the firestore
        final messageData = await _firestore
            .collection(Constant.users)
            .doc(senderUid)
            .collection(Constant.chats)
            .doc(contactUid)
            .collection(Constant.messages)
            .doc(messageId)
            .get();

        // 3. add the message data to message model
        final message = MessageModel.fromMap(messageData.data()!);
        // 4. check if the reaction list is empty or not
        if (message.reactions.isEmpty) {
          // 5. if the reaction list is empty, add the reaction to the message
          await _firestore
              .collection(Constant.users)
              .doc(senderUid)
              .collection(Constant.chats)
              .doc(contactUid)
              .collection(Constant.messages)
              .doc(messageId)
              .update({
            Constant.reactions: FieldValue.arrayUnion([reactionToAdd]),
          });
        } else {
          // 6. get UIDs list from the reaction list
          final uids = message.reactions.map((e) => e.split('=')[0]).toList();
          // 7. check if the reactions is already added or not
          if (uids.contains(senderUid)) {
            // 8. get the index of the reaction
            final index = uids.indexOf(senderUid);
            // 9. replace the reaction
            message.reactions[index] = reactionToAdd;
          } else {
            // 10. add the reaction to the message
            message.reactions.add(reactionToAdd);
          }
          // 11. update the message
          await _firestore
              .collection(Constant.users)
              .doc(senderUid)
              .collection(Constant.chats)
              .doc(contactUid)
              .collection(Constant.messages)
              .doc(messageId)
              .update({
            Constant.reactions: message.reactions,
          });

          // 12. update the message to contact firestore location
          await _firestore
              .collection(Constant.users)
              .doc(contactUid)
              .collection(Constant.chats)
              .doc(senderUid)
              .collection(Constant.messages)
              .doc(messageId)
              .update({
            Constant.reactions: message.reactions,
          });
        }
      }

      // set Loading to false
      setIsLoading(false);
    } catch (e) {
      // set Loading to false
      setIsLoading(false);
      print(e.toString());
    }
  }

  // get chat list stream
  Stream<List<LastMessageModel>> getChatListStream(String userId) {
    return _firestore
        .collection(Constant.users)
        .doc(userId)
        .collection(Constant.chats)
        .orderBy(Constant.timeSent, descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return LastMessageModel.fromMap(doc.data());
      }).toList();
    });
  }

  // get message stream from chat Collection
  Stream<List<MessageModel>> getMessagesStream({
    required String userId,
    required String contactId,
    required String isGroup,
  }) {
    // check if it's a group message or not
    if (isGroup.isNotEmpty) {
      return _firestore
          .collection(Constant.groups)
          .doc(contactId)
          .collection(Constant.messages)
          .orderBy(Constant.timeSent, descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return MessageModel.fromMap(doc.data());
        }).toList();
      });
    } else {
      return _firestore
          .collection(Constant.users)
          .doc(userId)
          .collection(Constant.chats)
          .doc(contactId)
          .collection(Constant.messages)
          .orderBy(Constant.timeSent, descending: false)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return MessageModel.fromMap(doc.data());
        }).toList();
      });
    }
  }

  // set message as seen
  Future<void> setMessageSeen(
      {required String userId,
      required String contactUid,
      required String messageId,
      required String groupId}) async {
    try {
      // 1. check if it's a group message or not
      if (groupId.isNotEmpty) {
        // handle group message
      } else {
        // handle user message
        // 2. update the current user message as seen
        await _firestore
            .collection(Constant.users)
            .doc(userId)
            .collection(Constant.chats)
            .doc(contactUid)
            .collection(Constant.messages)
            .doc(messageId)
            .update({Constant.isSeen: true});

        // 3. update the contact user message as seen
        await _firestore
            .collection(Constant.users)
            .doc(contactUid)
            .collection(Constant.chats)
            .doc(userId)
            .collection(Constant.messages)
            .doc(messageId)
            .update({Constant.isSeen: true});

        /// 4. update the last message for the current user
        await _firestore
            .collection(Constant.users)
            .doc(userId)
            .collection(Constant.chats)
            .doc(contactUid)
            .update({Constant.isSeen: true});
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // send image message to firestore
  Future<void> sendFileMessage({
    required UserModel sender,
    required String contactUid,
    required String contactName,
    required String contactImage,
    //required String messageId,
    required File file,
    //required String fileName,
    required MessageEnum messageType,
    required String groupId,
    required Function onSuccess,
    required Function(String) onError,
  }) async {
    // set is Loading to true
    setIsLoading(true);
    //notifyListeners();
    try {
      var messageId = const Uuid().v4();

      // 1 check if its a message reply and add the replied message to the message
      String repliedMessage = _messageReplyModel?.message ?? '';
      String repliedTo = _messageReplyModel == null
          ? ''
          : _messageReplyModel!.isMe
              ? 'You'
              : _messageReplyModel!.senderName;
      MessageEnum repliedTMessageType =
          _messageReplyModel?.messageType ?? MessageEnum.text;

      // 2. upload file to firebase storage
      final ref =
          '${Constant.chatFiles}/${messageType.name}/${sender.uid}/$contactUid/$messageId';
      String fileUrl = await storeFileToStorage(file: file, reference: ref);

      // 3. update/set the message model
      final messageModel = MessageModel(
        senderUid: sender.uid,
        senderName: sender.name,
        senderImage: sender.image,
        contactUid: contactUid,
        messageId: messageId,
        message: fileUrl,
        messageType: messageType,
        repliedTo: repliedTo,
        repliedMessageType: repliedTMessageType,
        timeSent: DateTime.now(),
        isSeen: false,
        repliedMessage: repliedMessage,
        reactions: [],
      );

      print("messageModel: $messageModel");
      // 4. check if its a group message and send the group else send the contact
      if (groupId.isNotEmpty) {
        // send group message
      } else {
        await handleMessageContactMessage(
            contactUid: contactUid,
            contactName: contactName,
            contactImage: contactImage,
            messageModel: messageModel,
            onSuccess: onSuccess,
            onError: onError);
      }

      // set message reply
      setMessageReplyModel(null);
    } catch (e) {
      onError(e.toString());
    }
  }

  // store File to storage and return file url
  Future<String> storeFileToStorage(
      {required File file, required String reference}) async {
    UploadTask uploadTask =
        _firebaseStorage.ref().child(reference).putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    String fileUrl = await taskSnapshot.ref.getDownloadURL();
    return fileUrl;
  }
}
