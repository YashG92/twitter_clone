import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/utils/constants/constants.dart';

import '../../../../../utils/helpers/validators.dart';
import '../../../controller/signup_controller.dart';

class SignupForm extends StatelessWidget {
  const SignupForm({super.key});

  static final signUpFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());
    return Form(
      key: signUpFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: controller.fullName,
                validator:
                    (value) => Validator.validateEmptyText('Full Name', value),
                decoration: InputDecoration(hintText: 'Name'),
              ),
              SizedBox(height: YSizes.spaceBtwInputFields),
              TextFormField(
                controller: controller.email,
                validator: (value) => Validator.validateEmail(value),
                decoration: InputDecoration(hintText: 'Enter email'),
              ),
              SizedBox(height: YSizes.spaceBtwInputFields),
              TextFormField(
                controller: controller.password,
                validator: (value) => Validator.validatePassword(value),
                obscureText: true,
                decoration: InputDecoration(hintText: 'Enter password'),
              ),
              SizedBox(height: YSizes.spaceBtwInputFields),
              Obx(
                () => TextFormField(
                  controller: controller.confirmPassword,
                  validator: (value) => Validator.validatePassword(value),
                  obscureText: controller.hidePassword.value,
                  decoration: InputDecoration(
                    hintText: 'Confirm password',
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
              SizedBox(height: YSizes.spaceBtwInputFields),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.signup(),
                  child: Obx(
                    () =>
                        controller.isLoading.value
                            ? CircularProgressIndicator(color: Colors.white,)
                            : Text('Sign Up'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
