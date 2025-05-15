import 'package:flutter/material.dart';
import 'package:twitter_clone/feature/home/view/widgets/tweet_card_view.dart';
import 'package:twitter_clone/feature/personalization/view/user_profile/widget/user_meta_data.dart';
import 'package:twitter_clone/feature/personalization/view/user_profile/widget/user_profile_app_bar.dart';
import 'package:twitter_clone/theme/palette.dart';
import 'package:twitter_clone/utils/constants/constants.dart';
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
          UserProfileAppBar(),

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
                UserMetaData(),
                Divider(
                  thickness: 0.3,
                  color: dark ? Palette.darkGrey : Colors.grey,
                ),
              ],
            ),
          ),
          //Tweets or Posts
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return TweetCardView(
                userName: 'Yash Gotrijiya',
                userHandle: '@yashgotrijiya',
                content: 'This is tweet number ${index + 1}. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                timeAgo: '${index + 1}h',
                commentCount: index + 1,
                retweetCount: index + 1,
                likeCount: index * 2,
                isVerified: true,
                onMorePressed: () {},
                onLikePressed: () {},
                onRetweetPressed: () {},
                onCommentPressed: () {},
                onSharePressed: () {},
              );
            }, childCount: 10),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        shape: CircleBorder(),
        child: Icon(Icons.edit),
      ),
    );
  }

  Widget _buildTweetActionButton(IconData icon, String count) {
    return Row(
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(icon, size: 18, color: Palette.darkerGrey),
        ),
        //if (count.isNotEmpty) SizedBox(width: YSizes.sm/2),
        if (count.isNotEmpty)
          Text(count, style: TextStyle(color: Palette.darkerGrey)),
      ],
    );
  }
}

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
