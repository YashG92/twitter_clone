import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/data/repositories/auth_repository.dart';
import 'package:twitter_clone/feature/authentication/view/login/forget_password_view.dart';

import '../../../utils/helpers/network_manager.dart';

class ForgotPasswordController extends GetxController {
  static ForgotPasswordController get instance => Get.find();

  final email = TextEditingController();

  final isResendButtonOn = true.obs;
  final countdown = 0.obs;
  final isLoading = false.obs;
  Timer? _countdownTimer;

  @override
  void dispose() {
    ForgotPasswordController.instance.resetCountdown();
    super.dispose();
  }

  @override
  void onClose() {
    _countdownTimer?.cancel();
    super.onClose();
  }

  void sendPasswordResetEmail() async {
    try {
      isLoading.value = true;
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        isLoading.value = false;
        return;
      }
      if (!ForgotPasswordView.forgotPasswordFormKey.currentState!.validate()) {
        isLoading.value = false;
        return;
      }

      await AuthRepository.instance.sendPasswordResetEmail(email.text.trim());
      isLoading.value = false;
      Get.snackbar('Success', 'Password reset email sent');
      setCountdown();
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.toString());
    }
  }

  void resendPasswordResetEmail() async {
    await AuthRepository.instance.sendPasswordResetEmail(email.text.trim());
    Get.snackbar('Success', 'Password reset email sent');
    setCountdown();
  }

  void setCountdown() {
    isResendButtonOn.value = false;
    countdown.value = 30;
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--;
      } else {
        _countdownTimer?.cancel();
        isResendButtonOn.value = true;
      }
    });
  }

  void resetCountdown() {
    _countdownTimer?.cancel();
    countdown.value = 0;
    isResendButtonOn.value = true;
  }
}
