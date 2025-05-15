import 'package:flutter/material.dart';
import 'package:twitter_clone/feature/personalization/view/user_profile/widget/user_profile_avatar.dart';
import 'package:twitter_clone/utils/constants/constants.dart';
import 'package:twitter_clone/utils/helpers/helper_function.dart';

import '../theme/palette.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({
    super.key,
    this.isBackArrow = false,
    required this.title,
  });

  final bool isBackArrow;
  final String title;

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunction.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: YSizes.sm),
      child: Container(
        padding: EdgeInsets.only(bottom: YSizes.sm/2),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 0.3,
              color: dark ? Palette.darkGrey : Colors.grey.shade200,
            ),
          ),
        ),
        child: AppBar(
          automaticallyImplyLeading: isBackArrow,
          backgroundColor: dark ? Palette.darkBackgroundColor : Colors.white,
          //centerTitle: true,
          leading: Builder(
            builder: (context) => GestureDetector(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: UserProfileAvatar(backgroundRadius: 1, foregroundRadius: 28),
            ),
          ),
          title: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w200,fontSize: 22),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.settings_outlined, color: dark ? Colors.white : Colors.blue),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
