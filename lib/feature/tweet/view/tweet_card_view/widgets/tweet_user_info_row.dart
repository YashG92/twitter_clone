import 'package:flutter/material.dart';
import 'package:twitter_clone/utils/helpers/helper_function.dart';
import '../../../../../theme/theme.dart';

import '../../../model/tweet_model.dart';

class TweetUserInfoRow extends StatelessWidget {
  const TweetUserInfoRow({
    super.key,
    required this.tweet,
    required this.isVerified,
    this.onMorePressed,
    required this.authorName,
    required this.authorHandle,
    this.showMoreOption = true,
  });

  final TweetModel tweet;
  final String authorName;
  final String authorHandle;
  final bool isVerified;
  final bool showMoreOption;
  final VoidCallback? onMorePressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Author name
        Text(
          authorName,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),

        /// Verified icon (if applicable)
        if (isVerified) ...[
          const SizedBox(width: 4),
          const Icon(Icons.verified, size: 16, color: Colors.blue),
        ],

        /// Handle and time ago
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            '@$authorHandle • ${HelperFunction.getTimeAgo(tweet.createdAt)}',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Palette.darkerGrey),
            overflow: TextOverflow.ellipsis,
          ),
        ),

        /// More button
        if (showMoreOption)
          IconButton(
            onPressed: onMorePressed,
            icon: const Icon(Icons.more_vert, size: 18),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
      ],
    );
  }
}
