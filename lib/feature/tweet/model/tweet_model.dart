import 'package:cloud_firestore/cloud_firestore.dart';

class TweetModel {
  final String tweetId;
  String content;
  final String authorId;
  String authorHandle;
  int likeCount;
  int replyCount;
  int retweetCount;
  List<String>? imageUrls;
  String? parentTweetId;
  bool isRetweet;
  String? originalTweetId; //for retweet
  DateTime createdAt;

  TweetModel({
    required this.tweetId,
    required this.content,
    required this.authorId,
    required this.authorHandle,
    required this.createdAt,
    this.likeCount = 0,
    this.replyCount = 0,
    this.retweetCount = 0,
    this.imageUrls,
    this.parentTweetId,
    this.isRetweet = false,
    this.originalTweetId,
  });

  static TweetModel empty() => TweetModel(
    tweetId: '',
    content: '',
    authorId: '',
    authorHandle: '',
    likeCount: 0,
    replyCount: 0,
    retweetCount: 0,
    imageUrls: [],
    parentTweetId: '',
    isRetweet: false,
    originalTweetId: '',
    createdAt: DateTime.now(),
  );

  toJson() {
    return {
      'tweetId': tweetId,
      'content': content,
      'authorId': authorId,
      'authorHandle': authorHandle,
      'likeCount': likeCount,
      'replyCount': replyCount,
      'retweetCount': retweetCount,
      'imageUrls': imageUrls,
      'parentTweetId': parentTweetId,
      'isRetweet': isRetweet,
      'originalTweetId': originalTweetId,
      'createdAt': createdAt,
    };
  }

  factory TweetModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data()!;
    return TweetModel(
      tweetId: document.id,
      content: data['content'] ?? '',
      authorId: data['authorId'] ?? '',
      authorHandle: data['authorHandle'] ?? '',
      likeCount: data['likeCount'] ?? 0,
      replyCount: data['replyCount'] ?? 0,
      retweetCount: data['retweetCount'] ?? 0,
      imageUrls: data['imageUrls'] ?? [],
      parentTweetId: data['parentTweetId'] ?? '',
      isRetweet: data['isRetweet'] ?? false,
      originalTweetId: data['originalTweetId'] ?? '',
      createdAt: data['createdAt'],
    );
  }
}
