import 'package:get/get.dart';

import '../../../data/repositories/notification_repository.dart';
import '../model/notification_model.dart';

class NotificationController extends GetxController {
  static NotificationController get instance => Get.find();

  final NotificationRepository _notificationRepo =
      NotificationRepository.instance;

  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxSet<String> handledFollowRequests = <String>{}.obs;
  final RxBool isLoading = false.obs;

  void listenToNotifications(String userId) {
    isLoading.value = true;
    _notificationRepo.getUserNotifications(userId).listen((data) {
      notifications.value = data;
      isLoading.value = false;
    });
  }

  void markFollowRequestHandled(String notificationId) {
    handledFollowRequests.add(notificationId);
  }

  Future<void> markNotificationAsHandled(String notificationId) async {
    try {
      await _notificationRepo.markAsHandled(notificationId);
      final index = notifications.indexWhere(
        (n) => n.notificationId == notificationId,
      );
      if (index != -1) {
        notifications[index] = notifications[index].copyWith(isHandled: true,isRead: true);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to mark notification as handled: $e');
    }
  }

  Future<void> sendLikeNotification({
    required String tweetId,
    required String toUserId,
    required String fromUserId,
  }) async {
    await _notificationRepo.sendOrUpdateLikeNotification(
      tweetId: tweetId,
      toUserId: toUserId,
      fromUserId: fromUserId,
    );
  }

  Future<void> sendRetweetNotification({
    required String tweetId,
    required String toUserId,
    required String fromUserId,
  }) async {
    await _notificationRepo.sendOrUpdateRetweetNotification(
      tweetId: tweetId,
      toUserId: toUserId,
      fromUserId: fromUserId,
    );
  }

  Future<void> sendReplyNotification({
    required String tweetId,
    required String toUserId,
    required String fromUserId,
  }) async {
    await _notificationRepo.sendReplyNotification(
      tweetId: tweetId,
      toUserId: toUserId,
      fromUserId: fromUserId,
    );
  }

  Future<void> sendFollowNotification({
    required String toUserId,
    required String fromUserId,
  }) async {
    await _notificationRepo.sendFollowNotification(
      toUserId: toUserId,
      fromUserId: fromUserId,
    );
  }

  Future<void> sendFollowRequestNotification({
    required String toUserId,
    required String fromUserId,
  }) async {
    await _notificationRepo.sendFollowRequestNotification(
      toUserId: toUserId,
      fromUserId: fromUserId,
    );
  }

  Future<void> sendFollowAcceptedNotification({
    required String toUserId,
    required String fromUserId,
  }) async {
    await _notificationRepo.sendFollowAcceptedNotification(
      toUserId: toUserId,
      fromUserId: fromUserId,
    );
  }
}
