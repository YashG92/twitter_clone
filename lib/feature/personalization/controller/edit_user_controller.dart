import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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
    //location.text = UserController.instance.user.value.location;
    //website.text = UserController.instance.user.value.website;
    profileImageUrl = UserController.instance.user.value.profileImage;
    coverImageUrl = UserController.instance.user.value.coverImage;
  }

  final name = TextEditingController();
  final bio = TextEditingController();
  final profileImageFile = Rx<File?>(null);
  String? profileImageUrl;
  final coverImageFile = Rx<File?>(null);
  String? coverImageUrl;
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

      if (profileImageFile.value != null) {
        profileImageUrl = await UserRepository.instance.uploadImage(
          'Users/Images/Profile',
          XFile(profileImageFile.value!.path),
        );
      }
      if (coverImageFile.value != null) {
        coverImageUrl = await UserRepository.instance.uploadImage(
          'Users/Images/Cover',
          XFile(coverImageFile.value!.path),
        );
      }

      Map<String, dynamic> json = {
        "username": name.text.trim(),
        "bio": bio.text.trim(),
        //"location": location.text.trim(),
        //"website": website.text.trim(),
        "profileImage": profileImageUrl,
        "coverImage": coverImageUrl,
      };
      await UserRepository.instance.updateSingleFieldUserData(json);

      UserController.instance.user.value.username = name.text.trim();
      UserController.instance.user.value.bio = bio.text.trim();
      //UserController.instance.user.value.location = location.text.trim();
      //UserController.instance.user.value.website = website.text.trim();
      UserController.instance.user.value.profileImage = profileImageUrl!;
      UserController.instance.user.value.coverImage = coverImageUrl!;
      UserController.instance.user.refresh();
      isLoading.value = false;
      Get.back();
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> pickImage({required bool isCover}) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (isCover) {
        coverImageFile.value = File(pickedFile.path);
      } else {
        profileImageFile.value = File(pickedFile.path);
      }
    }
  }
}
