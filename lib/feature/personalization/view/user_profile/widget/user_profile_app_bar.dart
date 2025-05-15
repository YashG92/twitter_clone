import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:twitter_clone/feature/personalization/view/user_profile/widget/user_profile_avatar.dart';
import '../../../../../utils/constants/constants.dart';
import '../../../../../utils/helpers/helper_function.dart';

class UserProfileAppBar extends StatelessWidget {
  const UserProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunction.isDarkMode(context);

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
              Image.asset(ImageStrings.coverPicture, fit: BoxFit.cover),

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
                        SizedBox(height: YSizes.spaceBtwSections),
                        Text(
                          'Yash Gotrijiya',
                          style: Theme.of(context).textTheme.headlineSmall!
                              .copyWith(color: Colors.white),
                        ),
                        Text(
                          '5 posts',
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
                    backgroundRadius: 50,
                    foregroundRadius: 48,
                  ),
                ),
            ],
          );
        },
      ),
      leading: IconButton(
        onPressed: () {},
        icon: Icon(Icons.arrow_back, color: Colors.white),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.more_vert, color: Colors.white),
        ),
      ],
    );
  }
}
