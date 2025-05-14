// views/forgot_password_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/utils/constants/constants.dart';
import 'package:twitter_clone/utils/helpers/validators.dart';

import '../../controller/forgot_password_controller.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  static final forgotPasswordFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgotPasswordController());
    return Scaffold(
      appBar: AppBar(title: Text('Forgot Password'), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(YSizes.defaultSpace),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Form(
                        key: forgotPasswordFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              controller: controller.email,
                              validator:
                                  (value) => Validator.validateEmail(value),
                              decoration: InputDecoration(
                                hintText: 'Enter email',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: YSizes.spaceBtwItems),
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      () =>
                          controller.isResendButtonOn.value
                              ? controller.sendPasswordResetEmail()
                              : null,
                  child:
                      controller.isResendButtonOn.value
                          ? Text('Send Email')
                          : Text('Wait for ${controller.countdown.value} s'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
