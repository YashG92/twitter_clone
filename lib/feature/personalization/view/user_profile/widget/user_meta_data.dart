import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/constants/sizes.dart';

class UserMetaData extends StatelessWidget {
  const UserMetaData({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
          SizedBox(height: YSizes.sm),
          Text(
            'Some random bio description blah blahblahblahblahblahblah',
          ),
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
                'Joined March 2020',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          SizedBox(height: YSizes.sm),
          Row(
            children: [
              Text(
                '4 Followers',
                style: Theme.of(context).textTheme.headlineSmall!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(width: YSizes.spaceBtwItems),
              Text(
                '5 Following',
                style: Theme.of(context).textTheme.headlineSmall!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}