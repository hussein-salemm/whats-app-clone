// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_ui/core/enums/message_enum.dart';
import 'package:whatsapp_ui/core/utils/utils.dart';
import 'package:whatsapp_ui/models/chat_contact.dart';

import '../../../models/user_model.dart';

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  ChatRepository({
    required this.firestore,
    required this.auth,
  });

  void _saveDataToContactSubcollection(
    UserModel senderUserData,
    UserModel recieverUserData,
    String text,
    DateTime timeSent,
    String recieverUserId,
  ) async {
    //users -> reciever userId  -> chats -> current user id -> set data
    var recieverChatContact = ChatContact(
      name: senderUserData.name,
      profilePic: senderUserData.profilePic,
      contactId: senderUserData.uid,
      timeSent: timeSent,
      lastMEssage: text,
    );
    await firestore
        .collection('users')
        .doc(recieverUserId)
        .collection('chats')
        .doc(
          auth.currentUser!.uid,
        )
        .set(
          recieverChatContact.toMap(),
        );
    //users -> current userId  -> chats -> receiver user id -> set data
    var senderChatContact = ChatContact(
      name: recieverUserData.name,
      profilePic: recieverUserData.profilePic,
      contactId: recieverUserData.uid,
      timeSent: timeSent,
      lastMEssage: text,
    );
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(
          recieverUserId,
        )
        .set(
          senderChatContact.toMap(),
        );
  }

  void _saveMessageToMessageSubcollection({
    required String reciecverUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String userName,
    required String recieverUserName,
    required MessageEnum messageType,
  }) async {}

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String recieverUserId,
    required UserModel senderUser,
  }) async {
    //user -> sender id -> reciever id -> messages -> message id -> store message
    try {
      var timeSent = DateTime.now();
      UserModel recieverUserData;

      var userDataMap =
          await firestore.collection('users').doc(recieverUserId).get();
      recieverUserData = UserModel.fromMap(userDataMap.data()!);

      var messageId = const Uuid().v1();
      //users -> reciever userId  -> chats -> current user id -> set data

      _saveDataToContactSubcollection(
        senderUser,
        recieverUserData,
        text,
        timeSent,
        recieverUserId,
      );

      _saveMessageToMessageSubcollection(
        reciecverUserId: recieverUserId,
        text: text,
        timeSent: timeSent,
        messageType: MessageEnum.text,
        messageId: messageId,
        recieverUserName: recieverUserData.name,
        userName: senderUser.name,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}