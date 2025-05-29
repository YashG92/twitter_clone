import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/data/repositories/auth_repository.dart';
import 'package:twitter_clone/feature/notification/controller/notification_controller.dart';
import 'package:twitter_clone/feature/personalization/model/likes_model.dart';

import '../../../data/repositories/likes_repository.dart';

class LikeController extends GetxController {
  static LikeController get instance => Get.find();

  final _likesRepository = Get.put(LikesRepository());
  final RxMap<String, bool> _likedTweets = <String, bool>{}.obs;
  final RxList<LikesModel> userLikes = <LikesModel>[].obs;

  bool isLiked(String tweetId) => _likedTweets[tweetId] ?? false;

  @override
  void onInit() {
    super.onInit();
    loadUserLikes();
  }

  Future<void> toggleLikeStatus(String tweetId, bool currentlyLiked) async {
    try {
      final like = LikesModel(
        tweetId: tweetId,
        userId: AuthRepository.instance.authUser.uid,
        likedAt: DateTime.now(),
      );

      if (currentlyLiked) {
        await _likesRepository.unLikeTweet(like);
      } else {
        await _likesRepository.likeTweet(like);

        final tweetDoc =
            await FirebaseFirestore.instance
                .collection('Tweets')
                .doc(tweetId)
                .get();
        final tweetOwnerId = tweetDoc['authorId'];
        if (tweetOwnerId != AuthRepository.instance.authUser.uid) {
          await NotificationController.instance.sendLikeNotification(
            tweetId: tweetId,
            toUserId: tweetOwnerId,
            fromUserId: AuthRepository.instance.authUser.uid,
          );
        }
      }

      _likedTweets[tweetId] = !currentlyLiked;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void loadUserLikes() {
    _likesRepository.getUserLikes().listen((likes) {
      userLikes.assignAll(likes);
      for (var like in userLikes) {
        _likedTweets[like.tweetId] = true;
      }
    });
  }

  void onLikePressed(String tweetId) {
    toggleLikeStatus(tweetId, isLiked(tweetId));
  }
}
