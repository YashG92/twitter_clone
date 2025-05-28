import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter_clone/feature/chat/model/chat_model.dart';
import 'package:twitter_clone/feature/chat/model/message_model.dart';

import 'auth_repository.dart';

class ChatRepository {
  final _db = FirebaseFirestore.instance;

  String get currentUserId => AuthRepository.instance.authUser.uid;

  Stream<List<ChatModel>> getChats() {
    return _db
        .collection('Chats')
        .where('participantIds', arrayContains: currentUserId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => ChatModel.fromSnapshot(doc)).toList(),
        );
  }

  Stream<List<MessageModel>> getMessages(String chatId) {
    return _db
        .collection('Chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('sentAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => MessageModel.fromSnapshot(doc))
                  .toList(),
        );
  }

  Future<void> sendMessage({
    required String chatId,
    required String content,
    required String recipientId,
  }) async {
    final message = MessageModel(
      messageId: _db.collection('Chats').doc().id,
      senderId: currentUserId,
      content: content,
      sentAt: DateTime.now(),
    );

    final batch = _db.batch();

    final messageRef = _db
        .collection('Chats')
        .doc(chatId)
        .collection('messages')
        .doc(message.messageId);
    batch.set(messageRef, message.toJson());

    final chatRef = _db.collection('Chats').doc(chatId);
    batch.update(chatRef, {
      'lastMessage': content,
      'lastMessageTime': message.sentAt,
      'lastMessageSenderId': currentUserId,
    });

    await batch.commit();
  }

  Future<String> getOrCreateChatId(String otherUserId) async {
    final participants = [currentUserId, otherUserId]..sort();
    final chatId = participants.join('_');

    final chatDoc = await _db.collection('Chats').doc(chatId).get();

    if (!chatDoc.exists) {
      await _db.collection('Chats').doc(chatId).set({
        'participantIds': participants,
        'lastMessage': '',
        'lastMessageTime': DateTime.now(),
        'lastMessageSenderId': '',
      });
    }

    return chatId;
  }

  Future<void> markMessagesAsRead({
    required String chatId,
    required String userId
  }) async {
    final batch = _db.batch();

    final chatRef = _db.collection('Chats').doc(chatId);
    batch.update(chatRef, {
      'unreadCounts.$userId': 0,
    });

    final messages = await _db
        .collection('Chats')
        .doc(chatId)
        .collection('messages')
        .where('senderId', isNotEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();

    for (final doc in messages.docs) {
      batch.update(doc.reference, {'isRead': true});
    }

    if (messages.docs.isNotEmpty) {
      await batch.commit();
    }
  }

  Future<void> incrementUnreadCount(String chatId, String recipientId) async {
    await _db.collection('Chats').doc(chatId).update({
      'unreadCounts.$recipientId': FieldValue.increment(1),
    });
  }

  Future<void> resetUnreadCount(String chatId, String userId) async {
    await _db.collection('Chats').doc(chatId).update({
      'unreadCounts.$userId': 0,
    });
  }
}

