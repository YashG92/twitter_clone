import 'package:cloud_firestore/cloud_firestore.dart';

enum NotificationType { like, reply, retweet, follow }

NotificationType getNotificationType(String type) {
  switch (type) {
    case 'like':
      return NotificationType.like;
    case 'reply':
      return NotificationType.reply;
    case 'retweet':
      return NotificationType.retweet;
    case 'follow':
      return NotificationType.follow;
    default:
      return NotificationType.like;
  }
}

String notificationTypeToString(NotificationType type) {
  return type.toString().split('.').last;
}

class NotificationModel {
  final String notificationId;
  final String userId;
  final NotificationType notificationType;
  final String sourceUserId;
  final String? sourceTweetId;
  final bool isRead;
  DateTime createdAt;

  NotificationModel({
    required this.notificationId,
    required this.userId,
    required this.notificationType,
    required this.sourceUserId,
    this.sourceTweetId,
    this.isRead = false,
    required this.createdAt,
  });

  static NotificationModel empty() => NotificationModel(
    notificationId: '',
    userId: '',
    notificationType: NotificationType.like,
    sourceUserId: '',
    sourceTweetId: '',
    isRead: false,
    createdAt: DateTime.now(),
  );

  toJson() {
    return {
      'notificationId': notificationId,
      'userId': userId,
      'notificationType': notificationType,
      'sourceUserId': sourceUserId,
      'sourceTweetId': sourceTweetId,
      'isRead': isRead,
      'createdAt': createdAt = DateTime.now(),
    };
  }

  factory NotificationModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data()!;
    return NotificationModel(
      notificationId: document.id,
      userId: data['userId'] ?? '',
      notificationType: data['notificationType'] ?? NotificationType.like,
      sourceUserId: data['sourceUserId'] ?? '',
      sourceTweetId: data['sourceTweetId'] ?? '',
      isRead: data['isRead'] ?? false,
      createdAt: data['createdAt'],
    );
  }
}
