import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/feature/personalization/model/user_model.dart';
import 'package:twitter_clone/feature/personalization/view/user_profile/user_profile_view.dart';
import 'package:twitter_clone/feature/personalization/view/user_profile/widget/user_profile_avatar.dart';
import 'package:twitter_clone/feature/tweet/view/post_tweet_view/widgets/post_tweet_field.dart';
import 'package:twitter_clone/feature/tweet/view/post_tweet_view/widgets/post_tweet_image_view.dart';
import '../../../../data/repositories/comment_repository.dart';
import '../../../../data/repositories/tweet_repository.dart';
import '../../../../utils/constants/constants.dart';
import '../../controller/post_tweet_controller.dart';
import '../../model/tweet_model.dart';
import '../post_tweet_view/widgets/image_selection_bar_with_counter.dart';
import '../tweet_card_view/widgets/tweet_image_grid.dart';
import '../tweet_card_view/widgets/tweet_user_info_row.dart';

class TweetCommentView extends StatelessWidget {
  const TweetCommentView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CommentRepository());
    final addTweetController = Get.put(PostTweetController());
    final tweetId = Get.arguments[0];
    final tweetAuthor = Get.arguments[1] as UserModel;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_sharp),
          onPressed: () => Get.back(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(80, 36),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: Colors.blue,
              ),
              onPressed:
                  () => addTweetController.replyTweet(parentTweetId: tweetId),
              child: const Text('Reply', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
      body: StreamBuilder<TweetModel>(
        stream: TweetRepository.instance.getTweetStream(tweetId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading tweet'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final tweet = snapshot.data!;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Tweet with user info
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Left profile picture
                          UserProfileAvatar(
                            backgroundRadius: 22,
                            foregroundRadius: 22,
                            imageUrl: tweetAuthor.profileImage,
                          ),
                          const SizedBox(width: 10),

                          /// Right content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: YSizes.sm),
                                TweetUserInfoRow(
                                  tweet: tweet,
                                  isVerified: false,
                                  authorName: tweetAuthor.username,
                                  authorHandle:
                                      tweetAuthor.email.split('@').first,
                                ),
                                const SizedBox(height: 4),

                                /// Tweet content
                                Text(
                                  tweet.content,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),

                                /// Tweet images
                                if (tweet.imageUrls != null &&
                                    tweet.imageUrls!.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  TweetImageGrid(tweet: tweet),
                                ],
                                const SizedBox(height: YSizes.spaceBtwItems),

                                /// Replying to
                                Row(
                                  children: [
                                    Text(
                                      'Replying to',
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.labelMedium,
                                    ),
                                    const SizedBox(width: YSizes.sm),
                                    GestureDetector(
                                      onTap:
                                          () => Get.to(
                                            () => UserProfileView(
                                              otherUserId: tweet.authorId,
                                            ),
                                          ),
                                      child: Text(
                                        '@${tweetAuthor.email.split('@').first}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium
                                            ?.copyWith(color: Colors.blue),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: YSizes.spaceBtwItems),

                      PostTweetField(addTweetController: addTweetController),

                      PostTweetImageView(
                        addTweetController: addTweetController,
                      ),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),

              SafeArea(
                top: false,
                child: ImageSelectionBarWithCounter(
                  addTweetController: addTweetController,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
