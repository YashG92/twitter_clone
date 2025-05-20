import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddTweetController extends GetxController {
  static AddTweetController get instance => Get.find();

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
}
