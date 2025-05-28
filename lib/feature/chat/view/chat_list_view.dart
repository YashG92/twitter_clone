import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/common/custom_appbar.dart';
import 'package:twitter_clone/common/common_app_drawer.dart';
import 'package:twitter_clone/feature/chat/controller/chat_controller.dart';
import 'package:twitter_clone/feature/personalization/model/user_model.dart';
import 'package:twitter_clone/routes/routes.dart';
import 'package:twitter_clone/utils/constants/constants.dart';

class ChatListView extends StatelessWidget {
  const ChatListView({super.key});

  @override
  Widget build(BuildContext context) {
    final chatController = ChatController.instance;

    return Scaffold(
      appBar: CustomAppbar(title: 'Messages'),
      drawer: const CommonAppDrawer(),
      body: Obx(() {
        if (chatController.chats.isEmpty) {
          return const Center(child: Text('No messages yet'));
        }

        return ListView.separated(
          itemCount: chatController.chats.length,
          separatorBuilder: (_, __) => const Divider(thickness: 0.6),
          itemBuilder: (context, index) {
            final chat = chatController.chats[index];
            return FutureBuilder<UserModel>(
              future: chatController.getChatParticipant(chat),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const ListTile();
                }
                final user = snapshot.data!;
                final unreadCount = chatController.getUnreadCount(chat);

                return ListTile(
                  onTap: () {
                    chatController.markMessagesAsRead(chat.chatId);
                    Get.toNamed(
                      Routes.chatView,
                      arguments: [chat.chatId, user],
                    )?.then((_)=>chatController.markMessagesAsRead(chat.chatId));
                  },
                  leading: CircleAvatar(
                    radius: 26,
                    backgroundImage: NetworkImage(user.profileImage),
                  ),
                  title: Text(
                    user.username,
                    style:
                        unreadCount > 0
                            ? Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            )
                            : Theme.of(context).textTheme.titleLarge,
                  ),
                  subtitle: Text(
                    chat.lastMessage,
                    style:
                        unreadCount > 0
                            ? TextStyle(fontWeight: FontWeight.bold)
                            : null,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_formatTime(chat.lastMessageTime)),
                      if (unreadCount > 0)
                        Container(
                          padding: EdgeInsets.all(YSizes.sm/2),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            unreadCount.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                );
              },
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=> Get.toNamed(Routes.searchChatView),
        shape: const CircleBorder(),
        child: const Icon(Icons.messenger_outline),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    if (now.difference(time).inDays < 1) {
      return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    } else if (now.difference(time).inDays < 7) {
      return _weekdays[time.weekday]!;
    }
    return '${time.day}/${time.month}';
  }

  static const _weekdays = {
    1: 'Mon',
    2: 'Tue',
    3: 'Wed',
    4: 'Thu',
    5: 'Fri',
    6: 'Sat',
    7: 'Sun',
  };
}
