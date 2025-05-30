import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/feature/chat/controller/chat_controller.dart';
import 'package:twitter_clone/feature/personalization/view/user_profile/widget/user_profile_avatar.dart';

import '../../../../routes/routes.dart';
import '../../../personalization/controller/user_controller.dart';

class SearchChatView extends StatelessWidget {
  const SearchChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = UserController.instance;
    final chatController = ChatController.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Message'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: kToolbarHeight,
            child: TextField(
              autofocus: true,
              onChanged: (query) => userController.searchUsers(query),
              decoration: const InputDecoration(
                hintText: 'Search for people',
                border: InputBorder.none,
              ),
            ),
          ),
          Obx(() {
            final users = userController.searchedUsers;
            if (users.isEmpty) {
              return const Center(child: Text(''));
            }

            return ListView.builder(
              shrinkWrap: true,
              itemCount: users.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  onTap: () async {
                    final chatId = await chatController.getChatId(user.userId);
                    Get.toNamed(Routes.chatView, arguments: [chatId, user]);
                  },
                  leading: UserProfileAvatar(
                    backgroundRadius: 25,
                    foregroundRadius: 25,
                    imageUrl: user.profileImage,
                  ),
                  title: Text(
                    user.username,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  subtitle: Text(user.email.split('@').first),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
