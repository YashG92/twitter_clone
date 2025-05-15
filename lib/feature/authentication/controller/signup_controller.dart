import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/data/repositories/auth_repository.dart';
import 'package:twitter_clone/data/repositories/user_repository.dart';
import 'package:twitter_clone/feature/authentication/view/signup/widgets/signup_form.dart';
import 'package:twitter_clone/feature/personalization/model/user_model.dart';
import 'package:twitter_clone/routes/routes.dart';

import '../../../utils/helpers/network_manager.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  final fullName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final hidePassword = true.obs;
  final isLoading = false.obs;

  signup() async {
    try {
      isLoading.value = true;
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        isLoading.value = false;
        return;
      }

      if (!SignupForm.signUpFormKey.currentState!.validate()) {
        isLoading.value = false;
        return;
      }

      if (password.text.trim() != confirmPassword.text.trim()) {
        isLoading.value = false;
        Get.snackbar('Error', 'Passwords do not match.');
        return;
      }

      final userCredential = await AuthRepository.instance
          .registerWithEmailAndPassword(
            email.text.trim(),
            password.text.trim(),
          );

      final newUser = UserModel(
        id: userCredential.user!.uid,
        fullName: fullName.text.trim(),
        email: email.text.trim(),
        profilePicture: '',
      );

      final userRepository = Get.put(UserRepository());
      await userRepository.saveUserData(newUser);
      isLoading.value = false;

      Get.snackbar(
        'Congratulations!',
        'Your account has been created successfully.',
      );
      Get.offAndToNamed(Routes.bottomNavBar);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.toString());
    }
  }
}
