import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/data/repositories/user_repository.dart';
import 'package:twitter_clone/feature/personalization/model/user_model.dart';
import 'package:twitter_clone/feature/tweet/view/tweet_card_view/widgets/tweet_action_buttons_row.dart';
import 'package:twitter_clone/feature/tweet/view/tweet_card_view/widgets/tweet_image_grid.dart';
import 'package:twitter_clone/feature/tweet/view/tweet_card_view/widgets/tweet_user_info_row.dart';
import 'package:twitter_clone/utils/helpers/helper_function.dart';

import '../../../../../routes/routes.dart';
import '../../../../../theme/theme.dart';
import '../../../../../utils/constants/constants.dart';

import '../../../model/tweet_model.dart';

class TweetCardViewWidget extends StatelessWidget {
  const TweetCardViewWidget({
    super.key,
    required this.tweet,
    required this.showMoreOption,
  });

  final TweetModel tweet;
  final bool showMoreOption;

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunction.isDarkMode(context);
    return StreamBuilder<UserModel>(
      stream: UserRepository.instance.getUserById(tweet.authorId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        }
        final isRetweet = tweet.isRetweet && tweet.originalTweetId != null;
        final author = snapshot.data!;
        return GestureDetector(
          onTap:
              () => Get.toNamed(
                Routes.tweetDetailView,
                arguments: [tweet.tweetId, author],
              ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.only(bottom: YSizes.sm),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 1.5,
                    color: dark ? Palette.darkGrey : Colors.grey.shade200,
                  ),
                ),
              ),
              child: Column(
                children: [
                  if (isRetweet)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Row(
                        children: [
                          SizedBox(width: 40),
                          Icon(Icons.repeat, size: 16, color: Colors.grey),
                          SizedBox(width: 4),
                          Text(
                            'You Reposted',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: YSizes.sm),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(author.profileImage),
                      ),
                      SizedBox(width: YSizes.spaceBtwItems),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: YSizes.sm),
                            TweetUserInfoRow(
                              tweet: tweet,
                              isVerified: true,
                              authorName: author.username,
                              authorHandle: author.email.split('@').first,
                              showMoreOption: showMoreOption,
                            ),
                            Text(tweet.content),
                            if (tweet.imageUrls != null &&
                                tweet.imageUrls!.isNotEmpty) ...[
                              SizedBox(height: YSizes.sm),
                              TweetImageGrid(tweet: tweet),
                            ],
                            SizedBox(height: YSizes.spaceBtwItems),
                            TweetActionButtonsRow(tweet: tweet, author: author),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
