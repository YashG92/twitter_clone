import 'package:cloud_firestore/cloud_firestore.dart';

class RetweetModel {
  final String tweetId;
  final String originalTweetRef;
  DateTime retweetedAt;

  RetweetModel({
    required this.tweetId,
    required this.originalTweetRef,
    required this.retweetedAt,
  });

  static RetweetModel empty() => RetweetModel(
    tweetId: '',
    originalTweetRef: '',
    retweetedAt: DateTime.now(),
  );

  toJson() {
    return {
      'tweetId': tweetId,
      'originalTweetRef': originalTweetRef,
      'retweetedAt': retweetedAt = DateTime.now(),
    };
  }

  factory RetweetModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data()!;
    return RetweetModel(
      tweetId: document.id,
      originalTweetRef: data['originalTweetRef'],
      retweetedAt: data['retweetedAt'],
    );
  }
}
