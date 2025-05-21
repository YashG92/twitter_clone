import 'package:get/get.dart';
import 'package:twitter_clone/data/repositories/likes_repository.dart';
import 'package:twitter_clone/data/repositories/tweet_repository.dart';
import 'package:twitter_clone/data/repositories/user_repository.dart';
import 'package:twitter_clone/feature/tweet/controller/like_controller.dart';
import 'package:twitter_clone/utils/helpers/network_manager.dart';

import '../feature/personalization/controller/user_controller.dart';

class GeneralBindings extends Bindings{
  @override
  void dependencies() {
    Get.put(NetworkManager());
    Get.put(UserController());
  }
}