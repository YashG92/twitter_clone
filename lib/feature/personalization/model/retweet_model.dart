import 'package:cloud_firestore/cloud_firestore.dart';

enum ReTweetType { retweet, quote }

class RetweetModel {
  final String reTweetId;
  final String originalTweetRef;
  final String reTweetType;
  final String userId;
  DateTime retweetedAt;

  RetweetModel({
    required this.reTweetId,
    required this.originalTweetRef,
    required this.reTweetType,
    required this.userId,
    required this.retweetedAt,
  });

  static RetweetModel empty() => RetweetModel(
    reTweetId: '',
    originalTweetRef: '',
    reTweetType: '',
    userId: '',
    retweetedAt: DateTime.now(),
  );

  toJson() {
    return {
      'reTweetId': reTweetId,
      'originalTweetRef': originalTweetRef,
      'reTweetType': reTweetType,
      'userId': userId,
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
      reTweetType: data['reTweetType'],
      userId: data['userId'],
      retweetedAt: data['retweetedAt'],
    );
  }
}
