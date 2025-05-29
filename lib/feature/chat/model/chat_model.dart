import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String chatId;
  final List<String> participantIds;
  final Map<String, int> unreadCounts;
  final String lastMessage;
  final DateTime lastMessageTime;
  final String lastMessageSenderId;

  ChatModel({
    required this.chatId,
    required this.participantIds,
    required this.unreadCounts,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.lastMessageSenderId,
  });

  factory ChatModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return ChatModel(
      chatId: snapshot.id,
      participantIds: List<String>.from(data['participantIds']),
      lastMessage: data['lastMessage'] ?? '',
      unreadCounts: Map<String, int>.from(data['unreadCounts'] ?? {}),
      lastMessageTime: (data['lastMessageTime'] as Timestamp).toDate(),
      lastMessageSenderId: data['lastMessageSenderId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'participantIds': participantIds,
      'lastMessage': lastMessage,
      'unreadCounts': unreadCounts,
      'lastMessageTime': lastMessageTime,
      'lastMessageSenderId': lastMessageSenderId,
    };
  }
}
