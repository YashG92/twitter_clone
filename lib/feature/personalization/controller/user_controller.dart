import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../data/repositories/user_repository.dart';
import '../model/user_model.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final userRepository = Get.put(UserRepository());
  Rx<UserModel> user = UserModel.empty().obs;
  final profileLoading = false.obs;

  Future<void> fetchUserRecord() async {
    try {
      profileLoading.value = true;
      final user = await userRepository.fetchUserData();
      this.user(user);
    } catch (e) {
      user(UserModel.empty());
    } finally {
      profileLoading.value = false;
    }
  }

  Future<void> saveUserData(UserCredential? userCredentials) async {
    try {
      //Refresh user record
      await fetchUserRecord();

      // Save user data if not already present
      if (userCredentials != null) {
        final user = UserModel(
          id: userCredentials.user!.uid,
          fullName: userCredentials.user!.displayName ?? '',
          email: userCredentials.user!.email ?? '',
          profilePicture: userCredentials.user!.photoURL ?? '',
        );

        // Save user data to Firestore
        await userRepository.saveUserData(user);
        this.user(user); // Update the observable user model
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
