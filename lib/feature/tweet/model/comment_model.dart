import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String commentId;
  String content;
  final String authorId;
  int likeCount;
  DateTime createdAt;

  CommentModel({
    required this.commentId,
    required this.content,
    required this.authorId,
    this.likeCount = 0,
    required this.createdAt,
  });

  static CommentModel empty() => CommentModel(
    commentId: '',
    content: '',
    authorId: '',
    likeCount: 0,
    createdAt: DateTime.now(),
  );

  toJson() {
    return {
      'commentId': commentId,
      'content': content,
      'authorId': authorId,
      'likeCount': likeCount,
      'createdAt': createdAt = DateTime.now(),
    };
  }

  factory CommentModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data()!;
    return CommentModel(
      commentId: document.id,
      content: data['content'] ?? '',
      authorId: data['authorId'] ?? '',
      likeCount: data['likeCount'] ?? 0,
      createdAt: data['createdAt'],
    );
  }
}
