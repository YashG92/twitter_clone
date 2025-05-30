import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/data/repositories/user_repository.dart';
import 'package:twitter_clone/feature/personalization/model/user_model.dart';
import 'package:twitter_clone/feature/personalization/view/user_profile/widget/user_profile_avatar.dart';
import 'package:twitter_clone/feature/tweet/view/tweet_card_view/widgets/tweet_action_buttons_row.dart';
import 'package:twitter_clone/feature/tweet/view/tweet_card_view/widgets/tweet_image_grid.dart';
import 'package:twitter_clone/feature/tweet/view/tweet_card_view/widgets/tweet_user_info_row.dart';
import 'package:twitter_clone/utils/helpers/helper_function.dart';

import '../../../../../routes/routes.dart';
import '../../../../../theme/theme.dart';
import '../../../../../utils/constants/constants.dart';

import '../../../../personalization/view/user_profile/user_profile_view.dart';
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

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.only(bottom: YSizes.sm),
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
                  const Padding(
                    padding: EdgeInsets.only(bottom: 4.0),
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
                const SizedBox(height: YSizes.sm),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap:
                          () => Get.to(
                            () => UserProfileView(otherUserId: author.userId),
                          ),
                      child: UserProfileAvatar(
                        backgroundRadius: 20,
                        foregroundRadius: 20,
                        imageUrl: author.profileImage,
                      ),
                    ),
                    const SizedBox(width: YSizes.spaceBtwItems),
                    Expanded(
                      child: GestureDetector(
                        onTap:
                            () => Get.toNamed(
                              Routes.tweetDetailView,
                              arguments: [tweet.tweetId, author],
                            ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: YSizes.sm),
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
                              const SizedBox(height: YSizes.sm),
                              TweetImageGrid(tweet: tweet),
                            ],
                            const SizedBox(height: YSizes.spaceBtwItems),
                            // Action buttons - not part of the tappable area
                            TweetActionButtonsRow(tweet: tweet, author: author),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
