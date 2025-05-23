import 'package:cloud_firestore/cloud_firestore.dart';

class TweetModel {
  String tweetId;
  String content;
  final String authorId;
  String authorHandle;
  String authorProfileImage;
  int likeCount;
  int replyCount;
  int retweetCount;
  List<String>? imageUrls;
  String? parentTweetId;
  List<String>? reTweetedBy;
  final String? reTweetType;
  bool isRetweet;
  String? originalTweetId; //for retweet
  DateTime createdAt;

  TweetModel({
    required this.tweetId,
    required this.content,
    required this.authorId,
    required this.authorHandle,
    required this.createdAt,
    required this.authorProfileImage,
    this.likeCount = 0,
    this.replyCount = 0,
    this.retweetCount = 0,
    this.imageUrls,
    this.parentTweetId,
    this.reTweetedBy,
    this.reTweetType,
    this.isRetweet = false,
    this.originalTweetId,
  });

  static TweetModel empty() => TweetModel(
    tweetId: '',
    content: '',
    authorId: '',
    authorHandle: '',
    authorProfileImage: '',
    likeCount: 0,
    replyCount: 0,
    retweetCount: 0,
    reTweetType: '',
    imageUrls: [],
    parentTweetId: '',
    reTweetedBy: [],
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
      'authorProfileImage': authorProfileImage,
      'likeCount': likeCount,
      'replyCount': replyCount,
      'retweetCount': retweetCount,
      'imageUrls': imageUrls,
      'reTweetedBy': reTweetedBy,
      'reTweetType': reTweetType,
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
      authorProfileImage: data['authorProfileImage'] ?? '',
      likeCount: data['likeCount'] ?? 0,
      replyCount: data['replyCount'] ?? 0,
      retweetCount: data['retweetCount'] ?? 0,
      imageUrls:
          data['imageUrls'] != null ? List<String>.from(data['imageUrls']) : [],
      reTweetedBy:
          data['reTweetedBy'] != null
              ? List<String>.from(data['reTweetedBy'])
              : [],
      parentTweetId: data['parentTweetId'] ?? '',
      isRetweet: data['isRetweet'] ?? false,
      reTweetType: data['reTweetType'] ?? '',
      originalTweetId: data['originalTweetId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
