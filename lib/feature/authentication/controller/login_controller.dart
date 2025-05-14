import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/feature/authentication/view/login/widgets/login_form.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../utils/helpers/network_manager.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final email = TextEditingController();
  final password = TextEditingController();
  final hidePassword = true.obs;
  final isLoading = false.obs;



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

      Get.snackbar(
        'Congratulations!',
        'Your account has been created successfully.',
      );
      AuthRepository.instance.screenRedirect();
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.toString());
    }
  }
}
