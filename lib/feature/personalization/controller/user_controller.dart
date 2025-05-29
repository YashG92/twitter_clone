import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../data/repositories/user_repository.dart';
import '../model/user_model.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final userRepository = Get.put(UserRepository());
  Rx<UserModel> user = UserModel.empty().obs;
  final RxList<UserModel> searchedUsers = <UserModel>[].obs;
  final profileLoading = false.obs;
  late Stream<UserModel> _userStream;
  late StreamSubscription<UserModel> _userSubscription;

  @override
  void onClose() {
    _userSubscription.cancel();
    super.onClose();
  }

  Stream<UserModel> getUserStream(String userId) {
    return userRepository.getUserDataStream(userId: userId);
  }

  void initUserStream() {
    _userStream = userRepository.getUserDataStream();
    _userSubscription = _userStream.listen(
      (userData) {
        user(userData);
      },
      onError: (error) {
        user(UserModel.empty());
        Get.snackbar('Error', error.toString());
      },
    );
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

  Future<void> searchUsers(String query) async {
    query = query.trim().toLowerCase();

    if (query.length < 2) {
      searchedUsers.clear();
      return;
    }
    final users = await UserRepository.instance.searchUsers(query);
    searchedUsers.assignAll(users);
  }

  void clearSearchResults() {
    searchedUsers.clear();
  }
}
