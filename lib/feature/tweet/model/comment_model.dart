import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String commentId;
  final String tweetId;
  final String userId;
  final String userHandle;
  final String userProfileImage;
  final String content;
  final DateTime createdAt;
  final int likeCount;

  CommentModel({
    required this.commentId,
    required this.tweetId,
    required this.userId,
    required this.userHandle,
    required this.userProfileImage,
    required this.content,
    required this.createdAt,
    this.likeCount = 0,
  });

  factory CommentModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CommentModel(
      commentId: doc.id,
      tweetId: data['tweetId'],
      userId: data['userId'],
      userHandle: data['userHandle'],
      userProfileImage: data['userProfileImage'],
      content: data['content'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      likeCount: data['likeCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tweetId': tweetId,
      'userId': userId,
      'userHandle': userHandle,
      'userProfileImage': userProfileImage,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
      'likeCount': likeCount,
    };
  }
}