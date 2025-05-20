import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AddTweetController extends GetxController{
  static AddTweetController get instance => Get.find();

  final tweetController = TextEditingController();
  final maxTweetLength = 280;
  final remainingChars  = 280.obs;
  final isButtonEnabled = false.obs;

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
    isButtonEnabled.value = tweetController.text.isNotEmpty &&
        remainingChars.value >= 0;
  }
}