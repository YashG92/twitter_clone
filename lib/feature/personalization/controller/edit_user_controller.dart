import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditUserController extends GetxController {
  static EditUserController get instance => Get.find();

  final name = TextEditingController();
  final bio = TextEditingController();
  //final location = TextEditingController();
  //final website = TextEditingController();

}