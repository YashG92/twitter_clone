import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/data/repositories/auth_repository.dart';
import 'package:twitter_clone/routes/routes.dart';

import '../feature/personalization/controller/user_controller.dart';
import '../feature/personalization/view/user_profile/widget/user_profile_avatar.dart';
import '../theme/theme.dart';

import '../utils/constants/constants.dart';
import '../utils/helpers/helper_function.dart';

class CommonAppDrawer extends StatelessWidget {
  const CommonAppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunction.isDarkMode(context);
    final userController = UserController.instance;
    return Drawer(
      backgroundColor: dark ? Palette.darkBackgroundColor : Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 225,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: dark ? Palette.darkBackgroundColor : Colors.white,
              ),
              child: GestureDetector(
                onTap: () => Get.toNamed(Routes.userProfileView),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserProfileAvatar(
                      backgroundRadius: 40,
                      foregroundRadius: 40,
                      imageUrl: userController.user.value.profileImage,
                    ),
                    const SizedBox(height: YSizes.sm),
                    Row(
                      children: [
                        Text(
                          userController.user.value.username,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        SizedBox(width: YSizes.sm),
                        Icon(Icons.verified, color: Colors.blue),
                      ],
                    ),
                    Text(
                      '@${userController.user.value.email.split('@').first}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Row(
                      children: [
                        Text(
                          '${userController.user.value.followerCount} Followers',
                          style: Theme.of(context).textTheme.headlineSmall!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: YSizes.spaceBtwItems),
                        Text(
                          '${userController.user.value.followingCount} Following',
                          style: Theme.of(context).textTheme.headlineSmall!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.person_outlined,
              color: dark ? Colors.white : Colors.blue,
            ),
            title: Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Get.toNamed(Routes.userProfileView);
              // Navigate to profile
            },
          ),
          ListTile(
            leading: Icon(
              Icons.list_alt,
              color: dark ? Colors.white : Colors.blue,
            ),
            title: Text('Lists'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to profile
            },
          ),
          ListTile(
            leading: Icon(
              Icons.bookmark_outline_sharp,
              color: dark ? Colors.white : Colors.blue,
            ),
            title: Text('Bookmarks'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to bookmarks
            },
          ),
          ListTile(
            leading: Icon(
              Icons.timeline_outlined,
              color: dark ? Colors.white : Colors.blue,
            ),
            title: Text('Moments'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to bookmarks
            },
          ),
          ListTile(
            leading: Icon(
              Icons.settings_outlined,
              color: dark ? Colors.white : Colors.blue,
            ),
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to settings
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: dark ? Colors.white : Colors.blue,
            ),
            title: Text('Log out'),
            onTap: () => AuthRepository.instance.logoutUser(),
          ),
        ],
      ),
    );
  }
}
