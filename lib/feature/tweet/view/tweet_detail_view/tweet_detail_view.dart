import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/data/repositories/comment_repository.dart';
import 'package:twitter_clone/data/repositories/tweet_repository.dart';
import 'package:twitter_clone/data/repositories/user_repository.dart';
import 'package:twitter_clone/feature/personalization/model/user_model.dart';
import 'package:twitter_clone/feature/tweet/model/tweet_model.dart';
import 'package:twitter_clone/feature/tweet/view/tweet_card_view/tweet_card_view.dart';
import 'package:twitter_clone/feature/tweet/view/tweet_card_view/widgets/tweet_action_buttons_row.dart';
import 'package:twitter_clone/feature/tweet/view/tweet_card_view/widgets/tweet_card_view_widget.dart';
import 'package:twitter_clone/feature/tweet/view/tweet_card_view/widgets/tweet_image_grid.dart';
import 'package:twitter_clone/feature/tweet/view/tweet_card_view/widgets/tweet_user_info_row.dart';
import 'package:twitter_clone/utils/helpers/helper_function.dart';

import '../../../../data/repositories/auth_repository.dart';
import '../../../../utils/constants/constants.dart';
import '../../model/comment_model.dart';

class TweetDetailView extends StatelessWidget {
  const TweetDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final commentRepo = Get.put(CommentRepository());
    final tweetId = Get.arguments[0];
    final author = Get.arguments[1];
    final currentUid = AuthRepository.instance.authUser.uid;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close_sharp),
          onPressed: () => Get.back(),
        ),
        title: Text('Thread'),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<TweetModel>(
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
                        backgroundImage: NetworkImage(author.profileImage),
                      ),
                      const SizedBox(width: YSizes.spaceBtwItems),
                      Expanded(
                        child: TweetUserInfoRow(
                          tweet: tweet,
                          isVerified: true,
                          authorName: author.username.toString(),
                          authorHandle:
                              author.email.toString().split('@').first,
                        ),
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
                  if (tweet.imageUrls != null &&
                      tweet.imageUrls!.isNotEmpty) ...[
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
                  TweetActionButtonsRow(tweet: tweet, author: author),
                  const Divider(thickness: 0.5),
                  const SizedBox(height: YSizes.sm),

                  /// Comments section
                  Text(
                    "Comments",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: YSizes.sm),

                  /// Stream of comments
                  StreamBuilder<List<CommentModel>>(
                    stream: commentRepo.getCommentsForTweet(tweetId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error loading comments'));
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No comments yet.'));
                      }
                      final comments = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          final comment = comments[index];
                          return TweetCardView(
                            tweetId: comment.commentId,
                            showMoreOption: tweet.authorId == currentUid,
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
