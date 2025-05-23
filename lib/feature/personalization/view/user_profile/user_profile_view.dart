import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/feature/personalization/model/user_model.dart';
import 'package:twitter_clone/feature/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/feature/tweet/view/tweet_card_view/tweet_card_view.dart';
import 'package:twitter_clone/feature/personalization/view/user_profile/widget/user_meta_data.dart';
import 'package:twitter_clone/feature/personalization/view/user_profile/widget/user_profile_app_bar.dart';
import 'package:twitter_clone/routes/routes.dart';
import 'package:twitter_clone/theme/palette.dart';
import 'package:twitter_clone/utils/constants/constants.dart';
import 'package:twitter_clone/utils/helpers/helper_function.dart';

import '../../../../data/repositories/auth_repository.dart';
import '../../controller/user_controller.dart';

class UserProfileView extends StatelessWidget {
  const UserProfileView({super.key, this.otherUser});

  final UserModel? otherUser;

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunction.isDarkMode(context);
    final userController = UserController.instance;
    final tweetController = TweetController.instance;
    final currentUid = AuthRepository.instance.authUser.uid;
    final user = otherUser ?? userController.user.value;
    tweetController.fetchUserTweets(user.userId);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh:
            () => tweetController.fetchUserTweets(
              user.userId,
            ),
        child: CustomScrollView(
          slivers: [
            // AppBar with cover picture
            UserProfileAppBar(user: user),

            // Profile Content
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Edit button
                  if (otherUser == null)
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(
                          YSizes.productImageRadius,
                        ),
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
                    )
                  else
                    SizedBox(height: 80),

                  // User Info
                  UserMetaData(user: user),
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
                    final tweets = [
                      ...tweetController.userTweets,
                      ...tweetController.userReTweets,
                    ]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
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
                          showMoreOption: tweet.authorId == currentUid,
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
      floatingActionButton:
          otherUser == null
              ? FloatingActionButton(
                onPressed: () => Get.toNamed(Routes.addTweetView),
                shape: CircleBorder(),
                child: Icon(Icons.edit),
              )
              : null,
    );
  }
}
