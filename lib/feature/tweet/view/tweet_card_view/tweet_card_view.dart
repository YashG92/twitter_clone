import 'package:flutter/material.dart';
import 'package:twitter_clone/data/repositories/auth_repository.dart';
import 'package:twitter_clone/feature/tweet/model/tweet_model.dart';
import 'package:twitter_clone/feature/tweet/view/tweet_card_view/widgets/tweet_card_view_widget.dart';

import '../../controller/like_controller.dart';
import '../../controller/tweet_controller.dart';

class TweetCardView extends StatelessWidget {
  final String tweetId;
  final bool isVerified;
  final bool isUserStream;
  final bool showMoreOption;
  final tweetController = TweetController.instance;
  final likeController = LikeController.instance;

  TweetCardView({
    super.key,
    this.isVerified = false,
    required this.tweetId,
    this.isUserStream = false,
    required this.showMoreOption,
  }) {
    tweetController.loadTweetStream(tweetId);
    likeController.loadUserLikes();
  }

  @override
  Widget build(BuildContext context) {
    if (isUserStream) {
      tweetController.loadUserTweetStream(AuthRepository.instance.authUser.uid);
    }

    return isUserStream
        ? StreamBuilder<List<TweetModel>>(
          stream: tweetController.userTweetStream.value,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error loading tweet');
            }

            if (!snapshot.hasData) {
              return Center(child: const CircularProgressIndicator());
            }

            final tweets = snapshot.data!;
            return Column(
              children:
                  tweets
                      .map(
                        (tweet) => TweetCardViewWidget(
                          tweet: tweet,
                          showMoreOption: showMoreOption,
                        ),
                      )
                      .toList(),
            );
          },
        )
        : StreamBuilder<TweetModel>(
          stream: tweetController.tweetStream.value,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error loading tweet');
            }

            if (!snapshot.hasData) {
              return Center(child: const CircularProgressIndicator());
            }

            final tweet = snapshot.data!;
            return TweetCardViewWidget(
              tweet: tweet,
              showMoreOption: showMoreOption,
            );
          },
        );
  }
}
