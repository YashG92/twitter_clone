import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String messageId;
  final String senderId;
  final String content;
  final DateTime sentAt;
  final bool isRead;

  MessageModel({
    required this.messageId,
    required this.senderId,
    required this.content,
    required this.sentAt,
    this.isRead = false,
  });

  factory MessageModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return MessageModel(
      messageId: snapshot.id,
      senderId: data['senderId'],
      content: data['content'],
      sentAt: (data['sentAt'] as Timestamp).toDate(),
      isRead: data['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'content': content,
      'sentAt': sentAt,
      'isRead': isRead,
    };
  }
}