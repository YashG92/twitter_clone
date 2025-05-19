import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../data/repositories/user_repository.dart';
import '../model/user_model.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final userRepository = Get.put(UserRepository());
  Rx<UserModel> user = UserModel.empty().obs;
  final profileLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserRecord();
  }

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
      if (userCredentials == null) return;

      final userId = userCredentials.user!.uid;

      final existingUser = await userRepository.fetchUserData(userId: userId);

      if (existingUser.userId.isNotEmpty) {
        user(existingUser);
      } else {
        final newUser = UserModel(
          userId: userId,
          username: userCredentials.user!.displayName ?? '',
          email: userCredentials.user!.email ?? '',
          profileImage: userCredentials.user!.photoURL ?? '',
          coverImage: '',
          bio: '',
          followerCount: 0,
          followingCount: 0,
          tweetCount: 0,
          createdAt: DateTime.now(),
        );

        await userRepository.saveUserData(newUser);
        user(newUser);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
