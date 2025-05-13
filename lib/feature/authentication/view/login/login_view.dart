import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/common/common_appbar.dart';
import 'package:twitter_clone/common/form_divider.dart';
import 'package:twitter_clone/common/google_sign_button.dart';
import 'package:twitter_clone/feature/authentication/view/login/widgets/forget_password_button.dart';
import 'package:twitter_clone/feature/authentication/view/login/widgets/login_form.dart';
import 'package:twitter_clone/utils/constants/constants.dart';

import '../../../../common/form_footer.dart';
import '../../../../routes/routes.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppbar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: YSizes.defaultSpace,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      LoginForm(),
                      SizedBox(height: YSizes.spaceBtwItems),
                      ForgetPasswordButton(),
                      FormDivider(),
                      GoogleSignButton(buttonTitle: 'Continue with Google'),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FormFooter(
              footerText: 'Don’t have an account?',
              onTap: () => Get.toNamed(Routes.signUpView),
              buttonText: 'Join',
            ),
          ),
        ],
      ),
    );
  }
}
