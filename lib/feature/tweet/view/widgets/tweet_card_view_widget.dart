import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/data/repositories/user_repository.dart';
import 'package:twitter_clone/feature/personalization/controller/user_controller.dart';
import 'package:twitter_clone/feature/personalization/model/user_model.dart';
import 'package:twitter_clone/feature/tweet/view/widgets/tweet_action_buttons_row.dart';
import 'package:twitter_clone/feature/tweet/view/widgets/tweet_image_grid.dart';
import 'package:twitter_clone/feature/tweet/view/widgets/tweet_user_info_row.dart';
import 'package:twitter_clone/utils/helpers/helper_function.dart';

import '../../../../routes/routes.dart';
import '../../../../theme/theme.dart';
import '../../../../utils/constants/constants.dart';

import '../../model/tweet_model.dart';

class TweetCardViewWidget extends StatelessWidget {
  const TweetCardViewWidget({
    super.key,
    required this.tweet,
  });

  final TweetModel tweet;

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunction.isDarkMode(context);
    return StreamBuilder<UserModel>(
      stream: UserRepository.instance.getUserById(tweet.authorId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        }
        final author = snapshot.data!;
        return GestureDetector(
          onTap: () => Get.toNamed(Routes.tweetDetailView, arguments: tweet.tweetId),
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
              child: Row(
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
                        TweetUserInfoRow(tweet: tweet, isVerified: true),
                        SizedBox(height: YSizes.sm),
                        Text(tweet.content),
                        if (tweet.imageUrls != null &&
                            tweet.imageUrls!.isNotEmpty) ...[
                          SizedBox(height: YSizes.sm),
                          TweetImageGrid(tweet: tweet),
                        ],
                        SizedBox(height: YSizes.spaceBtwItems),
                        TweetActionButtonsRow(tweet: tweet),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
