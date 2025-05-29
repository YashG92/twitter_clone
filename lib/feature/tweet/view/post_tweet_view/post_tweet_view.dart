import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/feature/tweet/view/post_tweet_view/widgets/image_selection_bar_with_counter.dart';
import 'package:twitter_clone/feature/tweet/view/post_tweet_view/widgets/post_tweet_field.dart';
import 'package:twitter_clone/feature/tweet/view/post_tweet_view/widgets/post_tweet_image_view.dart';
import 'package:twitter_clone/utils/constants/constants.dart';

import '../../controller/post_tweet_controller.dart';

class PostTweetView extends StatelessWidget {
  const PostTweetView({super.key});

  @override
  Widget build(BuildContext context) {
    final addTweetController = Get.put(PostTweetController());
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close_sharp),
          onPressed: () => Get.back(),
        ),
        actions: [
          Obx(
            () => SizedBox(
              width: 80,
              height: 46,
              child: ElevatedButton(
                onPressed:
                    addTweetController.isButtonEnabled.value
                        ? () => addTweetController.postTweet()
                        : null,
                child: Text('Tweet'),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(YSizes.sm),
                child: Column(
                  children: [
                    PostTweetField(addTweetController: addTweetController),
                    PostTweetImageView(addTweetController: addTweetController),
                  ],
                ),
              ),
            ),
            ImageSelectionBarWithCounter(
              addTweetController: addTweetController,
            ),
          ],
        ),
      ),
    );
  }
}
