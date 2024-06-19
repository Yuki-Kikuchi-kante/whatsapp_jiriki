import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_jiriki/common/enums/message_enum.dart';
import 'package:whatsapp_jiriki/common/utils/utils.dart';
import 'package:whatsapp_jiriki/models/contacts_list.dart';
import 'package:whatsapp_jiriki/models/message.dart';
import 'package:whatsapp_jiriki/models/user_model.dart';

final chatRepositoryProvider = Provider(
  (ref) => ChatRepository(
      auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance),
);

class ChatRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  ChatRepository({
    required this.auth,
    required this.firestore,
  });

  Stream<List<ChatContact>> getContacts(){
   return firestore
   .collection('users')
   .doc(auth.currentUser!.uid)
   .collection('chats')
   .snapshots()
   .map((event){
     List<ChatContact> contacts = [];
     for(var contact in event.docs){
        contacts.add(ChatContact.fromMap(contact.data(),),);
     }
     return contacts;
   });
  }

  Stream<List<Message>> getMessage(String recieverUserId) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .collection('messages')
        .orderBy('timeSent',descending: false)
        .snapshots()
        .map(
          (event) {
            List<Message> messages = [];
            for(var doc in event.docs){
              messages.add(Message.fromMap(doc.data()));
            }
            return messages;
          },
        );
  }

  void _saveDataToContactsSubcollection({
    required DateTime timeSent,
    required String lastMessage,
    required UserModel reciever,
    required UserModel sender,
  }) async {
    // users -> current user id  => chats -> reciever user id -> set data
    ChatContact senderUser = ChatContact(
      name: reciever.name,
      profilePic: reciever.profilePic,
      contactId: reciever.uid,
      timeSent: timeSent,
      lastMessage: lastMessage,
    );
    await firestore
        .collection('users')
        .doc(sender.uid)
        .collection('chats')
        .doc(reciever.uid)
        .set(
          senderUser.toMap(),
        );
// users -> reciever user id => chats -> current user id -> set data
    ChatContact recieverUser = ChatContact(
      name: sender.name,
      profilePic: sender.profilePic,
      contactId: sender.uid,
      timeSent: timeSent,
      lastMessage: lastMessage,
    );

    await firestore
        .collection('users')
        .doc(reciever.uid)
        .collection('chats')
        .doc(sender.uid)
        .set(
          recieverUser.toMap(),
        );
  }

  void _saveMessageToMessageSubcollection({
    required DateTime timeSent,
    required String text,
    required MessageEnum messageType,
    required String messageId,
    required String recieverUserId,
  }) async {
    Message message = Message(
      senderId: auth.currentUser!.uid,
      recieverId: recieverUserId,
      text: text,
      type: messageType,
      timeSent: timeSent,
      messageId: messageId,
      isSeen: false,
    );
    // users -> sender id -> reciever id -> messages -> message id -> store message
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .collection('messages')
        .doc(messageId)
        .set(
          message.toMap(),
        );
    // users -> reciever id  -> sender id -> messages -> message id -> store message
    await firestore
        .collection('users')
        .doc(recieverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(
          message.toMap(),
        );
  }

  void sendTextMessage(
      {required BuildContext context,
      required String text,
      required String recieverUserId,
      required UserModel sender}) async {
    try {
      final timeSent = DateTime.now();
      String messageId = const Uuid().v1();

      UserModel? recieverUser;

      var userDataMap =
          await firestore.collection('users').doc(recieverUserId).get();
      recieverUser = UserModel.fromMap(userDataMap.data()!);

      _saveDataToContactsSubcollection(
        timeSent: timeSent,
        lastMessage: text,
        reciever: recieverUser,
        sender: sender,
      );

      _saveMessageToMessageSubcollection(
        timeSent: timeSent,
        text: text,
        messageType: MessageEnum.text,
        messageId: messageId,
        recieverUserId: recieverUserId,
      );
    } catch (e) {
      showSnackBar(
        e.toString(),
      );
    }
  }
}
