import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_jiriki/common/widgets/error.dart';
import 'package:whatsapp_jiriki/common/widgets/loader.dart';
import 'package:whatsapp_jiriki/features/chats/controller/chat_controller.dart';
import 'package:whatsapp_jiriki/features/chats/widgets/my_message_card.dart';
import 'package:whatsapp_jiriki/features/chats/widgets/sender_message_card.dart';

class ChatList extends ConsumerStatefulWidget {
  final String recieverUserId;
  const ChatList({
    super.key,
    required this.recieverUserId,
  });

  @override
  ConsumerState<ChatList> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(chatStreamProvider(widget.recieverUserId)).when(
          data: (datas) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              messageController
                  .jumpTo(messageController.position.maxScrollExtent);
            });
            return ListView.builder(
              controller: messageController,
              itemCount: datas.length,
              itemBuilder: (context, index) {
                final data = datas[index];
                if (data.senderId != widget.recieverUserId) {
                  return MyMessageCard(
                    message: data.text,
                    date: DateFormat.Hm().format(data.timeSent),
                  );
                }
                return SenderMessageCard(
                  message: data.text,
                  date: DateFormat.Hm().format(data.timeSent),
                );
              },
            );
          },
          error: (err, str) => ErrorScreen(
            error: err.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}
