import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:whatsapp_jiriki/common/utils/utils.dart';
import 'package:whatsapp_jiriki/models/user_model.dart';
import 'package:whatsapp_jiriki/features/chats/screens/mobile_chat_screen.dart';

final selectContactsRepositoryProvider = Provider(
  (ref) => SelectsContactsRepository(firestore: FirebaseFirestore.instance),
);

class SelectsContactsRepository {
  final FirebaseFirestore firestore;
  SelectsContactsRepository({
    required this.firestore,
  });

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  void selectContacts(
    Contact selectedContact,
  ) async {
    try {
      QuerySnapshot<Map<String, dynamic>> userCollection =
          await firestore.collection('users').get();
      bool isFound = false;

      for (var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());
        String selectedPhoneNum =
            selectedContact.phones[0].number.replaceAll(' ', '');
        if (userData.phoneNumber == selectedPhoneNum) {
          isFound = true;
          navigatorKey.currentState?.pushNamed(
            MobileChatScreen.routeName,
            arguments: {
              'name': userData.name,
              'uid': userData.uid,
            },
          );
        }
      }
      if (!isFound) {
        showSnackBar(
         'This number does not exist on this app.',
        );
      }
    } catch (e) {
      showSnackBar(
       e.toString(),
      );
    }
  }
}
