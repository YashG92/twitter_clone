import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/feature/chat/controller/chat_controller.dart';
import 'package:twitter_clone/feature/personalization/model/user_model.dart';
import 'package:twitter_clone/utils/constants/constants.dart';
import 'package:twitter_clone/utils/helpers/helper_function.dart';

class ChatView extends StatelessWidget {
  ChatView({super.key});

  final chatId = Get.arguments[0] as String;
  final recipient = Get.arguments[1] as UserModel;

  @override
  Widget build(BuildContext context) {
    final chatController = ChatController.instance;
    final messageController = TextEditingController();

    chatController.loadMessages(chatId);

    return Scaffold(
      appBar: AppBar(
        title: Text(recipient.username),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              Visibility(
                visible: false,
                child: Text(chatController.selectedMessageIndex.toString()),
              );
              return ListView.builder(
                reverse: true,
                padding: const EdgeInsets.symmetric(vertical: YSizes.sm),
                itemCount: chatController.messages.length,
                itemBuilder: (context, index) {
                  final message = chatController.messages[index];
                  final isMe = message.senderId == chatController.currentUserId;
                  final isSelected =
                      chatController.selectedMessageIndex.value == index;

                  final currentDate = message.sentAt;
                  final previousDate =
                      index < chatController.messages.length - 1
                          ? chatController.messages[index + 1].sentAt
                          : null;

                  final showDateHeader =
                      previousDate == null ||
                      currentDate.day != previousDate.day ||
                      currentDate.month != previousDate.month ||
                      currentDate.year != previousDate.year;

                  return Column(
                    crossAxisAlignment:
                        isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                    children: [
                      if (showDateHeader)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                HelperFunction.formatDateOnly(currentDate),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      GestureDetector(
                        onTap: () {
                          chatController.selectedMessageIndex.value =
                              isSelected ? -1 : index;
                        },
                        child: Column(
                          crossAxisAlignment:
                              isMe
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: YSizes.sm / 2,
                                horizontal: YSizes.sm,
                              ),
                              padding: const EdgeInsets.all(YSizes.sm * 1.5),
                              decoration: BoxDecoration(
                                color:
                                    isMe
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(
                                          context,
                                        ).colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                message.content,
                                style: TextStyle(
                                  color: isMe ? Colors.white : null,
                                ),
                              ),
                            ),
                            if (isSelected)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: YSizes.sm,
                                ),
                                child: Text(
                                  HelperFunction.formatDateTimeForMessage(
                                    message.sentAt,
                                  ),
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: Colors.grey),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            }),
          ),
          _buildMessageInput(chatController, messageController),
        ],
      ),
    );
  }

  Widget _buildMessageInput(
    ChatController chatController,
    TextEditingController messageController,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(),
              ),
              onSubmitted:
                  (text) => _sendMessage(chatController, messageController),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: () => _sendMessage(chatController, messageController),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage(
    ChatController chatController,
    TextEditingController messageController,
  ) async {
    if (messageController.text.trim().isEmpty) return;

    await chatController.sendMessage(
      chatId: chatId,
      content: messageController.text,
      recipientId: recipient.userId,
    );
    messageController.clear();
  }
}
