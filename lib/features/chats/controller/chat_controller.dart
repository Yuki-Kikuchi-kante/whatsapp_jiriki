import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_jiriki/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_jiriki/features/chats/repository/chat_repository.dart';
import 'package:whatsapp_jiriki/models/contacts_list.dart';
import 'package:whatsapp_jiriki/models/message.dart';

final chatStreamProvider = StreamProvider.family<List<Message>,String>((ref,recieverUserId){
  final chatContoroller = ref.watch(chatControllerProvider);
 return chatContoroller.chatStream(recieverUserId);
});

final contactsStreamProvider = StreamProvider((ref){
final contactContoroller = ref.watch(chatControllerProvider);
 return contactContoroller.contactsStream();
});

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(
    chatRepository: chatRepository,
    ref: ref,
  );
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;
  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  Stream<List<Message>> chatStream(String recieverUserId) {
    return chatRepository.getMessage(recieverUserId);
  }

  Stream<List<ChatContact>> contactsStream() {
    return chatRepository.getContacts();
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String recieverUserId,
  }) {
    ref.read(getCurrentUserProvider).whenData((value)=> chatRepository.sendTextMessage(
      context: context,
      text: text,
      recieverUserId: recieverUserId,
      sender: value!,
    ));
   
  }
}
