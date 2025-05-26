import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../model/followers_model.dart';
import '../model/followings_model.dart';

class FollowerFollowingRepository extends GetxController {
  static FollowerFollowingRepository get instance => Get.find();

  final _repository = Get.put(FollowerFollowingRepository());

  var isFollowing = false.obs;
  var followers = <FollowersModel>[].obs;
  var following = <FollowingsModel>[].obs;
  var followerCount = 0.obs;
  var followingCount = 0.obs;
  var isLoading = false.obs;
  late String targetUserId;
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

  void initialize(String userId){
    targetUserId = userId;
    _setupStreams();
  }

  void _setupStreams(){

  }
}
