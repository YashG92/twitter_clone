import 'package:flutter/material.dart';
import 'package:twitter_clone/feature/personalization/controller/user_controller.dart';

import '../../../../../theme/theme.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/helpers/helper_function.dart';

class UserProfileAvatar extends StatelessWidget {
  const UserProfileAvatar({
    super.key,
    required this.backgroundRadius,
    required this.foregroundRadius,
  });

  final double backgroundRadius;
  final double foregroundRadius;

  @override
  Widget build(BuildContext context) {
    final userController = UserController.instance;
    final dark = HelperFunction.isDarkMode(context);
    return CircleAvatar(
      radius: backgroundRadius,
      backgroundColor: dark ? Palette.darkGrey : Colors.white,
      child: CircleAvatar(
        radius: foregroundRadius,
        backgroundImage: NetworkImage(userController.user.value.profileImage),
      ),
    );
  }
}
