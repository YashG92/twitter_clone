import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/data/repositories/user_repository.dart';

import '../../../data/repositories/follower_following_repository.dart';
import '../../notification/controller/notification_controller.dart';
import '../model/followers_model.dart';
import '../model/followings_model.dart';

class FollowerFollowingController extends GetxController {
  static FollowerFollowingController get instance => Get.find();

  final _repo = Get.put(FollowerFollowingRepository());
  final _userRepo = Get.put(UserRepository());

  final isFollowing = false.obs;
  final followersList = <FollowersModel>[].obs;
  final followingList = <FollowingsModel>[].obs;
  final isLoading = false.obs;

  void listenToFollowStatus(String currentUserId, String targetUserId) {
    _repo.isFollowingStream(currentUserId, targetUserId).listen((value) {
      isFollowing.value = value;
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
      if (isFollowing.value) {
        await _repo.unFollowUser(targetUserId);
      } else {
        final currentUserFollowing = FollowingsModel(
          followingId: _repo.currentUid,
          userId: targetUserId,
          followedAt: DateTime.now(),
        );
        final targetUserFollowers = FollowersModel(
          followerId: targetUserId,
          userId: _repo.currentUid,
          followedAt: DateTime.now(),
        );
        await _repo.followUser(
          targetUserId,
          currentUserFollowing,
          targetUserFollowers,
        );
        if (targetUserId != _repo.currentUid) {
          await NotificationController.instance.sendFollowNotification(
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
}
