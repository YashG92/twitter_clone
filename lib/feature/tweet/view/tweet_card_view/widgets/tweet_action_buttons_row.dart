import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/feature/tweet/view/tweet_card_view/widgets/tweet_action_button.dart';

import '../../../../../routes/routes.dart';
import '../../../controller/like_controller.dart';
import '../../../controller/tweet_controller.dart';
import '../../../model/tweet_model.dart';

class TweetActionButtonsRow extends StatelessWidget {
  const TweetActionButtonsRow({super.key, required this.tweet});

  final TweetModel tweet;

  @override
  Widget build(BuildContext context) {
    final likeController = LikeController.instance;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TweetActionButton(
          icon: Icons.chat_bubble_outline,
          count: tweet.replyCount,
          onPressed: () => Get.toNamed(Routes.commentView),
        ),
        TweetActionButton(
          icon: Icons.repeat,
          count: tweet.retweetCount,
          onPressed: () {},
        ),
        Obx(() {
          Visibility(visible: false,child: Text(likeController.isLiked(tweet.tweetId).toString()));
          return TweetActionButton(
            icon:
                likeController.isLiked(tweet.tweetId)
                    ? Icons.favorite
                    : Icons.favorite_border,
            count: tweet.likeCount,
            onPressed: () => likeController.onLikePressed(tweet.tweetId),
          );
        }),
        TweetActionButton(icon: Icons.share, onPressed: () {}),
      ],
    );
  }
}
