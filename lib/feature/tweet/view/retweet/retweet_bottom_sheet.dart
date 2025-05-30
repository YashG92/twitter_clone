import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/feature/tweet/controller/post_tweet_controller.dart';
import 'package:twitter_clone/feature/tweet/controller/retweet_controller.dart';
import 'package:twitter_clone/utils/constants/constants.dart';

class RetweetBottomSheet extends StatelessWidget {
  final VoidCallback onRepost;
  final VoidCallback onQuote;

  const RetweetBottomSheet({
    super.key,
    required this.onRepost,
    required this.onQuote,
  });

  @override
  Widget build(BuildContext context) {
    Get.put(PostTweetController());
    Get.put(RetweetController());
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(YSizes.sm),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.repeat, color: Colors.green),
              title: const Text('Repost'),
              subtitle: const Text('Share this post with your followers'),
              onTap: () {
                Navigator.pop(context);
                onRepost();
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.blue),
              title: const Text('Quote'),
              subtitle: const Text(
                'Add a comment or photo before you share this post',
              ),
              onTap: () {
                Navigator.pop(context);
                onQuote();
              },
            ),
          ],
        ),
      ),
    );
  }
}
