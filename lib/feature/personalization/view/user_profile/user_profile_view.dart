import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/feature/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/feature/tweet/view/tweet_card_view/tweet_card_view.dart';
import 'package:twitter_clone/feature/personalization/view/user_profile/widget/user_meta_data.dart';
import 'package:twitter_clone/feature/personalization/view/user_profile/widget/user_profile_app_bar.dart';
import 'package:twitter_clone/routes/routes.dart';
import 'package:twitter_clone/theme/palette.dart';
import 'package:twitter_clone/utils/constants/constants.dart';
import 'package:twitter_clone/utils/helpers/helper_function.dart';

import '../../controller/user_controller.dart';

class UserProfileView extends StatelessWidget {
  const UserProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunction.isDarkMode(context);
    final userController = UserController.instance;
    final tweetController = TweetController.instance;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh:
            () => tweetController.fetchUserTweets(
              userController.user.value.userId,
            ),
        child: CustomScrollView(
          slivers: [
            // AppBar with cover picture
            UserProfileAppBar(),

            // Profile Content
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Edit button
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(YSizes.productImageRadius),
                      child: OutlinedButton(
                        onPressed:
                            () => Get.toNamed(Routes.editUserProfileView),
                        child: Text(
                          'Edit Profile',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium!.copyWith(
                            color: dark ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // User Info
                  UserMetaData(),
                  Divider(
                    thickness: 0.3,
                    color: dark ? Palette.darkGrey : Colors.grey,
                  ),
                ],
              ),
            ),

            // Tweets or Posts
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Obx(() {
                    final tweets = tweetController.userTweets;
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: tweets.length,
                      itemBuilder: (context, index) {
                        final tweet = tweets[index];
                        return TweetCardView(
                          isUserStream: false,
                          tweetId: tweet.tweetId,
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.addTweetView),
        shape: CircleBorder(),
        child: Icon(Icons.edit),
      ),
    );
  }
}
