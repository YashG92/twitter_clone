import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/feature/personalization/model/user_model.dart';
import 'package:twitter_clone/feature/tweet/controller/retweet_controller.dart';
import 'package:twitter_clone/feature/tweet/view/retweet/retweet_bottom_sheet.dart';
import 'package:twitter_clone/feature/tweet/view/tweet_card_view/widgets/tweet_action_button.dart';
import 'package:share_plus/share_plus.dart';
import 'package:twitter_clone/utils/loaders/loaders.dart';

import '../../../../../routes/routes.dart';
import '../../../../personalization/model/retweet_model.dart';
import '../../../controller/like_controller.dart';
import '../../../model/tweet_model.dart';

class TweetActionButtonsRow extends StatelessWidget {
  const TweetActionButtonsRow({
    super.key,
    required this.tweet,
    required this.author,
  });

  final TweetModel tweet;
  final UserModel author;

  @override
  Widget build(BuildContext context) {
    final likeController = LikeController.instance;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TweetActionButton(
          icon: Icons.chat_bubble_outline,
          count: tweet.replyCount,
          onPressed:
              () => Get.toNamed(
                Routes.tweetCommentView,
                arguments: [tweet.tweetId, author],
              ),
        ),
        TweetActionButton(
          icon: Icons.repeat,
          count: tweet.retweetCount,
          onPressed:
              () => showModalBottomSheet(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                context: context,
                builder:
                    (context) => RetweetBottomSheet(
                      onRepost:
                          () => RetweetController.instance.postRetweet(
                            tweet,
                            ReTweetType.retweet,
                          ),
                      onQuote: ()=> Loaders.customToast(message: 'Coming Soon'),
                    ),
              ),
        ),
        Obx(() {
          Visibility(
            visible: false,
            child: Text(likeController.isLiked(tweet.tweetId).toString()),
          );
          return TweetActionButton(
            icon:
                likeController.isLiked(tweet.tweetId)
                    ? Icons.favorite
                    : Icons.favorite_border,
            count: tweet.likeCount,
            onPressed: () => likeController.onLikePressed(tweet.tweetId),
          );
        }),
        TweetActionButton(
          icon: Icons.share,
          onPressed: () {
            final tweetContent =
                '${author.username} (@${author.email.split('@').first}):\n\n${tweet.content}\n\n#TwitterClone';
            SharePlus.instance.share(ShareParams(text: tweetContent,));
          },
        ),
      ],
    );
  }
}
