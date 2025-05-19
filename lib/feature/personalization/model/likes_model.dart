import 'package:cloud_firestore/cloud_firestore.dart';

class LikesModel {
  final String tweetId;
  final String tweetRef;
  DateTime likedAt;

  LikesModel({
    required this.tweetId,
    required this.tweetRef,
    required this.likedAt,
  });

  static LikesModel empty() =>
      LikesModel(tweetId: '', tweetRef: '', likedAt: DateTime.now());

  toJson() {
    return {
      'tweetId': tweetId,
      'tweetRef': tweetRef,
      'likedAt': likedAt = DateTime.now(),
    };
  }

  factory LikesModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data()!;
    return LikesModel(
      tweetId: document.id,
      tweetRef: data['tweetRef'],
      likedAt: data['likedAt'],
    );
  }
}
