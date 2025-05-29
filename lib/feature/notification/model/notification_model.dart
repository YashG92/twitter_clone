import 'package:cloud_firestore/cloud_firestore.dart';

enum NotificationType { like, reply, retweet, follow }

class NotificationModel {
  final String notificationId;
  final String userId;
  final NotificationType notificationType;
  final List<String> sourceUserIds;
  final String? sourceTweetId;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.notificationId,
    required this.userId,
    required this.notificationType,
    required this.sourceUserIds,
    this.sourceTweetId,
    this.isRead = false,
    required this.createdAt,
  });

  static NotificationModel empty() => NotificationModel(
    notificationId: '',
    userId: '',
    notificationType: NotificationType.like,
    sourceUserIds: [],
    sourceTweetId: null,
    isRead: false,
    createdAt: DateTime.now(),
  );

  Map<String, dynamic> toJson() {
    return {
      'notificationId': notificationId,
      'userId': userId,
      'notificationType': notificationType.index,
      'sourceUserIds': sourceUserIds,
      'sourceTweetId': sourceTweetId,
      'isRead': isRead,
      'createdAt': createdAt,
    };
  }

  factory NotificationModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data()!;
    return NotificationModel(
      notificationId: document.id,
      userId: data['userId'] ?? '',
      notificationType: NotificationType.values[data['notificationType'] ?? 0],
      sourceUserIds: List<String>.from(data['sourceUserIds'] ?? []),
      sourceTweetId: data['sourceTweetId'],
      isRead: data['isRead'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  NotificationModel copyWith({
    String? notificationId,
    String? userId,
    NotificationType? notificationType,
    List<String>? sourceUserIds,
    String? sourceTweetId,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      notificationId: notificationId ?? this.notificationId,
      userId: userId ?? this.userId,
      notificationType: notificationType ?? this.notificationType,
      sourceUserIds: sourceUserIds ?? this.sourceUserIds,
      sourceTweetId: sourceTweetId ?? this.sourceTweetId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
