import 'package:cloud_firestore/cloud_firestore.dart';

class RetweetModel {
  final String reTweetId;
  final String originalTweetRef;
  DateTime retweetedAt;

  RetweetModel({
    required this.reTweetId,
    required this.originalTweetRef,
    required this.retweetedAt,
  });

  static RetweetModel empty() => RetweetModel(
    reTweetId: '',
    originalTweetRef: '',
    retweetedAt: DateTime.now(),
  );

  toJson() {
    return {
      'tweetId': reTweetId,
      'originalTweetRef': originalTweetRef,
      'retweetedAt': retweetedAt = DateTime.now(),
    };
  }

  factory RetweetModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data()!;
    return RetweetModel(
      reTweetId: document.id,
      originalTweetRef: data['originalTweetRef'],
      retweetedAt: data['retweetedAt'],
    );
  }
}
