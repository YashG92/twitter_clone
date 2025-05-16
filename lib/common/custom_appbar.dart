import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/feature/personalization/view/user_profile/widget/user_profile_avatar.dart';
import 'package:twitter_clone/feature/search/widget/search_container.dart';
import 'package:twitter_clone/routes/routes.dart';
import 'package:twitter_clone/utils/constants/constants.dart';
import 'package:twitter_clone/utils/helpers/helper_function.dart';

import '../feature/search/searched_content_view.dart';
import '../theme/palette.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({
    super.key,
    this.isBackArrow = false,
    required this.title,
    this.isSearch = false,
  });

  final bool isBackArrow;
  final bool isSearch;
  final String title;

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunction.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: YSizes.sm),
      child: Container(
        padding: EdgeInsets.only(bottom: YSizes.sm / 2),
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
            builder:
                (context) => GestureDetector(
                  onTap: () => Scaffold.of(context).openDrawer(),
                  child: UserProfileAvatar(
                    backgroundRadius: 1,
                    foregroundRadius: 28,
                  ),
                ),
          ),
          title:
              isSearch
                  ? Hero(
                    tag: 'search-bar',
                    child: SearchContainer(
                      text: 'Search Twitter',
                      padding: EdgeInsets.zero,
                      onTap: () => Get.toNamed(Routes.searchedContentView),
                    ),
                  )
                  : Text(
                    title,
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.w200,
                      fontSize: 22,
                    ),
                  ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.settings_outlined,
                color: dark ? Colors.white : Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
