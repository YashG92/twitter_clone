import 'package:cloud_firestore/cloud_firestore.dart';

class FollowersModel {
  final String followerId;
  final String userId;
  DateTime followedAt;

  FollowersModel({
    required this.followerId,
    required this.userId,
    required this.followedAt,
  });

  static FollowersModel empty() =>
      FollowersModel(followerId: '', userId: '', followedAt: DateTime.now());

  toJson() {
    return {'userId': userId, 'followedAt': followedAt};
  }

  factory FollowersModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data()!;
    return FollowersModel(
      followerId: document.id,
      userId: data['userId'],
      followedAt: data['followedAt']?.toDate() ?? DateTime.now(),
    );
  }
}
