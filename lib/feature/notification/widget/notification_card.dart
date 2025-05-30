import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/feature/personalization/controller/user_controller.dart';
import 'package:twitter_clone/feature/personalization/model/user_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../feature/notification/model/notification_model.dart';
import '../../personalization/controller/follower_following_controller.dart';
import '../../personalization/view/user_profile/widget/user_profile_avatar.dart';
import '../../../utils/constants/constants.dart';
import '../controller/notification_controller.dart';

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
      case NotificationType.followRequest:
        return CupertinoIcons.person_fill;
      case NotificationType.followAccepted:
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
      case NotificationType.followRequest:
        return Colors.orange;
      case NotificationType.followAccepted:
        return Colors.green;
    }
  }

  String _getNotificationText() {
    final usersText =
        notification.sourceUserIds.length > 1
            ? '${notification.sourceUserIds.length} users'
            : 'Someone';

    switch (notification.notificationType) {
      case NotificationType.like:
        return '$usersText liked your tweet';
      case NotificationType.reply:
        return '$usersText replied to your tweet';
      case NotificationType.retweet:
        return '$usersText retweeted your tweet';
      case NotificationType.follow:
        return '$usersText followed you';
      case NotificationType.followRequest:
        return '$usersText wants to follow you';
      case NotificationType.followAccepted:
        return '$usersText accepted your follow request';
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

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();
    final isFollowRequest =
        notification.notificationType == NotificationType.followRequest;
    final isHandled = notification.isHandled;
    return isFollowRequest
        ? _buildNotificationContainer(isHandled, context)
        : InkWell(
          onTap: onMarkRead,
          child: _buildNotificationContainer(isHandled, context),
        );
  }

  Widget _buildNotificationContainer(bool isHandled, BuildContext context) {
    final isRead = notification.isRead;
    final isFollowRequest =
        notification.notificationType == NotificationType.followRequest;

    return Container(
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
                // Avatar list
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
                          if (!snapshot.hasData) return const SizedBox();
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

                // Notification text
                Text(
                  _getNotificationText(),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                  ),
                ),
                const SizedBox(height: YSizes.sm),

                // Action buttons for follow requests
                if (isFollowRequest && !isHandled) _buildFollowRequestButtons(),

                if (isFollowRequest && isHandled)
                  Text('Request handled', style: TextStyle(color: Colors.grey)),

                // Regular notification footer
                if (!isFollowRequest) ...[
                  Text(
                    "Tap to view detail",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: YSizes.xs),
                  Text(
                    _formatTimeAgo(notification.createdAt),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFollowRequestButtons() {
    final controller = Get.find<NotificationController>();
    final followController = Get.put(FollowerFollowingController());
    final currentUserId = AuthRepository.instance.authUser.uid;

    return Row(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: YSizes.md),
          ),
          onPressed:
              () => _handleFollowResponse(
                true,
                followController,
                controller,
                currentUserId,
              ),
          child: const Text('Accept'),
        ),
        const SizedBox(width: YSizes.sm),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          onPressed:
              () => _handleFollowResponse(
                false,
                followController,
                controller,
                currentUserId,
              ),
          child: const Text('Decline'),
        ),
      ],
    );
  }

  Future<void> _handleFollowResponse(
    bool accept,
    FollowerFollowingController followController,
    NotificationController notificationController,
    String currentUserId,
  ) async {
    try {
      await followController.respondToFollowRequest(
        requesterId: notification.sourceUserIds.first,
        targetUserId: currentUserId,
        accept: accept,
      );

      notificationController.markNotificationAsHandled(
        notification.notificationId,
      );

      if (onMarkRead != null) onMarkRead!();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
