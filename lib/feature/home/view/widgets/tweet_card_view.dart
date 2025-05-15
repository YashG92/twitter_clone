import 'package:flutter/material.dart';
import 'package:twitter_clone/feature/personalization/view/user_profile/widget/user_profile_avatar.dart';
import 'package:twitter_clone/theme/palette.dart';
import 'package:twitter_clone/utils/constants/constants.dart';
import 'package:twitter_clone/utils/helpers/helper_function.dart';

class TweetCardView extends StatelessWidget {
  final String userName;
  final String userHandle;
  final String content;
  final String timeAgo;
  final int commentCount;
  final int retweetCount;
  final int likeCount;
  final bool isVerified;
  final VoidCallback? onMorePressed;
  final VoidCallback? onLikePressed;
  final VoidCallback? onRetweetPressed;
  final VoidCallback? onCommentPressed;
  final VoidCallback? onSharePressed;

  const TweetCardView({
    super.key,
    required this.userName,
    required this.userHandle,
    required this.content,
    required this.timeAgo,
    this.commentCount = 0,
    this.retweetCount = 0,
    this.likeCount = 0,
    this.isVerified = false,
    this.onMorePressed,
    this.onLikePressed,
    this.onRetweetPressed,
    this.onCommentPressed,
    this.onSharePressed,
  });

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunction.isDarkMode(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.only(bottom: YSizes.sm),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 0.3,
              color: dark ? Palette.darkGrey : Colors.grey.shade200,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            UserProfileAvatar(backgroundRadius: 20, foregroundRadius: 20),
            SizedBox(width: YSizes.spaceBtwItems),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUserInfoRow(context),
                  SizedBox(height: YSizes.sm),
                  Text(content),
                  SizedBox(height: YSizes.spaceBtwItems),
                  _buildActionButtons(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoRow(BuildContext context) {
    return Row(
      children: [
        Text(
          userName,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        if (isVerified) ...[
          SizedBox(width: 4),
          Icon(
            Icons.verified,
            size: 16,
            color: Colors.blue,
          ),
        ],
        SizedBox(width: 4),
        Flexible(
          child: Text(
            '$userHandle • $timeAgo',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Palette.darkerGrey,
            ),
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

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionButton(
          icon: Icons.chat_bubble_outline,
          count: commentCount,
          onPressed: onCommentPressed,
          context: context,
        ),
        _buildActionButton(
          icon: Icons.repeat,
          count: retweetCount,
          onPressed: onRetweetPressed,
          context: context,
        ),
        _buildActionButton(
          icon: Icons.favorite_border,
          count: likeCount,
          onPressed: onLikePressed,
          context: context,
        ),
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
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon, size: 18, color: HelperFunction.isDarkMode(context) ? Colors.white : Colors.black),
        ),
        if (count > 0) ...[
          SizedBox(width: YSizes.sm / 2),
          Text(
            count.toString(),
          ),
        ],
      ],
    );
  }
}