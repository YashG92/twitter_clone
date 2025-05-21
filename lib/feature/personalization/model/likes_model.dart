import 'package:cloud_firestore/cloud_firestore.dart';

class LikesModel {
  final String tweetId;
  final String userId;
  final DocumentReference? tweetRef;
  DateTime likedAt;

  LikesModel({
    required this.tweetId,
    required this.userId,
    required this.likedAt,
    this.tweetRef,
  });

  static LikesModel empty() =>
      LikesModel(tweetId: '', userId: '', likedAt: DateTime.now());

  toJson() {
    return {
      'tweetId': tweetId,
      'userId': userId,
      'likedAt': likedAt,
      if (tweetRef != null) 'tweetRef': tweetRef,
    };
  }

  factory LikesModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data()!;
    return LikesModel(
      tweetId: data['tweetId'] ?? document.id,
      userId: data['userId'] ?? '',
      likedAt: (data['likedAt'] as Timestamp).toDate(),
      tweetRef: data['tweetRef'] as DocumentReference?,
    );
  }
}
