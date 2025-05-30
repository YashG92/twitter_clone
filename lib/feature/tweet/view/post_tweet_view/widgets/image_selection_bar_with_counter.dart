import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../utils/constants/constants.dart';

import '../../../controller/post_tweet_controller.dart';

class ImageSelectionBarWithCounter extends StatelessWidget {
  const ImageSelectionBarWithCounter({
    super.key,
    required this.addTweetController,
  });

  final PostTweetController addTweetController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
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
                    () => addTweetController.pickImage(ImageSource.gallery),
                icon: const Icon(Icons.photo_camera_back, color: Colors.blue),
              ),
              IconButton(
                onPressed:
                    () => addTweetController.pickImage(ImageSource.camera),
                icon: const Icon(Icons.camera_alt_outlined, color: Colors.blue),
              ),
            ],
          ),
          Obx(() {
            final remaining = addTweetController.remainingChars.value;
            final progressValue = (remaining / 280);
            final isOverLimit = remaining < 0;
            return Padding(
              padding: const EdgeInsets.all(YSizes.sm),
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
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
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
    );
  }
}
