import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/constants.dart';

import '../../../controller/post_tweet_controller.dart';

class PostTweetImageView extends StatelessWidget {
  const PostTweetImageView({super.key, required this.addTweetController});

  final PostTweetController addTweetController;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
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
                  margin: const EdgeInsets.all(YSizes.sm),
                  child: Image.file(
                    addTweetController.selectedImages[index],
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    onPressed: () => addTweetController.removeImage(index),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ],
            );
          },
        ),
      );
    });
  }
}
