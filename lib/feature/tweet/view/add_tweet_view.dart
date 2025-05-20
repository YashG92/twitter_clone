import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/feature/personalization/view/user_profile/widget/user_profile_avatar.dart';
import 'package:twitter_clone/utils/constants/constants.dart';

import '../add_tweet_controller.dart';

class AddTweetView extends StatelessWidget {
  const AddTweetView({super.key});

  @override
  Widget build(BuildContext context) {
    final addTweetController = Get.put(AddTweetController());
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
                    addTweetController.isButtonEnabled.value ? () {} : null,
                child: Text('Tweet'),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(YSizes.sm),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserProfileAvatar(backgroundRadius: 24, foregroundRadius: 24),
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
            ),
            Spacer(),
            Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
              ),
              height: Get.height * 0.06,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.photo_camera_back, color: Colors.blue),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  Obx(() {
                    final remaining = addTweetController.remainingChars.value;
                    final progressValue = (remaining / 280);
                    final isOverLimit = remaining < 0;
                    return SizedBox(
                      height: 28,
                      width: 28,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            strokeWidth: 3,
                            backgroundColor: Colors.grey,
                            value: progressValue,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isOverLimit ? Colors.red : Colors.blue,
                            ),
                          ),
                          Text(
                            remaining.toString(),
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall!.copyWith(
                              fontSize: 10,
                              color: isOverLimit ? Colors.red : Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
