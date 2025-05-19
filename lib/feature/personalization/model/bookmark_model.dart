import 'package:cloud_firestore/cloud_firestore.dart';

class BookmarkModel {
  final String tweetId;
  final String tweetRef;
  DateTime savedAt;

  BookmarkModel({
    required this.tweetId,
    required this.tweetRef,
    required this.savedAt,
  });

  static BookmarkModel empty() =>
      BookmarkModel(tweetId: '', tweetRef: '', savedAt: DateTime.now());

  toJson() {
    return {
      'tweetId': tweetId,
      'tweetRef': tweetRef,
      'savedAt': savedAt = DateTime.now(),
    };
  }

  factory BookmarkModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data()!;
    return BookmarkModel(
      tweetId: document.id,
      tweetRef: data['tweetRef'],
      savedAt: data['savedAt'],
    );
  }
}
