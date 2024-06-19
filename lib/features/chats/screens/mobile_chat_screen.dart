import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_jiriki/common/utils/colors.dart';
import 'package:whatsapp_jiriki/common/widgets/loader.dart';
import 'package:whatsapp_jiriki/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_jiriki/features/chats/widgets/bottom_chat_field.dart';
import 'package:whatsapp_jiriki/models/user_model.dart';
import 'package:whatsapp_jiriki/features/chats/widgets/chat_list.dart';


class MobileChatScreen extends ConsumerWidget {
  static const String routeName = '/mobile-chat-screen';
  const MobileChatScreen({
    super.key,
    required this.name,
    required this.uid,
  });
  final String name;
  final String uid;

  

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: StreamBuilder<UserModel>(
          stream: ref.watch(authControllerProvider).userDataById(uid),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Loader();
            }
            return Column(
              children: [
                Text(
                  name,
                ),
                Text(
                  snapshot.data!.isOnline 
                  ? 'online' 
                  : 'offline',
                  style: TextStyle(
                    color: snapshot.data!.isOnline ? Colors.green : Colors.red,
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            );
          }
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
           Expanded(
            child: ChatList(recieverUserId: uid,),
          ),
           Padding(
             padding: const EdgeInsets.all(15.0),
             child: BottomChatField(recieverUserId: uid,),
           ),
          
        ],
      ),
    );
  }
}

