import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/common/custom_appbar.dart';
import 'package:twitter_clone/common/common_app_drawer.dart';
import 'package:twitter_clone/feature/notification/controller/notification_controller.dart';
import 'package:twitter_clone/feature/notification/widget/notification_card.dart';
import 'package:twitter_clone/data/repositories/auth_repository.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationController = Get.put(NotificationController());
    final currentUserId = AuthRepository.instance.authUser.uid;

    notificationController.listenToNotifications(currentUserId);

    return Scaffold(
      appBar: CustomAppbar(title: 'Notifications'),
      drawer: CommonAppDrawer(),
      body: Obx(() {
        final notifications = notificationController.notifications;

        if (notifications.isEmpty) {
          return const Center(child: Text('No notifications yet.'));
        }

        return ListView.separated(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(top: 8),
          itemCount: notifications.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return NotificationCard(
              notification: notification,
              onMarkRead: () =>
                  notificationController.markNotificationAsRead(notification.notificationId),
            );
          },
        );
      }),
    );
  }
}
