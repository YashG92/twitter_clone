import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/data/repositories/auth_repository.dart';
import 'package:twitter_clone/feature/personalization/view/user_profile/widget/user_profile_avatar.dart';
import 'package:twitter_clone/feature/tweet/model/tweet_model.dart';
import 'package:twitter_clone/theme/palette.dart';
import 'package:twitter_clone/utils/constants/constants.dart';
import 'package:twitter_clone/utils/helpers/helper_function.dart';

import '../../controller/like_controller.dart';
import '../../controller/tweet_controller.dart';

class TweetCardView extends StatelessWidget {
  final String tweetId;
  final bool isVerified;
  final bool isUserStream;
  final VoidCallback? onMorePressed;
  final VoidCallback? onRetweetPressed;
  final VoidCallback? onCommentPressed;
  final VoidCallback? onSharePressed;
  final tweetController = TweetController.instance;
  final likeController = LikeController.instance;

  TweetCardView({
    super.key,
    this.isVerified = false,
    required this.tweetId,
    this.onMorePressed,
    this.onRetweetPressed,
    this.onCommentPressed,
    this.onSharePressed,
    this.isUserStream = false,
  }) {
    tweetController.loadTweetStream(tweetId);
    likeController.loadUserLikes();
  }

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunction.isDarkMode(context);
    if (isUserStream) {
      tweetController.loadUserTweetStream(AuthRepository.instance.authUser.uid);
    }

    return isUserStream
        ? StreamBuilder<List<TweetModel>>(
          stream: tweetController.userTweetStream.value,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error loading tweet');
            }

            if (!snapshot.hasData) {
              return Center(child: const CircularProgressIndicator());
            }

            final tweets = snapshot.data!;
            return Column(
              children:
                  tweets
                      .map(
                        (tweet) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: EdgeInsets.only(bottom: YSizes.sm),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 1.5,
                                  color:
                                      dark
                                          ? Palette.darkGrey
                                          : Colors.grey.shade200,
                                ),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage: NetworkImage(
                                    tweet.authorProfileImage,
                                  ),
                                ),
                                SizedBox(width: YSizes.spaceBtwItems),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildUserInfoRow(context, tweet),
                                      SizedBox(height: YSizes.sm),
                                      Text(tweet.content),
                                      if (tweet.imageUrls != null &&
                                          tweet.imageUrls!.isNotEmpty) ...[
                                        SizedBox(height: YSizes.sm),
                                        _buildImageGrid(context, tweet),
                                      ],
                                      SizedBox(height: YSizes.spaceBtwItems),
                                      _buildActionButtons(context, tweet),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
            );
          },
        )
        : StreamBuilder<TweetModel>(
          stream: tweetController.tweetStream.value,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error loading tweet');
            }

            if (!snapshot.hasData) {
              return Center(child: const CircularProgressIndicator());
            }

            final tweet = snapshot.data!;
            return Padding(
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
                      backgroundImage: NetworkImage(tweet.authorProfileImage),
                    ),
                    SizedBox(width: YSizes.spaceBtwItems),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildUserInfoRow(context, tweet),
                          SizedBox(height: YSizes.sm),
                          Text(tweet.content),
                          if (tweet.imageUrls != null &&
                              tweet.imageUrls!.isNotEmpty) ...[
                            SizedBox(height: YSizes.sm),
                            _buildImageGrid(context, tweet),
                          ],
                          SizedBox(height: YSizes.spaceBtwItems),
                          _buildActionButtons(context, tweet),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
  }

  Widget _buildUserInfoRow(BuildContext context, TweetModel tweet) {
    return Row(
      children: [
        Text(
          tweet.authorHandle,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
        if (isVerified) ...[
          SizedBox(width: 4),
          Icon(Icons.verified, size: 16, color: Colors.blue),
        ],
        SizedBox(width: 4),
        Flexible(
          child: Text(
            '${tweet.authorHandle} • ${tweet.createdAt}',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Palette.darkerGrey),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Spacer(),
        IconButton(
          onPressed: onMorePressed,
          icon: Icon(Icons.more_vert, size: 18),
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, TweetModel tweet) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionButton(
          icon: Icons.chat_bubble_outline,
          count: tweet.replyCount,
          onPressed: onCommentPressed,
          context: context,
        ),
        _buildActionButton(
          icon: Icons.repeat,
          count: tweet.retweetCount,
          onPressed: onRetweetPressed,
          context: context,
        ),
        Obx(() {
          //Visibility(visible: false,child: Text(tweetController.isLiked.value.toString()),);
          return _buildActionButton(
            icon:
                likeController.isLiked(tweet.tweetId)
                    ? Icons.favorite
                    : Icons.favorite_border,
            count: tweet.likeCount,
            onPressed: () => likeController.onLikePressed(tweet.tweetId),
            context: context,
          );
        }),
        _buildActionButton(
          icon: Icons.share,
          onPressed: onSharePressed,
          context: context,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    int count = 0,
    required BuildContext context,
    VoidCallback? onPressed,
  }) {
    return Row(
      children: [
        IconButton(onPressed: onPressed, icon: Icon(icon, size: 18)),
        if (count > 0) ...[
          SizedBox(width: YSizes.sm / 2),
          Text(count.toString()),
        ],
      ],
    );
  }

  Widget _buildImageGrid(BuildContext context, TweetModel tweet) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: tweet.imageUrls!.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            tweet.imageUrls![index],
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.broken_image, color: Colors.grey);
            },
          ),
        );
      },
    );
  }
}
