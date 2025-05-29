import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/routes/routes.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_function.dart';
import '../../../model/user_model.dart';

class UserMetaData extends StatelessWidget {
  const UserMetaData({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: YSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            user.username,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            '@${user.email.split('@')[0]}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text(user.bio),
          SizedBox(height: YSizes.sm),
          Row(
            children: [
              Icon(CupertinoIcons.location_solid),
              SizedBox(width: YSizes.sm),
              Text(
                'Rajkot India',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          SizedBox(height: YSizes.sm),
          Row(
            children: [
              Icon(Icons.calendar_today),
              SizedBox(width: YSizes.sm),
              Text(
                HelperFunction.formatDate(user.createdAt),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          SizedBox(height: YSizes.sm),
          Row(
            children: [
              GestureDetector(
                onTap:
                    () => Get.toNamed(
                      Routes.followersView,
                      arguments: user.userId,
                    ),
                child: Text(
                  '${user.followerCount} Followers',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: YSizes.spaceBtwItems),
              GestureDetector(
                onTap:
                    () => Get.toNamed(
                      Routes.followingView,
                      arguments: user.userId,
                    ),
                child: Text(
                  '${user.followingCount} Following',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
