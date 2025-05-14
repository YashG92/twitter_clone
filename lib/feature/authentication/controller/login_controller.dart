import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/feature/authentication/view/login/widgets/login_form.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../utils/helpers/network_manager.dart';
import '../../personalization/controller/user_controller.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final email = TextEditingController();
  final password = TextEditingController();
  final hidePassword = true.obs;
  final isLoading = false.obs;
  final userController = Get.put(UserController());

  login() async {
    try {
      isLoading.value = true;
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        isLoading.value = false;
        return;
      }

      if (!LoginForm.loginFormKey.currentState!.validate()) {
        isLoading.value = false;
        return;
      }

      final userCredential = await AuthRepository.instance
          .loginWithEmailAndPassword(email.text.trim(), password.text.trim());

      isLoading.value = false;

      Get.snackbar('Congratulations!', 'You have successfully logged in.');
      AuthRepository.instance.screenRedirect();
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> googleSignIn() async {
    try {
      //Start Loading
      isLoading.value = true;

      //Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        isLoading.value = false;
        return;
      }

      //Google authentication
      final userCredentials = await AuthRepository.instance.googleSignIn();
      //save user record

      await userController.saveUserData(userCredentials);

      isLoading.value = false;

      //Show success message
      Get.snackbar('Congratulations!', 'You have successfully logged in.');

      //Move to Screen
      AuthRepository.instance.screenRedirect();
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.toString());
    }
  }
}
