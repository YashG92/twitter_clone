import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/data/repositories/tweet_repository.dart';
import 'package:twitter_clone/feature/tweet/model/tweet_model.dart';
import 'package:twitter_clone/feature/tweet/view/tweet_card_view/widgets/tweet_action_buttons_row.dart';
import 'package:twitter_clone/feature/tweet/view/tweet_card_view/widgets/tweet_image_grid.dart';
import 'package:twitter_clone/feature/tweet/view/tweet_card_view/widgets/tweet_user_info_row.dart';
import 'package:twitter_clone/utils/helpers/helper_function.dart';

import '../../../../utils/constants/constants.dart';

class TweetDetailView extends StatelessWidget {
  const TweetDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final tweetId = Get.arguments[0];
    final author = Get.arguments[1];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close_sharp),
          onPressed: () => Get.back(),
        ),
        title: Text('Thread'),
      ),
      body: StreamBuilder<TweetModel>(
        stream: TweetRepository.instance.getTweetStream(tweetId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error loading tweet');
          }

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final tweet = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Profile + user info row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(tweet.authorProfileImage),
                    ),
                    const SizedBox(width: YSizes.spaceBtwItems),
                    Expanded(
                      child: TweetUserInfoRow(tweet: tweet, isVerified: true, authorName: author.username.toString(), authorHandle: author.email.toString().split('@').first),
                    ),
                  ],
                ),
                const SizedBox(height: YSizes.sm),

                /// Tweet content
                Text(
                  tweet.content,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                /// Tweet images
                if (tweet.imageUrls != null && tweet.imageUrls!.isNotEmpty) ...[
                  const SizedBox(height: YSizes.sm),
                  TweetImageGrid(tweet: tweet),
                ],

                const SizedBox(height: YSizes.spaceBtwItems),

                /// Timestamp
                Text(
                  HelperFunction.formatDateTime(tweet.createdAt),
                  style: Theme.of(context).textTheme.bodySmall,
                ),

                const SizedBox(height: YSizes.spaceBtwItems),
                Divider(thickness: .5),
                Padding(
                  padding: const EdgeInsets.all(YSizes.sm),
                  child: Row(
                    children: [
                      Text('${tweet.replyCount} comments'),
                      const SizedBox(width: YSizes.md),
                      Text('${tweet.likeCount} Likes'),
                    ],
                  ),
                ),
                Divider(thickness: .5),
                /// Actions row (optional, if you want it)
                TweetActionButtonsRow(tweet: tweet),
              ],
            ),
          );
        },
      ),
    );
  }
}
