import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/feature/personalization/controller/follower_following_controller.dart';
import 'package:twitter_clone/feature/personalization/model/followings_model.dart';
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
import '../../../chat/controller/chat_controller.dart';
import '../../controller/user_controller.dart';

class UserProfileView extends StatelessWidget {
  const UserProfileView({super.key, this.otherUserId});

  final String? otherUserId;

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunction.isDarkMode(context);
    final userController = UserController.instance;
    final tweetController = TweetController.instance;
    final currentUid = AuthRepository.instance.authUser.uid;
    final followerFollowingController = Get.put(FollowerFollowingController());
    final isCurrentUser = otherUserId == null || otherUserId == currentUid;

    return Scaffold(
      body:
          isCurrentUser
              ? _buildCurrentUserProfile(
                context,
                dark,
                userController,
                tweetController,
                currentUid,
              )
              : _buildOtherUserProfile(
                context,
                dark,
                userController,
                tweetController,
                followerFollowingController,
                currentUid,
                otherUserId!,
              ),
      floatingActionButton:
          isCurrentUser
              ? FloatingActionButton(
                onPressed: () => Get.toNamed(Routes.addTweetView),
                shape: const CircleBorder(),
                child: const Icon(Icons.edit),
              )
              : null,
    );
  }

  Widget _buildCurrentUserProfile(
    BuildContext context,
    bool dark,
    UserController userController,
    TweetController tweetController,
    String currentUid,
  ) {
    return Obx(() {
      final user = userController.user.value;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        tweetController.fetchUserTweets(user.userId);
      });

      return _buildProfileContent(
        context: context,
        dark: dark,
        user: user,
        tweetController: tweetController,
        followerFollowingController: FollowerFollowingController.instance,
        currentUid: currentUid,
        isCurrentUser: true,
      );
    });
  }

  Widget _buildOtherUserProfile(
    BuildContext context,
    bool dark,
    UserController userController,
    TweetController tweetController,
    FollowerFollowingController followerFollowingController,
    String currentUid,
    String otherUserId,
  ) {
    return StreamBuilder<UserModel>(
      stream: userController.getUserStream(otherUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error loading profile'));
        }

        final user = snapshot.data ?? UserModel.empty();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          tweetController.fetchUserTweets(user.userId);
          // Initialize follow status listener
          followerFollowingController.listenToFollowStatus(
            currentUid,
            user.userId,
          );
        });

        return _buildProfileContent(
          context: context,
          dark: dark,
          user: user,
          tweetController: tweetController,
          followerFollowingController: followerFollowingController,
          currentUid: currentUid,
          isCurrentUser: false,
        );
      },
    );
  }

  Widget _buildProfileContent({
    required BuildContext context,
    required bool dark,
    required UserModel user,
    required TweetController tweetController,
    required FollowerFollowingController followerFollowingController,
    required String currentUid,
    required bool isCurrentUser,
  }) {
    return RefreshIndicator(
      onRefresh: () => tweetController.fetchUserTweets(user.userId),
      child: CustomScrollView(
        slivers: [
          UserProfileAppBar(user: user),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(YSizes.productImageRadius),
                    child: _buildFollowButton(
                      context: context,
                      dark: dark,
                      user: user,
                      followerFollowingController: followerFollowingController,
                      currentUid: currentUid,
                      isCurrentUser: isCurrentUser,
                    ),
                  ),
                ),
                UserMetaData(user: user),
                Divider(
                  thickness: 0.3,
                  color: dark ? Palette.darkGrey : Colors.grey,
                ),
              ],
            ),
          ),
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
                    physics: const NeverScrollableScrollPhysics(),
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
    );
  }

  Widget _buildFollowButton({
    required BuildContext context,
    required bool dark,
    required UserModel user,
    required FollowerFollowingController followerFollowingController,
    required String currentUid,
    required bool isCurrentUser,
  }) {
    if (isCurrentUser) {
      return OutlinedButton(
        onPressed: () => Get.toNamed(Routes.editUserProfileView),
        child: Text(
          'Edit Profile',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: dark ? Colors.white : Colors.black,
          ),
        ),
      );
    }

    return Obx(() {
      final chatController = ChatController.instance;
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () async {
              final chatId = await chatController.getChatId(user.userId);
              Get.toNamed(Routes.chatView, arguments: [chatId, user]);
            },
            icon: const Icon(Icons.messenger_outline),
          ),

          switch (followerFollowingController.followStatus.value) {
            FollowStatus.pending => OutlinedButton(
              onPressed: null,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey,
              ), // Disabled
              child: const Text('Pending'),
            ),
            FollowStatus.accepted => OutlinedButton(
              onPressed:
                  () =>
                      followerFollowingController.toggleFollowUser(user.userId),
              child: const Text('Following'),
            ),
            FollowStatus.rejected => OutlinedButton(
              onPressed:
                  () =>
                      followerFollowingController.toggleFollowUser(user.userId),
              child: const Text('Follow'),
            ),
          },
        ],
      );
    });
  }
}
