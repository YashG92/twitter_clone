import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/common/common_appbar.dart';
import 'package:twitter_clone/common/form_divider.dart';
import 'package:twitter_clone/common/google_sign_button.dart';
import 'package:twitter_clone/feature/authentication/view/login/login_view.dart';
import 'package:twitter_clone/routes/routes.dart';
import 'package:twitter_clone/utils/constants/constants.dart';
import 'package:twitter_clone/feature/authentication/view/signup/widget/signup_form.dart';

import '../../../../common/form_footer.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppbar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: YSizes.defaultSpace),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SignupForm(),
                        FormDivider(),
                        GoogleSignButton(buttonTitle: 'Sign Up with Google'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FormFooter(
                footerText: 'Already have an account?',
                onTap: () => Get.toNamed( Routes.loginView),
                buttonText: 'Log In',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
