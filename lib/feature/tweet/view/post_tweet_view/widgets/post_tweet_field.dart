import 'package:flutter/material.dart';

import '../../../../personalization/view/user_profile/widget/user_profile_avatar.dart';
import '../../../controller/post_tweet_controller.dart';

class PostTweetField extends StatelessWidget {
  const PostTweetField({
    super.key,
    required this.addTweetController,
  });

  final PostTweetController addTweetController;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserProfileAvatar(
          backgroundRadius: 24,
          foregroundRadius: 24,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextFormField(
            controller: addTweetController.tweetController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            minLines: 1,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "What's happening?",
            ),
          ),
        ),
      ],
    );
  }
}