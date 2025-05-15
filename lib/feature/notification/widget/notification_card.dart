import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/constants.dart';
import '../../personalization/view/user_profile/widget/user_profile_avatar.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Icon(CupertinoIcons.heart_fill, color: Colors.red, size: 28),
        ),
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: YSizes.sm,
                children: [
                  UserProfileAvatar(backgroundRadius: 20, foregroundRadius: 20),
                  UserProfileAvatar(backgroundRadius: 20, foregroundRadius: 20),
                  UserProfileAvatar(backgroundRadius: 20, foregroundRadius: 20),
                ],
              ),
              SizedBox(height: YSizes.sm),
              Text(
                '2 people like your tweet',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: YSizes.sm),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
