import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/data/repositories/user_repository.dart';

import '../../../data/repositories/follower_following_repository.dart';
import '../model/followers_model.dart';
import '../model/followings_model.dart';

class FollowerFollowingController extends GetxController {
  static FollowerFollowingController get instance => Get.find();

  final _repo = Get.put(FollowerFollowingRepository());

  final isFollowing = false.obs;
  final followersList = <FollowersModel>[].obs;
  final followingList = <FollowingsModel>[].obs;


  Stream<bool> isFollowingStream(String currentUserId, String targetUserId) {
    return _repo.isFollowingStream(currentUserId, targetUserId);
  }

  void listenIsFollowing(String currentUserId, String targetUserId) {
    _repo.isFollowingStream(currentUserId, targetUserId).listen((value) {
      isFollowing.value = value;
    });
  }

  Future<void> followUser(String targetUserId) async {
    try {
      final currentUserFollowing = FollowingsModel(
        followingId: _repo.currentUid,
        userId: targetUserId,
        followedAt: DateTime.now(),
      );
      final targetUserFollowers = FollowersModel(
        followerId: _repo.currentUid,
        userId: targetUserId,
        followedAt: DateTime.now(),
      );

      await _repo.followUser(
        targetUserId,
        currentUserFollowing,
        targetUserFollowers,
      );
      await UserRepository.instance.updateSingleFieldUserData(
        userId: targetUserId,
        json: {'followerCount': FieldValue.increment(1)},
      );
      await UserRepository.instance.updateSingleFieldUserData(
        json: {'followingCount': FieldValue.increment(1)},
      );
      isFollowing.value = true;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> unFollowUser(String targetUserId) async {
    try {
      await _repo.unFollowUser(targetUserId);
      await UserRepository.instance.updateSingleFieldUserData(
        userId: targetUserId,
        json: {'followerCount': FieldValue.increment(-1)},
      );
      await UserRepository.instance.updateSingleFieldUserData(
        json: {'followingCount': FieldValue.increment(-1)},
      );
      isFollowing.value = false;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void loadFollowers(String userId) {
    _repo
        .followersStream(userId)
        .listen(
          (data) {
            followersList.assignAll(data);
          },
          onError: (e) {
            Get.snackbar('Error', e.toString());
          },
        );
  }

  void loadFollowing(String userId) {
    _repo
        .followingStream(userId)
        .listen(
          (data) {
            followingList.assignAll(data);
          },
          onError: (e) {
            Get.snackbar('Error', e.toString());
          },
        );
  }
}
