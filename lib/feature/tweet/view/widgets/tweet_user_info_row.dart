import 'package:flutter/material.dart';
import '../../../../theme/theme.dart';

import '../../model/tweet_model.dart';

class TweetUserInfoRow extends StatelessWidget {
  const TweetUserInfoRow({
    super.key,
    required this.tweet,
    required this.isVerified, this.onMorePressed,
  });

  final TweetModel tweet;
  final bool isVerified;
  final VoidCallback? onMorePressed;

  @override
  Widget build(BuildContext context) {
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
}
