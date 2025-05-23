import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/data/repositories/retweet_repository.dart';
import 'package:twitter_clone/data/repositories/tweet_repository.dart';

import '../model/tweet_model.dart';

class TweetController extends GetxController {
  static TweetController get instance => Get.find();

  @override
  void onInit() {
    super.onInit();
    fetchAllTweets();
    fetchUserTweets(FirebaseAuth.instance.currentUser!.uid);
  }

  final isLoading = false.obs;
  final isLiked = false.obs;
  final tweetRepository = TweetRepository.instance;

  Rx<Stream<TweetModel>?> tweetStream = Rx<Stream<TweetModel>?>(null);
  Rx<Stream<List<TweetModel>>?> userTweetStream = Rx<Stream<List<TweetModel>>?>(
    null,
  );
  final allTweets = <TweetModel>[].obs;
  final userTweets = <TweetModel>[].obs;
  final userReTweets = <TweetModel>[].obs;

  void loadTweetStream(String tweetId) {
    tweetStream.value = tweetRepository.getTweetStream(tweetId);
  }

  void loadUserTweetStream(String userId) {
    userTweetStream.value = tweetRepository.getUserTweetStream(userId);
  }

  Future<void> fetchAllTweets() async {
    try {
      isLoading.value = true;
      final result = await tweetRepository.fetchTweet();
      allTweets.assignAll(result);
      allTweets.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUserTweets(String userId) async {
    try {
      isLoading.value = true;
      final userTweetResult = await tweetRepository.fetchTweetByUserId(userId);
      userTweets.assignAll(userTweetResult);
      userTweets.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      print(userTweets.map((f)=>f.tweetId));
      print('hii');
      final userReTweetResult = await RetweetRepository.instance.fetchReTweetByUserId(userId);
      userReTweets.assignAll(userReTweetResult);
      userReTweets.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      print(userReTweets.map((f)=>f.tweetId));
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteTweet(String tweetId) async {
    try {
      isLoading.value = true;
      await tweetRepository.deleteTweetByUserId(tweetId);
      allTweets.removeWhere((tweet) => tweet.tweetId == tweetId);
      userTweets.removeWhere((tweet) => tweet.tweetId == tweetId);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> likeCountUpdate(String tweetId, bool isLiked) async {
    try {
      isLoading.value = true;
      await tweetRepository.likeCountUpdate(tweetId, isLiked);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
