import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String commentId;
  final String parentTweetId;
  final String userId;
  final DateTime createdAt;

  CommentModel({
    required this.commentId,
    required this.userId,
    required this.parentTweetId,
    required this.createdAt,
  });

  factory CommentModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CommentModel(
      commentId: data['commentId'],
      userId: data['userId'],
      parentTweetId: data['tweetId'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commentId': commentId,
      'userId': userId,
      'tweetId': parentTweetId,
      'createdAt': createdAt,
    };
  }
}