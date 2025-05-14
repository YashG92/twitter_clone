import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/theme/palette.dart';
import 'package:twitter_clone/utils/constants/constants.dart';
import 'package:twitter_clone/utils/constants/image_strings.dart';
import 'package:twitter_clone/utils/helpers/helper_function.dart';

class UserProfileView extends StatelessWidget {
  const UserProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunction.isDarkMode(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          //AppBar with cover picture
          SliverAppBar(
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
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(color: Colors.white),
                              ),
                              Text(
                                '5 posts',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
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
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor:
                              dark ? Palette.darkGrey : Colors.white,
                          child: CircleAvatar(
                            radius: 48,
                            backgroundImage: AssetImage(
                              ImageStrings.coverPicture,
                            ),
                          ),
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
          ),

          //Profile Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Profile pic and edit button
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(YSizes.productImageRadius),
                    child: OutlinedButton(
                      onPressed: () {},
                      child: Text(
                        'Edit Profile',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: dark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                //SizedBox(height: YSizes.spaceBtwItems,),

                //User Info
                Padding(
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
                ),
                Divider(
                  thickness: 0.3,
                  color: dark ? Palette.darkGrey : Colors.grey,
                ),

                // ListTile(
                //   contentPadding: EdgeInsets.zero,
                //   leading: CircleAvatar(
                //     backgroundImage: AssetImage(ImageStrings.profilePicture),
                //   ),
                //   title: Row(
                //     children: [
                //       Flexible(
                //         child: Text(
                //           'Yash Gotrijiya',
                //           style: TextStyle(fontWeight: FontWeight.bold),
                //           overflow: TextOverflow.ellipsis,
                //         ),
                //       ),
                //       SizedBox(width: YSizes.sm / 2),
                //       Icon(Icons.verified, size: 16, color: Colors.blue),
                //       SizedBox(width: YSizes.sm / 2),
                //       Flexible(
                //         child: Text(
                //           '@TheAlphamerc • 20m',
                //           style: TextStyle(color: Colors.grey),
                //           overflow: TextOverflow.ellipsis,
                //         ),
                //       ),
                //       IconButton(
                //         onPressed: () {},
                //         icon: Icon(Icons.more_vert, size: 18),
                //         padding: EdgeInsets.zero,
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
          //Tweets or Posts
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.only(bottom: YSizes.sm),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 0.3,
                        color: dark ? Palette.darkGrey : Colors.grey.shade200,
                      ),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage(ImageStrings.coverPicture),
                      ),
                      SizedBox(width: YSizes.spaceBtwItems),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Yash Gotrijiya',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(width: 4),
                                Icon(
                                  Icons.verified,
                                  size: 16,
                                  color: Colors.blue,
                                ),
                                SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    '@yashgotrijiya • ${index + 1}h',
                                    style: TextStyle(color: Colors.grey),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Spacer(),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.more_vert, size: 18),
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                ),
                              ],
                            ),
                            //SizedBox(height: YSizes.sm),
                            Text(
                              'This is tweet number ${index + 1}. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                            ),
                            SizedBox(height: YSizes.spaceBtwItems),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildTweetActionButton(
                                  Icons.chat_bubble_outline,
                                  '${index + 1}',
                                ),
                                _buildTweetActionButton(
                                  Icons.repeat,
                                  '${index + 1}',
                                ),
                                _buildTweetActionButton(
                                  Icons.favorite_border,
                                  '${index * 2}',
                                ),
                                _buildTweetActionButton(Icons.share, ''),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }, childCount: 10),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.edit),
      ),
    );
  }

  Widget _buildTweetActionButton(IconData icon, String count) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        if (count.isNotEmpty) SizedBox(width: 4),
        if (count.isNotEmpty) Text(count, style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}
