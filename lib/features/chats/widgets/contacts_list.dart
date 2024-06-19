import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_jiriki/common/utils/colors.dart';
import 'package:whatsapp_jiriki/common/widgets/error.dart';
import 'package:whatsapp_jiriki/common/widgets/loader.dart';
import 'package:whatsapp_jiriki/features/chats/controller/chat_controller.dart';
import 'package:whatsapp_jiriki/features/chats/screens/mobile_chat_screen.dart';
import 'package:whatsapp_jiriki/models/contacts_list.dart';

class ContactsList extends ConsumerWidget {
  const ContactsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(contactsStreamProvider).when(
          data: (List<ChatContact> datas) {
            return Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: datas.length,
                itemBuilder: (context, index) {
                final data = datas[index];
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>  MobileChatScreen(
                                name: data.name,
                                uid: data.contactId,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: ListTile(
                            title: Text(
                              data.name,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Text(
                                data.lastMessage,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                data.profilePic,
                              ),
                              radius: 30,
                            ),
                            trailing: Text(
                              DateFormat.Hm().format(data.timeSent),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Divider(color: dividerColor, indent: 85),
                    ],
                  );
                },
              ),
            );
          },
          error: (Object error, StackTrace stackTrace) => ErrorScreen(
            error: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}
