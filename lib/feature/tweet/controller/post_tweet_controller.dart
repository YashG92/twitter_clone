import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_clone/feature/tweet/controller/tweet_controller.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/tweet_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../utils/helpers/network_manager.dart';
import '../model/tweet_model.dart';

class PostTweetController extends GetxController {
  static PostTweetController get instance => Get.find();

  final isLoading = false.obs;
  final tweetController = TextEditingController();
  final maxTweetLength = 280;
  final remainingChars = 280.obs;
  final isButtonEnabled = false.obs;
  final selectedImages = <File>[].obs;
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    tweetController.addListener(_updateCharacterCount);
  }

  @override
  void onClose() {
    tweetController.removeListener(_updateCharacterCount);
    tweetController.dispose();
    super.onClose();
  }

  void _updateCharacterCount() {
    remainingChars.value = maxTweetLength - tweetController.text.length;
    isButtonEnabled.value =
        tweetController.text.isNotEmpty && remainingChars.value >= 0;
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1000,
      );
      if (pickedFile != null) {
        selectedImages.add(File(pickedFile.path));
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong while picking image: ${e.toString()}',
      );
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
    }
  }

  Future<void> postTweet() async {
    try {
      isLoading.value = true;
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        isLoading.value = false;
        return;
      }
      if (tweetController.text.isEmpty) {
        isLoading.value = false;
        return;
      }
      List<String> imageUrls = [];

      if (selectedImages.isNotEmpty) {
        for (var image in selectedImages) {
          final url = await UserRepository.instance.uploadImage(
            'Users/Images/Tweets',
            XFile(image.path),
          );
          imageUrls.add(url);
        }
      }

      final newTweet = TweetModel(
        tweetId: '',
        content: tweetController.text,
        authorId: AuthRepository.instance.authUser.uid,
        authorHandle: AuthRepository.instance.authUser.email!.split('@')[0],
        authorProfileImage: AuthRepository.instance.authUser.photoURL!,
        likeCount: 0,
        replyCount: 0,
        retweetCount: 0,
        imageUrls: imageUrls,
        createdAt: DateTime.now(),
      );

      newTweet.tweetId = await TweetRepository.instance.postTweet(newTweet);
      UserRepository.instance.updateSingleFieldUserData({
        'tweetCount': FieldValue.increment(1),
      });
      TweetController.instance.allTweets.insert(0, newTweet);
      TweetController.instance.allTweets.refresh();
      TweetController.instance.userTweets.insert(0,newTweet);
      TweetController.instance.userTweets.refresh();

      isLoading.value = false;
      Get.back();
      Get.snackbar('Success', 'Tweet posted successfully');
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.toString());
    }
  }
}
