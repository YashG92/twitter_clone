import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/feature/personalization/controller/user_controller.dart';

import '../../../data/repositories/user_repository.dart';
import '../../../utils/helpers/network_manager.dart';

class EditUserController extends GetxController {
  static EditUserController get instance => Get.find();

  @override
  void onInit() {
    super.onInit();
    name.text = UserController.instance.user.value.username;
    bio.text = UserController.instance.user.value.bio;
  }

  final name = TextEditingController();
  final bio = TextEditingController();
  final isLoading = false.obs;

  //final location = TextEditingController();
  //final website = TextEditingController();

  void updateProfile() async {
    try {
      isLoading.value = true;
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        isLoading.value = false;
        return;
      }

      if (name.text.trim().isEmpty || bio.text.trim().isEmpty) {
        isLoading.value = false;
        return;
      }

      Map<String, dynamic> json = {
        "username": name.text.trim(),
        "bio": bio.text.trim(),
      };
      await UserRepository.instance.updateSingleFieldUserData(json);

      UserController.instance.user.value.username = name.text.trim();
      UserController.instance.user.value.bio = bio.text.trim();
      UserController.instance.user.refresh();
      isLoading.value = false;
      Get.back();
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.toString());
    }
  }
}
