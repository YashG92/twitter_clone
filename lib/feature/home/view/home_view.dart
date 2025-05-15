import 'package:flutter/material.dart';
import 'package:twitter_clone/common/custom_appbar.dart';
import 'package:twitter_clone/feature/home/view/widgets/tweet_card_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'Home'),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return TweetCardView(
                userName: 'Yash Gotrijiya',
                userHandle: '@yashgotrijiya',
                content:
                    'This is tweet number ${index + 1}. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
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
}
