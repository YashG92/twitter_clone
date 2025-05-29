import 'package:cloud_firestore/cloud_firestore.dart';
import '../../feature/notification/model/notification_model.dart';

class NotificationRepository {
  static NotificationRepository? _instance;
  static NotificationRepository get instance {
    _instance ??= NotificationRepository();
    return _instance!;
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _notificationsRef =>
      _firestore.collection('notifications');

  Future<void> sendOrUpdateLikeNotification({
    required String tweetId,
    required String toUserId,
    required String fromUserId,
  }) async {
    final querySnapshot = await _notificationsRef
        .where('userId', isEqualTo: toUserId)
        .where('notificationType', isEqualTo: NotificationType.like.index)
        .where('sourceTweetId', isEqualTo: tweetId)
        .where('isRead', isEqualTo: false)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final doc = querySnapshot.docs.first;
      final notification = NotificationModel.fromSnapshot(doc);

      if (!notification.sourceUserIds.contains(fromUserId)) {
        final updatedSourceUserIds = [...notification.sourceUserIds, fromUserId];
        final updatedCreatedAt = DateTime.now();

        await _notificationsRef.doc(doc.id).update({
          'sourceUserIds': updatedSourceUserIds,
          'createdAt': updatedCreatedAt,
        });
      }
    } else {
      final newNotificationId = _notificationsRef.doc().id;
      final newNotification = NotificationModel(
        notificationId: newNotificationId,
        userId: toUserId,
        notificationType: NotificationType.like,
        sourceUserIds: [fromUserId],
        sourceTweetId: tweetId,
        isRead: false,
        createdAt: DateTime.now(),
      );

      await _notificationsRef.doc(newNotificationId).set(newNotification.toJson());
    }
  }

  Future<void> sendOrUpdateRetweetNotification({
    required String tweetId,
    required String toUserId,
    required String fromUserId,
  }) async {
    final querySnapshot = await _notificationsRef
        .where('userId', isEqualTo: toUserId)
        .where('notificationType', isEqualTo: NotificationType.retweet.index)
        .where('sourceTweetId', isEqualTo: tweetId)
        .where('isRead', isEqualTo: false)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final doc = querySnapshot.docs.first;
      final notification = NotificationModel.fromSnapshot(doc);

      if (!notification.sourceUserIds.contains(fromUserId)) {
        final updatedSourceUserIds = [...notification.sourceUserIds, fromUserId];
        final updatedCreatedAt = DateTime.now();

        await _notificationsRef.doc(doc.id).update({
          'sourceUserIds': updatedSourceUserIds,
          'createdAt': updatedCreatedAt,
        });
      }
    } else {
      final newNotificationId = _notificationsRef.doc().id;
      final newNotification = NotificationModel(
        notificationId: newNotificationId,
        userId: toUserId,
        notificationType: NotificationType.retweet,
        sourceUserIds: [fromUserId],
        sourceTweetId: tweetId,
        isRead: false,
        createdAt: DateTime.now(),
      );

      await _notificationsRef.doc(newNotificationId).set(newNotification.toJson());
    }
  }

  Future<void> sendReplyNotification({
    required String tweetId,
    required String toUserId,
    required String fromUserId,
  }) async {
    final newNotificationId = _notificationsRef.doc().id;
    final newNotification = NotificationModel(
      notificationId: newNotificationId,
      userId: toUserId,
      notificationType: NotificationType.reply,
      sourceUserIds: [fromUserId],
      sourceTweetId: tweetId,
      isRead: false,
      createdAt: DateTime.now(),
    );

    await _notificationsRef.doc(newNotificationId).set(newNotification.toJson());
  }

  Future<void> sendFollowNotification({
    required String toUserId,
    required String fromUserId,
  }) async {
    final newNotificationId = _notificationsRef.doc().id;
    final newNotification = NotificationModel(
      notificationId: newNotificationId,
      userId: toUserId,
      notificationType: NotificationType.follow,
      sourceUserIds: [fromUserId],
      sourceTweetId: null,
      isRead: false,
      createdAt: DateTime.now(),
    );

    await _notificationsRef.doc(newNotificationId).set(newNotification.toJson());
  }

  Future<void> markAsRead(String notificationId) async {
    await _notificationsRef.doc(notificationId).update({'isRead': true});
  }

  Stream<List<NotificationModel>> getUserNotifications(String userId) {
    return _notificationsRef
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => NotificationModel.fromSnapshot(doc)).toList());
  }
}
