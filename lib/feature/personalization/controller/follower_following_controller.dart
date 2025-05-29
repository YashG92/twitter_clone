import 'package:get/get.dart';

import '../../../data/repositories/follower_following_repository.dart';
import '../../notification/controller/notification_controller.dart';
import '../model/followers_model.dart';
import '../model/followings_model.dart';

class FollowerFollowingController extends GetxController {
  static FollowerFollowingController get instance => Get.find();

  final _repo = Get.put(FollowerFollowingRepository());

  final isFollowing = false.obs;
  final followersList = <FollowersModel>[].obs;
  final followingList = <FollowingsModel>[].obs;
  final followStatus = FollowStatus.rejected.obs;
  final isLoading = false.obs;

  void listenToFollowStatus(String currentUserId, String targetUserId) {
    _repo.followStatusStream(currentUserId, targetUserId).listen((status) {
      followStatus.value = status;
      isFollowing.value = status == FollowStatus.accepted;
    });
  }

  void loadUserFollowers(String userId) {
    isLoading.value = true;
    _repo
        .getUserFollowersStream(userId)
        .listen(
          (followers) {
            followersList.assignAll(followers);
            isLoading.value = false;
          },
          onError: (error) {
            isLoading.value = false;
            Get.snackbar('Error', error.toString());
          },
        );
  }

  void loadUserFollowing(String userId) {
    isLoading.value = true;
    _repo
        .getUserFollowingStream(userId)
        .listen(
          (following) {
            followingList.assignAll(following);
            isLoading.value = false;
          },
          onError: (error) {
            isLoading.value = false;
            Get.snackbar('Error', error.toString());
          },
        );
  }

  Future<void> toggleFollowUser(String targetUserId) async {
    try {
      if (followStatus.value == FollowStatus.accepted) {
        await _repo.unFollowUser(targetUserId);
      } else {
        final currentUserFollowing = FollowingsModel(
          followingId: _repo.currentUid,
          userId: targetUserId,
          followedAt: DateTime.now(),
          status: FollowStatus.pending,
        );

        final targetUserFollowers = FollowersModel(
          followerId: targetUserId,
          userId: _repo.currentUid,
          followedAt: DateTime.now(),
          status: FollowStatus.pending,
        );

        await _repo.followUser(
          targetUserId,
          currentUserFollowing,
          targetUserFollowers,
        );

        if (targetUserId != _repo.currentUid) {
          await NotificationController.instance.sendFollowRequestNotification(
            toUserId: targetUserId,
            fromUserId: _repo.currentUid,
          );
        }
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      rethrow;
    }
  }

  Future<void> respondToFollowRequest({
    required String requesterId,
    required String targetUserId,
    required bool accept,
  }) async {
    try {
      await _repo.updateFollowStatus(
        currentUserId: requesterId,
        targetUserId: targetUserId,
        status: accept ? FollowStatus.accepted : FollowStatus.rejected,
      );

      if (accept) {
        await NotificationController.instance.sendFollowAcceptedNotification(
          toUserId: requesterId,
          fromUserId: targetUserId,
        );
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      rethrow;
    }
  }
}
