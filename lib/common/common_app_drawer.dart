import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/feature/personalization/view/user_profile/user_profile_view.dart';
import 'package:twitter_clone/routes/routes.dart';

import '../feature/personalization/view/user_profile/widget/user_profile_avatar.dart';
import '../theme/theme.dart';

import '../utils/constants/constants.dart';
import '../utils/helpers/helper_function.dart';

class CommonAppDrawer extends StatelessWidget {
  const CommonAppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunction.isDarkMode(context);

    return Drawer(
      backgroundColor: dark ? Palette.darkBackgroundColor : Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: dark ? Palette.darkBackgroundColor : Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const UserProfileAvatar(
                  backgroundRadius: 40,
                  foregroundRadius: 40,
                ),
                const SizedBox(height: YSizes.sm),
                Row(
                  children: [
                    Text(
                      'Yash Gotrijiya',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    SizedBox(width: YSizes.sm),
                    Icon(Icons.verified, color: Colors.blue),
                  ],
                ),
                Text(
                  '@yashgotrijiya',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
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
            onTap: () {
              // Handle logout
            },
          ),
        ],
      ),
    );
  }
}
