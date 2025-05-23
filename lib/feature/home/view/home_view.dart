import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/common/common_app_drawer.dart';
import 'package:twitter_clone/common/custom_appbar.dart';
import 'package:twitter_clone/feature/tweet/view/tweet_card_view/tweet_card_view.dart';
import 'package:twitter_clone/routes/routes.dart';

import '../../../data/repositories/retweet_repository.dart';
import '../../../data/repositories/tweet_repository.dart';
import '../../tweet/controller/like_controller.dart';
import '../../tweet/controller/tweet_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(RetweetRepository());
    Get.put(TweetRepository());
    Get.put(LikeController());
    final tweetController = Get.put(TweetController());
    return Scaffold(
      appBar: CustomAppbar(title: 'Home'),
      drawer: CommonAppDrawer(),
      body: Obx(() {
        if (tweetController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (tweetController.allTweets.isEmpty) {
          return Center(child: Text("No tweets available"));
        }
        return RefreshIndicator(
          onRefresh: ()=>tweetController.fetchAllTweets(),
          child: ListView.builder(
            itemCount: tweetController.allTweets.length,
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final tweet = tweetController.allTweets[index];
              return TweetCardView(
                tweetId: tweet.tweetId,
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.addTweetView),
        shape: CircleBorder(),
        child: Icon(Icons.edit),
      ),
    );
  }
}
