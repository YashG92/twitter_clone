import 'package:flutter/material.dart';

import '../../model/tweet_model.dart';

class TweetImageGrid extends StatelessWidget {
  const TweetImageGrid({super.key, required this.tweet});

  final TweetModel tweet;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: tweet.imageUrls!.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            tweet.imageUrls![index],
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.broken_image, color: Colors.grey);
            },
          ),
        );
      },
    );
  }
}
