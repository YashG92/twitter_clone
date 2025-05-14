import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/utils/constants/constants.dart';
import 'package:twitter_clone/utils/constants/image_strings.dart';

import '../feature/authentication/controller/login_controller.dart';

class GoogleSignButton extends StatelessWidget {
  const GoogleSignButton({super.key, required this.buttonTitle});

  final String buttonTitle;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Column(
      children: [
        SizedBox(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 3,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shadowColor: Colors.grey,
              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            onPressed: () => controller.googleSignIn(),
            child: Row(
              spacing: YSizes.spaceBtwItems / 2,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Image(
                  image: AssetImage(ImageStrings.googleLogo),
                  height: YSizes.xl,
                  width: YSizes.xl,
                ),
                Text(buttonTitle, style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
