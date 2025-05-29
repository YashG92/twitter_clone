import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/feature/personalization/controller/user_controller.dart';
import 'package:twitter_clone/feature/personalization/model/user_model.dart';
import '../../../feature/notification/model/notification_model.dart';
import '../../personalization/view/user_profile/widget/user_profile_avatar.dart';
import '../../../utils/constants/constants.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback? onMarkRead;

  const NotificationCard({
    super.key,
    required this.notification,
    this.onMarkRead,
  });

  IconData _getIcon() {
    switch (notification.notificationType) {
      case NotificationType.like:
        return CupertinoIcons.heart_fill;
      case NotificationType.reply:
        return CupertinoIcons.text_bubble_fill;
      case NotificationType.retweet:
        return CupertinoIcons.arrow_2_squarepath;
      case NotificationType.follow:
        return CupertinoIcons.person_fill;
    }
  }

  Color _getIconColor() {
    switch (notification.notificationType) {
      case NotificationType.like:
        return Colors.red;
      case NotificationType.reply:
        return Colors.blue;
      case NotificationType.retweet:
        return Colors.green;
      case NotificationType.follow:
        return Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRead = notification.isRead;

    return InkWell(
      onTap: onMarkRead,
      child: Container(
        color: isRead ? Colors.transparent : Colors.blue.withOpacity(0.1),
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(_getIcon(), color: _getIconColor(), size: 28),
            const SizedBox(width: YSizes.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50,
                    width: Get.width * .8,
                    child: ListView.separated(
                      separatorBuilder: (_, __) => SizedBox(width: YSizes.sm),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: notification.sourceUserIds.length,
                      itemBuilder: (context, index) {
                        final userId = notification.sourceUserIds[index];
                        return StreamBuilder<UserModel>(
                          stream: UserController.instance.getUserStream(userId),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const SizedBox();
                            }
                            final user = snapshot.data!;
                            return UserProfileAvatar(
                              backgroundRadius: 26,
                              foregroundRadius: 26,
                              imageUrl: user.profileImage,
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Text(
                    _getNotificationText(),
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: YSizes.sm),
                  Text(
                    "Tap to view detail",
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: YSizes.xs),
                  Text(
                    _formatTimeAgo(notification.createdAt),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getNotificationText() {
    switch (notification.notificationType) {
      case NotificationType.like:
        return 'Someone liked your tweet';
      case NotificationType.reply:
        return 'Someone replied to your tweet';
      case NotificationType.retweet:
        return 'Someone retweeted your tweet';
      case NotificationType.follow:
        return 'Someone followed you';
    }
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}
