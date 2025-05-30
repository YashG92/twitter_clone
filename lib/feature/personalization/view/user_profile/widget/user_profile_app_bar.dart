import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/feature/personalization/view/user_profile/widget/user_profile_avatar.dart';
import '../../../../../utils/constants/constants.dart';
import '../../../model/user_model.dart';

class UserProfileAppBar extends StatelessWidget {
  const UserProfileAppBar({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    //final dark = HelperFunction.isDarkMode(context);

    return SliverAppBar(
      expandedHeight: 150,
      pinned: true,
      floating: false,
      clipBehavior: Clip.none,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final top = constraints.biggest.height;
          final isCollapsed =
              top <= kToolbarHeight + MediaQuery.of(context).padding.top;

          return Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.none,
            children: [
              Image.network(
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    ImageStrings.coverPicture,
                    fit: BoxFit.cover,
                  );
                },
                user.coverImage,
                fit: BoxFit.cover,
              ),
              if (isCollapsed)
                ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(color: Colors.transparent),
                  ),
                ),
              if (isCollapsed)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: YSizes.appBarHeight,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: YSizes.spaceBtwSections),
                        Text(
                          user.username,
                          style: Theme.of(context).textTheme.headlineSmall!
                              .copyWith(color: Colors.white),
                        ),
                        Text(
                          '${user.tweetCount} posts',
                          style: Theme.of(context).textTheme.headlineSmall!
                              .copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              if (!isCollapsed)
                Positioned(
                  bottom: -70,
                  left: YSizes.defaultSpace,
                  child: UserProfileAvatar(
                    backgroundRadius: 52,
                    foregroundRadius: 50,
                    imageUrl: user.profileImage,
                  ),
                ),
            ],
          );
        },
      ),
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(Icons.arrow_back, color: Colors.white),
      ),
      // actions: [
      //   IconButton(
      //     onPressed: () {},
      //     icon: const Icon(Icons.more_vert, color: Colors.white),
      //   ),
      // ],
    );
  }
}
