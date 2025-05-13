import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/utils/helper_function.dart';

class CommonAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppbar({super.key, this.isBackArrow = false});

  final bool isBackArrow;

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunction.isDarkMode(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: YSizes.sm),
      child: AppBar(
        automaticallyImplyLeading: isBackArrow,
        centerTitle: true,
        title: Hero(
          tag: 'logo',
          child: SvgPicture.asset(
              dark ? AssetsConstants.darkAppLogo : AssetsConstants.lightAppLogo),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
