import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_function.dart';
import '../../../controller/user_controller.dart';

class UserMetaData extends StatelessWidget {
  const UserMetaData({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final userController = UserController.instance;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: YSizes.defaultSpace,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
            Text(
            userController.user.value.username,
            style: Theme
                .of(context)
                .textTheme
                .headlineSmall,
          ),
          SizedBox(width: YSizes.sm),
          Icon(Icons.verified, color: Colors.blue),
        ],
      ),
      Text(
        '@${userController.user.value.email}',
        style: Theme
            .of(context)
            .textTheme
            .bodySmall,
      ),
      SizedBox(height: YSizes.sm),
      Text(
        userController.user.value.bio,
      ),
      SizedBox(height: YSizes.sm),
      Row(
        children: [
          Icon(CupertinoIcons.location_solid),
          SizedBox(width: YSizes.sm),
          Text(
            'Rajkot India',
            style: Theme
                .of(context)
                .textTheme
                .bodySmall,
          ),
        ],
      ),
      SizedBox(height: YSizes.sm),
      Row(
        children: [
          Icon(Icons.calendar_today),
          SizedBox(width: YSizes.sm),
          Text(
            HelperFunction.formatDate(userController.user.value.createdAt),
            style: Theme
                .of(context)
                .textTheme
                .bodySmall,
          ),
        ],
      ),
      SizedBox(height: YSizes.sm),
      Row(
        children: [
          Text(
            '${userController.user.value.followerCount} Followers',
            style: Theme
                .of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: YSizes.spaceBtwItems),
          Text(
            '${userController.user.value.followingCount} Following',
            style: Theme
                .of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      ],
    ),);
  }
}