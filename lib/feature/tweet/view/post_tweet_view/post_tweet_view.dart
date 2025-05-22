import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_clone/feature/personalization/view/user_profile/widget/user_profile_avatar.dart';
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
                    Row(
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
                    ),
                    Obx(() {
                      if (addTweetController.selectedImages.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: addTweetController.selectedImages.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                Container(
                                  width: 250,
                                  margin: EdgeInsets.all(YSizes.sm),
                                  child: Image.file(
                                    addTweetController.selectedImages[index],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: IconButton(
                                    onPressed:
                                        () => addTweetController.removeImage(
                                          index,
                                        ),
                                    icon: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
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
                        onPressed:
                            () => addTweetController.pickImage(
                              ImageSource.gallery,
                            ),
                        icon: Icon(Icons.photo_camera_back, color: Colors.blue),
                      ),
                      IconButton(
                        onPressed:
                            () => addTweetController.pickImage(
                              ImageSource.camera,
                            ),
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
                    return Padding(
                      padding: EdgeInsets.all(YSizes.sm),
                      child: SizedBox(
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
