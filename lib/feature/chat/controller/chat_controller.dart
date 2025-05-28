import 'package:get/get.dart';
import 'package:twitter_clone/feature/chat/model/chat_model.dart';
import 'package:twitter_clone/feature/chat/model/message_model.dart';
import 'package:twitter_clone/feature/personalization/model/user_model.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/chat_repository.dart';
import '../../../data/repositories/user_repository.dart';

class ChatController extends GetxController {
  static ChatController get instance => Get.find();

  final ChatRepository _chatRepository = ChatRepository();
  final _userRepository = UserRepository.instance;
  final currentUserId = AuthRepository.instance.authUser.uid;

  final RxList<ChatModel> chats = <ChatModel>[].obs;
  final RxList<MessageModel> messages = <MessageModel>[].obs;
  final RxInt selectedMessageIndex = (-1).obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadChats();
  }

  void loadChats() {
    _chatRepository.getChats().listen((chatList) {
      chats.value = chatList;
    });
  }

  void loadMessages(String chatId) {
    _chatRepository.getMessages(chatId).listen((messageList) {
      messages.value = messageList;
    });
  }

  Future<void> sendMessage({
    required String chatId,
    required String content,
    required String recipientId,
  }) async {
    if (content.trim().isEmpty) return;

    try {
      isLoading.value = true;
      await _chatRepository.sendMessage(
        chatId: chatId,
        content: content,
        recipientId: recipientId,
      );
      await _chatRepository.incrementUnreadCount(chatId, recipientId);
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  Future<String> getChatId(String otherUserId) async {
    return await _chatRepository.getOrCreateChatId(otherUserId);
  }

  Future<UserModel> getChatParticipant(ChatModel chat) async {
    final otherUserId = chat.participantIds.firstWhere(
      (id) => id != _chatRepository.currentUserId,
    );
    return await _userRepository.getUserById(otherUserId).first;
  }

  Future<void> markMessagesAsRead(String chatId) async {
    try {
      await _chatRepository.markMessagesAsRead(
        chatId: chatId,
        userId: currentUserId,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to mark messages as read');
      rethrow;
    }
  }

  int getUnreadCount(ChatModel chat) {
    return chat.unreadCounts[currentUserId] ?? 0;
  }
}
