import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/constants.dart';
import '../../../../../utils/helpers/validators.dart';
import '../../../controller/login_controller.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  static final loginFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Form(
      key: loginFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: controller.email,
            validator: (value) => Validator.validateEmail(value),
            decoration: InputDecoration(hintText: 'Enter email'),
          ),
          SizedBox(height: YSizes.spaceBtwInputFields),
          Obx(
            () => TextFormField(
              controller: controller.password,
              validator: (value) => Validator.validatePassword(value),
              obscureText: controller.hidePassword.value,
              decoration: InputDecoration(
                hintText: 'Enter password',
                suffixIcon: IconButton(
                  onPressed:
                      () =>
                          controller.hidePassword.value =
                              !controller.hidePassword.value,
                  icon:
                      controller.hidePassword.value
                          ? const Icon(CupertinoIcons.eye_slash_fill)
                          : const Icon(CupertinoIcons.eye),
                ),
              ),
            ),
          ),
          SizedBox(height: YSizes.spaceBtwSections),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => controller.login(),
              child: Text('Email Login'),
            ),
          ),
        ],
      ),
    );
  }
}
