import 'package:get/get.dart';
import 'package:twitter_clone/utils/helpers/network_manager.dart';

import '../feature/personalization/controller/user_controller.dart';

class GeneralBindings extends Bindings{
  @override
  void dependencies() {
    Get.put(NetworkManager());
    Get.put(UserController());
  }
}