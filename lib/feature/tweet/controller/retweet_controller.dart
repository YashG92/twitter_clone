import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/data/repositories/tweet_repository.dart';
import 'package:twitter_clone/feature/personalization/model/retweet_model.dart';
import 'package:twitter_clone/feature/tweet/controller/post_tweet_controller.dart';
import 'package:twitter_clone/feature/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/feature/tweet/model/tweet_model.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/retweet_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../utils/helpers/network_manager.dart';

class RetweetController extends GetxController {
  static RetweetController get instance => Get.find();

  final RetweetRepository _retweetRepository = Get.put(RetweetRepository());

  final isLoading = false.obs;
  final postTweetController = PostTweetController.instance;

  Future<void> postRetweet(TweetModel tweet, ReTweetType reTweetType) async {
    try {
      isLoading.value = true;
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        isLoading.value = false;
        return;
      }

      final newRetweetTweet = TweetModel(
        tweetId: '',
        content: tweet.content,
        authorId: tweet.authorId,
        authorHandle: tweet.authorHandle,
        authorProfileImage: tweet.authorProfileImage,
        likeCount: 0,
        replyCount: 0,
        retweetCount: 0,
        isRetweet: true,
        reTweetType: reTweetType.toString(),
        originalTweetId: tweet.tweetId,
        imageUrls: tweet.imageUrls,
        createdAt: DateTime.now(),
      );

      newRetweetTweet.tweetId = await TweetRepository.instance.postTweet(
        newRetweetTweet,
      );

      TweetRepository.instance.updateSingleFieldTweetData(
        tweetId: tweet.tweetId,
        json: {
          'reTweetedBy': FieldValue.arrayUnion([
            AuthRepository.instance.authUser.uid,
          ]),
        },
      );
      UserRepository.instance.updateSingleFieldUserData({
        'tweetCount': FieldValue.increment(1),
      });

      final newRetweet = RetweetModel(
        reTweetId: newRetweetTweet.tweetId,
        reTweetType: reTweetType.toString(),
        userId: AuthRepository.instance.authUser.uid,
        originalTweetRef: tweet.tweetId,
        retweetedAt: DateTime.now(),
      );

      await _retweetRepository.postRetweet(newRetweet);
      await TweetRepository.instance.updateSingleFieldTweetData(
        tweetId: tweet.tweetId,
        json: {'retweetCount': FieldValue.increment(1)},
      );
      TweetController.instance.allTweets.insert(0, newRetweetTweet);
      TweetController.instance.allTweets.refresh();
      TweetController.instance.userTweets.insert(0, newRetweetTweet);
      TweetController.instance.userTweets.refresh();
      isLoading.value = false;
      Get.back();
      Get.snackbar('Success', 'Tweet retweeted successfully');
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.toString());
    }
  }
}
